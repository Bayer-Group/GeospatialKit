internal protocol AnnotationGeneratorProtocol {
    func annotations(for geoJsonObject: GeoJsonObject, withProperties properties: [String: Any], debug: Bool) -> [GeospatialMapAnnotation]
    func annotationView(for annotation: MKAnnotation, with overlayRenderModel: OverlayRenderModel, from mapView: MKMapView, reuseId: String) -> MKAnnotationView
}

internal struct AnnotationGenerator: AnnotationGeneratorProtocol {
    func annotations(for geoJsonObject: GeoJsonObject, withProperties properties: [String: Any], debug: Bool) -> [GeospatialMapAnnotation] {
        guard let geometries = geoJsonObject.objectGeometries else { Log.info("No geometry objects for: \(geoJsonObject.geoJson)."); return [] }
        
        return geometries.flatMap { annotations(for: $0, withProperties: properties, debug: debug) }
    }
    
    func annotationView(for annotation: MKAnnotation, with overlayRenderModel: OverlayRenderModel, from mapView: MKMapView, reuseId: String) -> MKAnnotationView {
        let reusableAnnotationView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        let pinView = reusableAnnotationView ?? MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
        
        if let pinTintColor = overlayRenderModel.pinTintColor { pinView.pinTintColor = pinTintColor }
        
        pinView.annotation = annotation
        
        return pinView
    }
    
    // swiftlint:disable:next cyclomatic_complexity
    private func annotations(for geometry: GeoJsonGeometry, withProperties properties: [String: Any], debug: Bool) -> [GeospatialMapAnnotation] {
        var annotations: [GeospatialMapAnnotation] = []
        
        switch geometry {
        case let point as GeoJsonPoint:
            annotations += [annotation(for: point, withProperties: properties)]
        case let multiPoint as GeoJsonMultiPoint:
            annotations += multiPoint.points.map { annotation(for: $0, withProperties: properties) }
        case let polygon as GeoJsonPolygon:
            if debug { annotations += [annotation(for: polygon.centroid, withProperties: properties)] }
        case let multiLine as GeoJsonMultiLineString:
            if debug { annotations += multiLine.points.map { annotation(for: $0, withProperties: properties) } }
        case let multiPolygon as GeoJsonMultiPolygon:
            if debug { annotations += multiPolygon.polygons.map { annotation(for: $0.centroid, withProperties: properties) } }
        case let geometryCollection as GeoJsonGeometryCollection:
            annotations += geometryCollection.objectGeometries?.flatMap { self.annotations(for: $0, withProperties: properties, debug: debug) } ?? []
        default:
            ()
        }
        
        if debug, let coordinatesGeometry = geometry as? GeoJsonCoordinatesGeometry, !(coordinatesGeometry is GeoJsonPoint) {
            return annotations + coordinatesGeometry.points.map { annotation(for: $0, withProperties: properties) }
        }
        
        return annotations
    }
    
    private func annotation(for point: GeodesicPoint, withProperties properties: [String: Any]) -> GeospatialMapAnnotation {
        let annotation = GeospatialPointAnnotation(properties: properties)
        annotation.coordinate = point.locationCoordinate
        
        return annotation
    }
}
