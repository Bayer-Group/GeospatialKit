import MapKit
import GeospatialSwift

internal struct AnnotationGenerator {
    func annotations(for geoJsonObject: GeoJsonObject, withProperties properties: [String: Any], debug: Bool) -> [GeospatialMapAnnotation] {
        return geoJsonObject.objectGeometries.flatMap { annotations(for: $0, withProperties: properties, debug: debug) }
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
        case let point as GeoJson.Point:
            annotations += [annotation(for: point, withProperties: properties)]
        case let multiPoint as GeoJson.MultiPoint:
            annotations += multiPoint.points.map { annotation(for: $0, withProperties: properties) }
        case let polygon as GeoJson.Polygon:
            if debug { annotations += [annotation(for: polygon.centroid, withProperties: properties)] }
        case let multiLine as GeoJson.MultiLineString:
            if debug { annotations += multiLine.points.map { annotation(for: $0, withProperties: properties) } }
        case let multiPolygon as GeoJson.MultiPolygon:
            if debug { annotations += multiPolygon.polygons.map { annotation(for: $0.centroid, withProperties: properties) } }
        case let geometryCollection as GeoJson.GeometryCollection:
            annotations += geometryCollection.objectGeometries.flatMap { self.annotations(for: $0, withProperties: properties, debug: debug) }
        default:
            ()
        }
        
        if debug, let coordinatesGeometry = geometry as? GeoJsonCoordinatesGeometry, !(coordinatesGeometry is GeoJson.Point) {
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
