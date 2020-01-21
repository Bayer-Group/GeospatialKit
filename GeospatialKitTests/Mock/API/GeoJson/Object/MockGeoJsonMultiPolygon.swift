@testable import GeospatialSwift

final class MockGeoJsonMultiPolygon: MockGeoJsonClosedGeometry, GeoJsonMultiPolygon {
    func invalidReasons(tolerance: Double) -> [[PolygonInvalidReason]] {
        return []
    }
}
