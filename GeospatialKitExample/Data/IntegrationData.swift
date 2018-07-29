import GeospatialKit

class IntegrationData {
    static var geoJsonTestData: GeoJsonDictionary { return read(fileName: "GeoJsonTestData", bundle: Bundle.main) }
    static var geoJsonTestDataBig: GeoJsonDictionary { return read(fileName: "GeoJsonTestDataBig", bundle: Bundle.main) }
    
    // swiftlint:disable force_try force_cast
    private static func read(fileName: String, bundle: Bundle) -> GeoJsonDictionary {
        let data = try! Data(contentsOf: bundle.url(forResource: fileName, withExtension: ".json")!)
        
        return try! JSONSerialization.jsonObject(with: data, options: .init(rawValue: 0)) as! GeoJsonDictionary
    }
}
