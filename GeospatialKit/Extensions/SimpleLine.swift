import CoreLocation
import GeospatialSwift

public extension SimpleLine {
    init?(locationCoordinates: [CLLocationCoordinate2D]) {
        self.init(points: locationCoordinates.map { SimplePoint(locationCoordinate: $0) })
    }
}
