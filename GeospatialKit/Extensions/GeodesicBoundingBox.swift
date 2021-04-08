import MapKit
import GeospatialSwift

public extension GeodesicBoundingBox {
    internal var imageMinimumAdjustment: Double { return 0.00005 }
    
    var region: MKCoordinateRegion {
        let span = MKCoordinateSpan(latitudeDelta: latitudeDelta, longitudeDelta: longitudeDelta)
        
        let center = CLLocationCoordinate2D(latitude: centroid.latitude, longitude: centroid.longitude)
        
        return MKCoordinateRegion(center: center, span: span)
    }
    
    func mappingBoundingBox(insetPercent: Double) -> GeodesicBoundingBox {
        return validBoundingBox(minimumAdjustment: imageMinimumAdjustment).insetBoundingBox(percent: insetPercent)
    }
    
    init?(locationCoordinates: [CLLocationCoordinate2D]) {
        guard locationCoordinates.count > 0 else { return nil }
        
        let minLatitude = locationCoordinates.map({ $0.latitude }).min()!
        let minLongitude = locationCoordinates.map({ $0.longitude }).min()!
        let maxLatitude = locationCoordinates.map({ $0.latitude }).max()!
        let maxLongitude = locationCoordinates.map({ $0.longitude }).max()!
        
        self.init(minLongitude: minLongitude, minLatitude: minLatitude, maxLongitude: maxLongitude, maxLatitude: maxLatitude)
    }
}
