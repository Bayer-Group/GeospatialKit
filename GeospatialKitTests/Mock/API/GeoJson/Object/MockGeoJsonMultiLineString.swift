@testable import GeospatialSwift

final class MockGeoJsonMultiLineString: MockGeoJsonLinearGeometry, GeoJsonMultiLineString {
    func invalidReasons(tolerance: Double) -> [[LineStringInvalidReason]] {
        return []
    }
}
