import GeospatialSwift

public extension GeoJson.Polygon {
    func cocoaContains(_ point: GeodesicPoint, errorDistance: Double) -> Bool {
        let polygonCoordinates = linearRings.first!.points.map { $0.locationCoordinate }
        
        let polygonOverlay = MKPolygon(coordinates: polygonCoordinates, count: polygonCoordinates.count)
        
        let polygonRenderer = MKPolygonRenderer(overlay: polygonOverlay)
        
        let mapPoint: MKMapPoint = MKMapPoint(point.locationCoordinate)
        let polygonViewPoint: CGPoint = polygonRenderer.point(for: mapPoint)
        
        guard errorDistance >= 0 else { return distance(to: point) > abs(errorDistance) && polygonRenderer.path.contains(polygonViewPoint) }
        
        return distance(to: point) > errorDistance ? polygonRenderer.path.contains(polygonViewPoint) : true
    }
}
