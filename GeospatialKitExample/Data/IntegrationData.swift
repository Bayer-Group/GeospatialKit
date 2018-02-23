import GeospatialKit

class IntegrationData {
    static var geoJsonTestData: GeoJsonDictionary { return read(fileName: "GeoJsonTestData") }
    
    // swiftlint:disable force_try force_cast
    private static func read(fileName: String) -> GeoJsonDictionary {
        let data = try! Data(contentsOf: Bundle.main.url(forResource: fileName, withExtension: ".json")!)
        
        return try! JSONSerialization.jsonObject(with: data, options: .init(rawValue: 0)) as! GeoJsonDictionary
    }
}
