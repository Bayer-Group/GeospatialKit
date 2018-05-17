internal protocol AnnotationGeneratorProtocol {
    func annotations(for geoJsonObject: GeoJsonObject, debug: Bool) -> [MKAnnotation]
}

internal struct AnnotationGenerator: AnnotationGeneratorProtocol {
    let calculator: GeodesicCalculatorProtocol
    
    func annotations(for geoJsonObject: GeoJsonObject, debug: Bool) -> [MKAnnotation] {
        guard let geometries = geoJsonObject.objectGeometries else { Log.info("No geometry objects for: \(geoJsonObject.geoJson)."); return [] }
        
        return geometries.flatMap { annotations(for: $0, debug: debug) }
    }
    
    private func annotations(for geometry: GeoJsonGeometry, debug: Bool) -> [MKAnnotation] {
        var annotations: [MKAnnotation] = []
        
        switch geometry {
        case let point as GeoJsonPoint:
            annotations += [annotation(for: point)]
        case let multiPoint as GeoJsonMultiPoint:
            #if swift(>=4.1)
            annotations += multiPoint.points.compactMap { annotation(for: $0) }
            #else
            annotations += multiPoint.points.flatMap { annotation(for: $0) }
            #endif
        case let polygon as GeoJsonPolygon:
            if debug {
                if polygon.linearRings.count > 1 {
                    annotations += polygon.linearRings.map { annotation(for: calculator.centroid(linearRingSegments: $0.segments)) }
                }
            }
        case let geometryCollection as GeoJsonGeometryCollection:
            annotations += geometryCollection.objectGeometries?.flatMap { self.annotations(for: $0, debug: debug) } ?? []
        default:
            ()
        }
        
        if debug, let multiCoordinatesGeometry = geometry as? GeoJsonMultiCoordinatesGeometry {
            return annotations + [annotation(for: multiCoordinatesGeometry.centroid)] + multiCoordinatesGeometry.points.flatMap { self.annotations(for: $0, debug: debug) }
        }
        
        return annotations
    }
    
    private func annotation(for point: GeodesicPoint) -> MKAnnotation {
        let annotation = MKPointAnnotation()
        annotation.coordinate = point.locationCoordinate
        
        return annotation
    }
}
