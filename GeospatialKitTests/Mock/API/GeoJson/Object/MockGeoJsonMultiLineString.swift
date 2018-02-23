@testable import GeospatialKit

class MockGeoJsonMultiLineString: MockGeoJsonMultiCoordinatesGeometry, GeoJsonMultiLineString {
    private(set) var lineStringsCallCount = 0
    
    var lineStringsResult: [GeoJsonLineString] = []
    
    var lineStrings: [GeoJsonLineString] {
        lineStringsCallCount += 1
        
        return lineStringsResult
    }
}
