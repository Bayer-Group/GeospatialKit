@testable import GeospatialSwift

final class MockGeoJsonGeohashBox: GeoJsonGeohashBox {
    var boundingBox: GeodesicBoundingBox = MockGeoJsonBoundingBox()
    
    private(set) var geohashCallCount = 0
    var geohashResult: String = ""
    var geohash: String {
        geohashCallCount += 1
        
        return geohashResult
    }
    
    private(set) var geohashNeighborCallCount = 0
    lazy var geohashNeighborResult: GeoJsonGeohashBox = MockGeoJsonGeohashBox()
    func geohashNeighbor(direction: GeohashCompassPoint, precision: Int) -> GeoJsonGeohashBox {
        geohashNeighborCallCount += 1
        
        return geohashNeighborResult
    }
}
