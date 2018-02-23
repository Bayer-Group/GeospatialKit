internal struct PointProjector {
    private let insetPercent = 0.20
    
    private let scale: Double
    private let projectedOffset: (x: Double, y: Double)
    
    // Future: Could add option for rotation for other projections
    // Future: Could add a coordinate system rather than width and height which might not assume (0,0) as the base coordinate
    init(boundingBox: GeoJsonBoundingBox, width: Double, height: Double) {
        // Rotated 90 degrees for UIView coordinate system, MKMapPoint representing upper left corner of geometry bounds
        let projectedUpperLeft = MKMapPointForCoordinate(CLLocationCoordinate2D(latitude: boundingBox.maxLatitude, longitude: boundingBox.minLongitude))
        
        // Rotated 90 degrees for UIView coordinate system, MKMapPoint representing lower right corner of geometry bounds
        let projectedLowerRight = MKMapPointForCoordinate(CLLocationCoordinate2D(latitude: boundingBox.minLatitude, longitude: boundingBox.maxLongitude))
        
        let projectedWidth = projectedLowerRight.x - projectedUpperLeft.x
        let projectedHeight = projectedLowerRight.y - projectedUpperLeft.y
        
        // Max width and height to fit with the inset.
        let maxWidth = width - (width * insetPercent)
        let maxHeight = height - (height * insetPercent)
        
        // Scale to convert projected scale to fit the UIView scale.
        scale = min(maxWidth / projectedWidth, maxHeight / projectedHeight)
        
        // Insets set to width and height scale
        let insetX = (width - (projectedWidth * scale)) / 2
        let insetY = (height - (projectedHeight * scale)) / 2
        
        // Convert the minimum projected coordinate to the expected scale
        let scaledProjectedMinX = projectedUpperLeft.x * scale
        let scaledProjectedMinY = projectedUpperLeft.y * scale
        
        // Offset to convert a projected coordinate to the expected coordinate system minus inset.
        projectedOffset = (x: scaledProjectedMinX - insetX, y: scaledProjectedMinY - insetY)
    }
    
    func asPoints(_ points: [GeodesicPoint]) -> [CGPoint] {
        return points.map { point in
            let projectedCoordinate = MKMapPointForCoordinate(CLLocationCoordinate2D(latitude: point.latitude, longitude: point.longitude))
            
            // Convert to the expected scale
            let scaledProjectedX = projectedCoordinate.x * scale
            let scaledProjectedY = projectedCoordinate.y * scale
            
            // Offset to the expected coordinate system.
            return CGPoint(x: scaledProjectedX - projectedOffset.x, y: scaledProjectedY - projectedOffset.y)
        }
    }
}
