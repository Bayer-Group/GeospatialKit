import CoreLocation
import GeospatialSwift

public extension SimplePoint {
    init(locationCoordinate: CLLocationCoordinate2D) {
        self.init(longitude: locationCoordinate.longitude, latitude: locationCoordinate.latitude)
    }
}
