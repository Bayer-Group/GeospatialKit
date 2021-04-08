import CoreLocation
import GeospatialSwift

public extension GeodesicLine {
    var locationCoordinates: [CLLocationCoordinate2D] { points.dropLast().map { $0.locationCoordinate } }
}
