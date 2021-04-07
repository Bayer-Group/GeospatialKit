import GeospatialSwift

public extension GeodesicCalculator {
    func area(locationCoordinates: [CLLocationCoordinate2D]) -> Double {
        return SimplePolygon(locationCoordinates: locationCoordinates).flatMap { area(of: $0) } ?? 0
    }
}
