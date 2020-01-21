@testable import GeospatialKit

final class MockGeohashCoder: GeohashCoderProtocol {
    private(set) var geohashFromPointCallCount = 0
    var geohashFromPointResult: String = ""
    func geohash(for point: GeodesicPoint, precision: Int) -> String {
        geohashFromPointCallCount += 1
        
        return geohashFromPointResult
    }
    
    private(set) var geohashBoxFromPointCallCount = 0
    lazy var geohashBoxFromPointResult: GeoJsonGeohashBox = MockGeoJsonGeohashBox()
    func geohashBox(for point: GeodesicPoint, precision: Int) -> GeoJsonGeohashBox {
        geohashBoxFromPointCallCount += 1
        
        return geohashBoxFromPointResult
    }
    
    private(set) var geohashBoxFromGeohashCallCount = 0
    lazy var geohashBoxFromGeohashResult: GeoJsonGeohashBox = MockGeoJsonGeohashBox()
    func geohashBox(forGeohash geohash: String) -> GeoJsonGeohashBox? {
        geohashBoxFromGeohashCallCount += 1

        return geohashBoxFromGeohashResult
    }
    
    private(set) var geohashesCallCount = 0
    var geohashesResult: [String] = []
    func geohashes(for boundingBox: GeodesicBoundingBox, precision: Int) -> [String] {
        geohashesCallCount += 1
        
        return geohashesResult
    }
    
    private(set) var geohashBoxesCallCount = 0
    var geohashBoxesResult: [GeoJsonGeohashBox] = []
    func geohashBoxes(for boundingBox: GeodesicBoundingBox, precision: Int) -> [GeoJsonGeohashBox] {
        geohashBoxesCallCount += 1
        
        return geohashBoxesResult
    }
    
    private(set) var geohashNeighborsForGeohashCallCount = 0
    var geohashNeighborsForGeohashResult: [String] = []
    func geohashNeighbors(forGeohash geohash: String) -> [String] {
        geohashNeighborsForGeohashCallCount += 1
        
        return geohashNeighborsForGeohashResult
    }
    
    private(set) var geohashNeighborsForPointCallCount = 0
    var geohashNeighborsForPointResult: [String] = []
    func geohashNeighbors(for point: GeodesicPoint, precision: Int) -> [String] {
        geohashNeighborsForPointCallCount += 1
        
        return geohashNeighborsForPointResult
    }
    
    private(set) var geohashBoxNeighborsForPointCallCount = 0
    var geohashBoxNeighborsForPointResult: [GeoJsonGeohashBox] = []
    func geohashBoxNeighbors(for point: GeodesicPoint, precision: Int) -> [GeoJsonGeohashBox] {
        geohashBoxNeighborsForPointCallCount += 1
        
        return geohashBoxNeighborsForPointResult
    }
}
