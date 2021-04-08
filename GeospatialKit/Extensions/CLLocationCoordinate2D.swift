import CoreLocation
import GeospatialSwift

private let calculator = GeospatialCocoa().calculator

extension CLLocationCoordinate2D {
    var geodesicPoint: GeodesicPoint { SimplePoint(longitude: longitude, latitude: latitude) }
    
    func distance(from location: CLLocationCoordinate2D) -> CLLocationDistance {
        let point1 = CLLocation(latitude: latitude, longitude: longitude)
        let point2 = CLLocation(latitude: location.latitude, longitude: location.longitude)
        return point1.distance(from: point2)
    }
    
    func bearing(from location: CLLocationCoordinate2D) -> Double {
        return calculator.bearing(from: location.geodesicPoint, to: geodesicPoint)
    }
    
    func midpoint(from location: CLLocationCoordinate2D) -> CLLocationCoordinate2D {
        calculator.midpoint(from: location.geodesicPoint, to: geodesicPoint).locationCoordinate
    }
}
