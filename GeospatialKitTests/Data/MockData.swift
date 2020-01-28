import GeospatialSwift

@testable import GeospatialKit

// swiftlint:disable force_cast force_try
final class MockData {
    static let geoJson = GeoTestHelper.geospatial.geoJson
    
    static let geoJsonTestData: [GeoJsonDictionary] = { return read(fileName: "GeoJsonTestData")["geoJsonObjects"] as! [GeoJsonDictionary] }()
    static let geoJsonTestDataBig: [GeoJsonDictionary] = { return [read(fileName: "GeoJsonTestDataBig")] }()
    static let geoJsonTestAllData: [GeoJsonDictionary] = { return geoJsonTestData + geoJsonTestDataBig }()
    static let wktTestData: [GeoJsonDictionary] = { return read(fileName: "WktTestData")["wktObjects"] as! [GeoJsonDictionary] }()
    
    static func testGeoJson(_ name: String) -> GeoJsonDictionary {
        return geoJsonTestData.first { ($0["name"] as! String) == name }!["geoJson"] as! GeoJsonDictionary
    }
    
    static func testGeoJsonObject(geoJsonDataName: String) -> GeoJsonObject {
        return geoJson.parseObject(fromGeoJson: testGeoJson(geoJsonDataName)).success!
    }
    
    static func testWkt(_ name: String) -> String {
        return wktTestData.first { ($0["name"] as! String) == name }!["wkt"] as! String
    }
    
    static let points: [GeoJson.Point] = linesPoints.first!
    static let lineStrings: [GeoJson.LineString] = linesPoints.map { geoJson.lineString(points: $0).success! }
    static let linearRings: [GeoJson.LineString] = linearRingsList.first!
    static let polygons: [GeoJson.Polygon] = linearRingsList.map { geoJson.polygon(mainRing: $0.first!, negativeRings: Array($0.dropFirst())).success! }
    static let geometries: [GeoJsonGeometry] = [
        geoJson.point(longitude: 1, latitude: 2, altitude: 3),
        geoJson.multiPoint(points: MockData.points).success!,
        geoJson.lineString(points: MockData.points).success!,
        geoJson.multiLineString(lineStrings: MockData.lineStrings).success!,
        geoJson.polygon(mainRing: MockData.linearRings.first!, negativeRings: Array(MockData.linearRings.dropFirst())).success!,
        geoJson.multiPolygon(polygons: MockData.polygons).success!
    ]
    static let features: [GeoJson.Feature] = [
        geoJson.feature(geometry: geoJson.point(longitude: 1, latitude: 2, altitude: 3), id: nil, properties: nil).success!,
        geoJson.feature(geometry: geoJson.lineString(points: MockData.points).success!, id: nil, properties: nil).success!,
        geoJson.feature(geometry: geoJson.polygon(mainRing: MockData.linearRings.first!, negativeRings: Array(MockData.linearRings.dropFirst())).success!, id: nil, properties: nil).success!
    ]
    
    static let pointsCoordinatesJson = "[[1.0, 2.0, 3.0], [2.0, 2.0, 4.0], [2.0, 3.0, 5.0]]"
    static let lineStringsCoordinatesJson = "[[[1.0, 2.0, 3.0], [2.0, 2.0, 4.0], [2.0, 3.0, 5.0]], [[2.0, 3.0, 3.0], [3.0, 3.0, 4.0], [3.0, 4.0, 5.0], [4.0, 5.0, 6.0]]]"
    static let linearRingsCoordinatesJson = "[[[1.0, 2.0, 3.0], [2.0, 2.0, 4.0], [2.0, 3.0, 5.0], [1.0, 3.0, 4.0], [1.0, 2.0, 3.0]], [[2.0, 3.0, 3.0], [3.0, 3.0, 4.0], [3.0, 4.0, 5.0], [2.0, 4.0, 4.0], [2.0, 3.0, 3.0]]]"
    
    private static let partialPolygonsCoordinates1 = "[[1.0, 2.0, 3.0], [2.0, 2.0, 4.0], [2.0, 3.0, 5.0], [1.0, 3.0, 4.0], [1.0, 2.0, 3.0]]"
    private static let partialPolygonsCoordinates2 = "[[2.0, 3.0, 3.0], [3.0, 3.0, 4.0], [3.0, 4.0, 5.0], [2.0, 4.0, 4.0], [2.0, 3.0, 3.0]]"
    private static let partialPolygonsCoordinates3 = "[[5.0, 6.0, 13.0], [6.0, 6.0, 14.0], [6.0, 7.0, 15.0], [5.0, 7.0, 14.0], [5.0, 6.0, 13.0]]"
    private static let partialPolygonsCoordinates4 = "[[6.0, 7.0, 13.0], [7.0, 7.0, 14.0], [7.0, 8.0, 15.0], [6.0, 8.0, 14.0], [6.0, 7.0, 13.0]]"
    static let polygonsCoordinatesJson = "[[\(partialPolygonsCoordinates1), \(partialPolygonsCoordinates2)], [\(partialPolygonsCoordinates3), \(partialPolygonsCoordinates4)]]"
    
    static let box: GeodesicPolygon = SimplePolygon(mainRing:
        SimpleLine(points: [SimplePoint(longitude: 0, latitude: 0), SimplePoint(longitude: 0, latitude: 1), SimplePoint(longitude: 1, latitude: 1), SimplePoint(longitude: 1, latitude: 0), SimplePoint(longitude: 0, latitude: 0)])!)!
}

extension MockData {
    private static func read(fileName: String) -> GeoJsonDictionary {
        let data = try! Data(contentsOf: Bundle(for: MockData.self).url(forResource: fileName, withExtension: ".json")!)
        
        let jsonData = try! JSONSerialization.jsonObject(with: data, options: .init(rawValue: 0))
        
        return jsonData as! GeoJsonDictionary
    }
    
    private static let linesPoints: [[GeoJson.Point]] = [
        [GeoTestHelper.point(1, 2, 3), GeoTestHelper.point(2, 2, 4), GeoTestHelper.point(2, 3, 5)],
        [GeoTestHelper.point(2, 3, 3), GeoTestHelper.point(3, 3, 4), GeoTestHelper.point(3, 4, 5), GeoTestHelper.point(4, 5, 6)]
    ]
    
    private static let polygonPoints: [[GeoJson.Point]] = polygonPointsList.first!
    
    private static let polygonPointsList: [[[GeoJson.Point]]] = [
        [
            [GeoTestHelper.point(1, 2, 3), GeoTestHelper.point(2, 2, 4), GeoTestHelper.point(2, 3, 5), GeoTestHelper.point(1, 3, 4), GeoTestHelper.point(1, 2, 3)],
            [GeoTestHelper.point(2, 3, 3), GeoTestHelper.point(3, 3, 4), GeoTestHelper.point(3, 4, 5), GeoTestHelper.point(2, 4, 4), GeoTestHelper.point(2, 3, 3)]
        ],
        [
            [GeoTestHelper.point(5, 6, 13), GeoTestHelper.point(6, 6, 14), GeoTestHelper.point(6, 7, 15), GeoTestHelper.point(5, 7, 14), GeoTestHelper.point(5, 6, 13)],
            [GeoTestHelper.point(6, 7, 13), GeoTestHelper.point(7, 7, 14), GeoTestHelper.point(7, 8, 15), GeoTestHelper.point(6, 8, 14), GeoTestHelper.point(6, 7, 13)]
        ]
    ]
    
    private static let linearRingsList: [[GeoJson.LineString]] = polygonPointsList.map { $0.map { geoJson.lineString(points: $0).success! } }
}
