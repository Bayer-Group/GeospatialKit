import XCTest

import GeospatialSwift

@testable import GeospatialKit

final class GeoJsonParsingPerformanceTest: XCTestCase {
    func testPolygonBoundingBox() {
        let geospatial = GeoTestHelper.geospatial
        
        let geoJsons = MockData.geoJsonTestData.compactMap { $0["geoJson"] as? GeoJsonDictionary }
        
        var cacheForMemoryUsageInfo = [GeoJsonObject]()
        
        measure {
            for _ in 0..<50 {
                for geoJson in geoJsons {
                    // swiftlint:disable:next force_cast
                    guard (geoJson["type"] as! String) != "Invalid" else { return }
                    
                    cacheForMemoryUsageInfo.append(geospatial.geoJson.parse(geoJson: geoJson).success!)
                }
            }
        }
    }
}
