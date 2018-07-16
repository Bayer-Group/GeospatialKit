import XCTest

@testable import GeospatialKit

// SOMEDAY: Add snapshot tests.
class ImageGeneratorTests: XCTestCase {
    var imageGenerator: ImageGenerator!
    
    var imageRenderModel: ImageRenderModel!
   
    var mockGeodesicCalculator: MockGeodesicCalculator!
    
    let imageWidth = 150.0
    let imageHeight = 100.0
    let lineWidth: CGFloat = 3.0
    
    override func setUp() {
        super.setUp()
        
        mockGeodesicCalculator = MockGeodesicCalculator()
        
        imageGenerator = ImageGenerator()
        
        imageRenderModel = ImageRenderModel(backgroundColor: UIColor.blue, shapeFillColor: UIColor.black, shapeLineColor: UIColor.brown, width: imageWidth, height: imageHeight, lineWidth: lineWidth)
    }
    
    func testCreatePoint() {
        let image = imageGenerator.image(for: MockData.testGeoJsonObject(geoJsonDataName: "Point"), with: imageRenderModel, debug: false)
        
        commonTests(image: image)
    }
    
    func testCreateMultiPoint() {
        let image = imageGenerator.image(for: MockData.testGeoJsonObject(geoJsonDataName: "MultiPoint"), with: imageRenderModel, debug: false)
        
        commonTests(image: image)
    }
    
    func testCreateLineString() {
        let image = imageGenerator.image(for: MockData.testGeoJsonObject(geoJsonDataName: "LineString"), with: imageRenderModel, debug: false)
        
        commonTests(image: image)
    }
    
    func testCreateMultiLineString() {
        let image = imageGenerator.image(for: MockData.testGeoJsonObject(geoJsonDataName: "MultiLineString"), with: imageRenderModel, debug: false)
        
        commonTests(image: image)
    }
    
    func testCreatePolygon() {
        let image = imageGenerator.image(for: MockData.testGeoJsonObject(geoJsonDataName: "Polygon"), with: imageRenderModel, debug: false)
        
        commonTests(image: image)
    }
    
    func testCreatePolygonMultipleRings() {
        let image = imageGenerator.image(for: MockData.testGeoJsonObject(geoJsonDataName: "Polygon: Multiple Rings"), with: imageRenderModel, debug: false)
        
        commonTests(image: image)
    }
    
    func testCreateMultiPolygon() {
        let image = imageGenerator.image(for: MockData.testGeoJsonObject(geoJsonDataName: "MultiPolygon"), with: imageRenderModel, debug: false)
        
        commonTests(image: image)
    }
    
    func testCreateGeometryCollection() {
        let image = imageGenerator.image(for: MockData.testGeoJsonObject(geoJsonDataName: "GeometryCollection"), with: imageRenderModel, debug: false)
        
        commonTests(image: image)
    }
    
    func testCreateGeometryCollectionEmptyGeometries() {
        let image = imageGenerator.image(for: MockData.testGeoJsonObject(geoJsonDataName: "GeometryCollection: Empty geometries"), with: imageRenderModel, debug: false)
        
        commonTests(image: image)
    }
    
    func testCreateFeature() {
        let image = imageGenerator.image(for: MockData.testGeoJsonObject(geoJsonDataName: "Feature"), with: imageRenderModel, debug: false)
        
        commonTests(image: image)
    }
    
    func testCreateFeatureGeometryCollection() {
        let image = imageGenerator.image(for: MockData.testGeoJsonObject(geoJsonDataName: "Feature: Geometry Collection"), with: imageRenderModel, debug: false)
        
        commonTests(image: image)
    }
    
    func testCreateFeatureNullGeometry() {
        let image = imageGenerator.image(for: MockData.testGeoJsonObject(geoJsonDataName: "Feature: null geometry"), with: imageRenderModel, debug: false)
        
        commonTests(image: image)
    }
    
    func testCreateFeatureCollection() {
        let image = imageGenerator.image(for: MockData.testGeoJsonObject(geoJsonDataName: "FeatureCollection"), with: imageRenderModel, debug: false)
        
        commonTests(image: image)
    }
    
    func testCreateFeatureCollection2Features1NullGeometry() {
        let image = imageGenerator.image(for: MockData.testGeoJsonObject(geoJsonDataName: "FeatureCollection: 2 Features, 1 null geometry"), with: imageRenderModel, debug: false)
        
        commonTests(image: image)
    }
    
    func testCreateFeatureCollection1FeatureNullGeometry() {
        let image = imageGenerator.image(for: MockData.testGeoJsonObject(geoJsonDataName: "FeatureCollection: 1 Feature, null geometry"), with: imageRenderModel, debug: false)
        
        commonTests(image: image)
    }
    
    func testCreateAllMockData() {
        XCTAssertEqual(MockData.geoJsonTestData.count, 15)
        
        MockData.geoJsonTestData.forEach { geoJsonData in
            // swiftlint:disable:next force_cast
            let geoJsonObject = GeoTestHelper.parse(geoJsonData["geoJson"] as! GeoJsonDictionary)
            let image = imageGenerator.image(for: geoJsonObject, with: imageRenderModel, debug: false)
            
            commonTests(image: image)
        }
    }
    
    private func commonTests(image: UIImage?) {
        XCTAssertNotNil(image)
        XCTAssertEqual(Double(image?.size.width ?? 0), imageWidth * 3)
        XCTAssertEqual(Double(image?.size.height ?? 0), imageHeight * 3)
        XCTAssertEqual(Double(image?.scale ?? 0), 1.0)
    }
}
