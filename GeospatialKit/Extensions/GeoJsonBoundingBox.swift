public extension GeoJsonBoundingBox {
    internal var imageMinimumAdjustment: Double { return 0.00005 }
    internal var mapRegionInset: Double { return 1.2 }
    
    public var region: MKCoordinateRegion {
        let coordinateSpan = MKCoordinateSpanMake(latitudeDelta * mapRegionInset, longitudeDelta * mapRegionInset)
        
        let centerCoordinate = CLLocationCoordinate2D(latitude: centroid.latitude, longitude: centroid.longitude)
        
        return MKCoordinateRegionMake(centerCoordinate, coordinateSpan)
    }
    
    public var imageBoundingBox: GeoJsonBoundingBox { return adjusted(minimumAdjustment: imageMinimumAdjustment) }
}
