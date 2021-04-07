import CoreLocation
import GeospatialSwift

extension GeodesicLineSegment {
    init(startLocationCoordinate: CLLocationCoordinate2D, endLocationCoordinate: CLLocationCoordinate2D) {
        self.init(startPoint: SimplePoint(locationCoordinate: startLocationCoordinate), endPoint: SimplePoint(locationCoordinate: endLocationCoordinate))
    }
}
