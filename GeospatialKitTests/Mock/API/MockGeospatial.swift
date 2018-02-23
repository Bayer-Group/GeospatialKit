@testable import GeospatialKit

class MockGeospatial: GeospatialProtocol {
    private(set) var parseWktCallCount = 0
    
    var parseWktResult: GeoJsonObject?
    
    var geoJson: GeoJsonProtocol = MockGeoJson()
    
    var geohash: GeohashCoderProtocol = MockGeohashCoder()
    
    var image: ImageManagerProtocol = MockImageManager()
    
    var map: MapManagerProtocol = MockMapManager()
    
    func parse(wkt: String) -> GeoJsonObject? {
        parseWktCallCount += 1
        
        return parseWktResult
    }
}
