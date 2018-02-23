import XCTest

@testable import GeospatialKit

class AnnotationGeneratorTests: XCTestCase {
    var annotationGenerator: AnnotationGenerator!
    
    override func setUp() {
        super.setUp()
        
        annotationGenerator = AnnotationGenerator(logger: MockLogger())
    }
    
    func testAnnotationsPoint() {
        let annotations = annotationGenerator.annotations(for: MockData.testGeoJsonObject(geoJsonDataName: "Point"), debug: false)
        
        XCTAssertEqual(annotations.count, 1)
    }
    
    func testAnnotationsMultiPoint() {
        let annotations = annotationGenerator.annotations(for: MockData.testGeoJsonObject(geoJsonDataName: "MultiPoint"), debug: false)
        
        XCTAssertEqual(annotations.count, 2)
    }
    
    func testAnnotationsLineString() {
        let annotations = annotationGenerator.annotations(for: MockData.testGeoJsonObject(geoJsonDataName: "LineString"), debug: false)
        
        XCTAssertEqual(annotations.count, 0)
    }
    
    func testAnnotationsMultiLineString() {
        let annotations = annotationGenerator.annotations(for: MockData.testGeoJsonObject(geoJsonDataName: "MultiLineString"), debug: false)
        
        XCTAssertEqual(annotations.count, 0)
    }
    
    func testAnnotationsPolygon() {
        let annotations = annotationGenerator.annotations(for: MockData.testGeoJsonObject(geoJsonDataName: "Polygon"), debug: false)
        
        XCTAssertEqual(annotations.count, 0)
    }
    
    func testAnnotationsPolygonMultipleRings() {
        let annotations = annotationGenerator.annotations(for: MockData.testGeoJsonObject(geoJsonDataName: "Polygon: Multiple Rings"), debug: false)
        
        XCTAssertEqual(annotations.count, 0)
    }
    
    func testAnnotationsMultiPolygon() {
        let annotations = annotationGenerator.annotations(for: MockData.testGeoJsonObject(geoJsonDataName: "MultiPolygon"), debug: false)
        
        XCTAssertEqual(annotations.count, 0)
    }
    
    func testAnnotationsGeometryCollection() {
        let annotations = annotationGenerator.annotations(for: MockData.testGeoJsonObject(geoJsonDataName: "GeometryCollection"), debug: false)
        
        XCTAssertEqual(annotations.count, 1)
    }
    
    func testAnnotationsGeometryCollectionEmptyGeometries() {
        let annotations = annotationGenerator.annotations(for: MockData.testGeoJsonObject(geoJsonDataName: "GeometryCollection: Empty geometries"), debug: false)
        
        XCTAssertEqual(annotations.count, 0)
    }
    
    func testAnnotationsFeature() {
        let annotations = annotationGenerator.annotations(for: MockData.testGeoJsonObject(geoJsonDataName: "Feature"), debug: false)
        
        XCTAssertEqual(annotations.count, 0)
    }
    
    func testOverlaysFeatureGeometryCollection() {
        let annotations = annotationGenerator.annotations(for: MockData.testGeoJsonObject(geoJsonDataName: "Feature: Geometry Collection"), debug: false)
        
        XCTAssertEqual(annotations.count, 1)
    }
    
    func testAnnotationsFeatureNullGeometry() {
        let annotations = annotationGenerator.annotations(for: MockData.testGeoJsonObject(geoJsonDataName: "Feature: null geometry"), debug: false)
        
        XCTAssertEqual(annotations.count, 0)
    }
    
    func testAnnotationsFeatureCollection() {
        let annotations = annotationGenerator.annotations(for: MockData.testGeoJsonObject(geoJsonDataName: "FeatureCollection"), debug: false)
        
        XCTAssertEqual(annotations.count, 1)
    }
    
    func testAnnotationsFeatureCollection2Features1NullGeometry() {
        let annotations = annotationGenerator.annotations(for: MockData.testGeoJsonObject(geoJsonDataName: "FeatureCollection: 2 Features, 1 null geometry"), debug: false)
        
        XCTAssertEqual(annotations.count, 0)
    }
    
    func testAnnotationsFeatureCollection1FeatureNullGeometry() {
        let annotations = annotationGenerator.annotations(for: MockData.testGeoJsonObject(geoJsonDataName: "FeatureCollection: 1 Feature, null geometry"), debug: false)
        
        XCTAssertEqual(annotations.count, 0)
    }
}
