public extension GeodesicBoundingBox {
    internal var imageMinimumAdjustment: Double { return 0.00005 }
    
    public var region: MKCoordinateRegion {
        let span = MKCoordinateSpan(latitudeDelta: latitudeDelta, longitudeDelta: longitudeDelta)
        
        let center = CLLocationCoordinate2D(latitude: centroid.latitude, longitude: centroid.longitude)
        
        return MKCoordinateRegion(center: center, span: span)
    }
    
    public func mappingBoundingBox(insetPercent: Double) -> GeodesicBoundingBox {
        return validBoundingBox(minimumAdjustment: imageMinimumAdjustment).insetBoundingBox(percent: insetPercent)
    }
}
