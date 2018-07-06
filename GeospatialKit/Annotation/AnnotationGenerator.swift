internal protocol AnnotationGeneratorProtocol {
    func annotations(for geoJsonObject: GeoJsonObject, debug: Bool) -> [MKAnnotation]
}

internal struct AnnotationGenerator: AnnotationGeneratorProtocol {
    func annotations(for geoJsonObject: GeoJsonObject, debug: Bool) -> [MKAnnotation] {
        guard let geometries = geoJsonObject.objectGeometries else { Log.info("No geometry objects for: \(geoJsonObject.geoJson)."); return [] }
        
        return geometries.flatMap { annotations(for: $0, debug: debug) }
    }
    
    // swiftlint:disable:next cyclomatic_complexity
    private func annotations(for geometry: GeoJsonGeometry, debug: Bool) -> [MKAnnotation] {
        var annotations: [MKAnnotation] = []
        
        switch geometry {
        case let point as GeoJsonPoint:
            annotations += [annotation(for: point)]
        case let multiPoint as GeoJsonMultiPoint:
            annotations += multiPoint.points.compactMap { annotation(for: $0) }
        case let polygon as GeoJsonPolygon:
            if debug { annotations += [annotation(for: polygon.centroid)] }
        case let multiLine as GeoJsonMultiLineString:
            if debug { annotations += multiLine.points.compactMap { annotation(for: $0) } }
        case let multiPolygon as GeoJsonMultiPolygon:
            if debug { annotations += multiPolygon.polygons.compactMap { annotation(for: $0.centroid) } }
        case let geometryCollection as GeoJsonGeometryCollection:
            annotations += geometryCollection.objectGeometries?.flatMap { self.annotations(for: $0, debug: debug) } ?? []
        default:
            ()
        }
        
        if debug, let multiCoordinatesGeometry = geometry as? GeoJsonMultiCoordinatesGeometry {
            return annotations + multiCoordinatesGeometry.points.flatMap { self.annotations(for: $0, debug: debug) }
        }
        
        return annotations
    }
    
    private func annotation(for point: GeodesicPoint) -> MKAnnotation {
        let annotation = MKPointAnnotation()
        annotation.coordinate = point.locationCoordinate
        
        return annotation
    }
}
