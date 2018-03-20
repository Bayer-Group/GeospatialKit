import XCTest

@testable import GeospatialKit

class GeoJsonParsingPerformanceTest: XCTestCase {
    
    func testPolygonBoundingBox() {
        let geospatial = Geospatial(configuration: ConfigurationModel(logLevel: .debug))
        
        let geoJsons = MockData.geoJsonTestData.flatMap { $0["geoJson"] as? GeoJsonDictionary }
        
        var cacheForMemoryUsageInfo = [GeoJsonObject]()
        
        measure {
            for _ in 0..<50 {
                for geoJson in geoJsons {
                    cacheForMemoryUsageInfo.append(geospatial.geoJson.parse(geoJson: geoJson)!)
                }
            }
        }
    }
    
}
