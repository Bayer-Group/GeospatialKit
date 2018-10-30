import XCTest

@testable import GeospatialKit

class AnnotationGeneratorTests: XCTestCase {
    var annotationGenerator: AnnotationGenerator!
    
    override func setUp() {
        super.setUp()
        
        annotationGenerator = AnnotationGenerator()
    }
    
    func testAnnotationsPoint() {
        let annotations = annotationGenerator.annotations(for: MockData.testGeoJsonObject(geoJsonDataName: "Point"), withProperties: [:], debug: false)
        
        XCTAssertEqual(annotations.count, 1)
    }
    
    func testAnnotationsMultiPoint() {
        let annotations = annotationGenerator.annotations(for: MockData.testGeoJsonObject(geoJsonDataName: "MultiPoint 3 Point"), withProperties: [:], debug: false)
        
        XCTAssertEqual(annotations.count, 3)
    }
    
    func testAnnotationsLineString() {
        let annotations = annotationGenerator.annotations(for: MockData.testGeoJsonObject(geoJsonDataName: "LineString 4 Point"), withProperties: [:], debug: false)
        
        XCTAssertEqual(annotations.count, 0)
    }
    
    func testAnnotationsMultiLineString() {
        let annotations = annotationGenerator.annotations(for: MockData.testGeoJsonObject(geoJsonDataName: "MultiLineString 3 Line"), withProperties: [:], debug: false)
        
        XCTAssertEqual(annotations.count, 0)
    }
    
    func testAnnotationsPolygon() {
        let annotations = annotationGenerator.annotations(for: MockData.testGeoJsonObject(geoJsonDataName: "Polygon 6 Line"), withProperties: [:], debug: false)
        
        XCTAssertEqual(annotations.count, 0)
    }
    
    func testAnnotationsPolygonMultipleRings() {
        let annotations = annotationGenerator.annotations(for: MockData.testGeoJsonObject(geoJsonDataName: "Polygon: Multiple Rings"), withProperties: [:], debug: false)
        
        XCTAssertEqual(annotations.count, 0)
    }
    
    func testAnnotationsMultiPolygon() {
        let annotations = annotationGenerator.annotations(for: MockData.testGeoJsonObject(geoJsonDataName: "MultiPolygon 3"), withProperties: [:], debug: false)
        
        XCTAssertEqual(annotations.count, 0)
    }
    
    func testAnnotationsGeometryCollection() {
        let annotations = annotationGenerator.annotations(for: MockData.testGeoJsonObject(geoJsonDataName: "GeometryCollection"), withProperties: [:], debug: false)
        
        XCTAssertEqual(annotations.count, 1)
    }
    
    func testAnnotationsGeometryCollectionEmptyGeometries() {
        let annotations = annotationGenerator.annotations(for: MockData.testGeoJsonObject(geoJsonDataName: "GeometryCollection: Empty geometries"), withProperties: [:], debug: false)
        
        XCTAssertEqual(annotations.count, 0)
    }
    
    func testAnnotationsFeature() {
        let annotations = annotationGenerator.annotations(for: MockData.testGeoJsonObject(geoJsonDataName: "Feature"), withProperties: [:], debug: false)
        
        XCTAssertEqual(annotations.count, 0)
    }
    
    func testOverlaysFeatureGeometryCollection() {
        let annotations = annotationGenerator.annotations(for: MockData.testGeoJsonObject(geoJsonDataName: "Feature: Geometry Collection"), withProperties: [:], debug: false)
        
        XCTAssertEqual(annotations.count, 1)
    }
    
    func testAnnotationsFeatureNullGeometry() {
        let annotations = annotationGenerator.annotations(for: MockData.testGeoJsonObject(geoJsonDataName: "Feature: null geometry"), withProperties: [:], debug: false)
        
        XCTAssertEqual(annotations.count, 0)
    }
    
    func testAnnotationsFeatureCollection() {
        let annotations = annotationGenerator.annotations(for: MockData.testGeoJsonObject(geoJsonDataName: "FeatureCollection"), withProperties: [:], debug: false)
        
        XCTAssertEqual(annotations.count, 1)
    }
    
    func testAnnotationsFeatureCollection2Features1NullGeometry() {
        let annotations = annotationGenerator.annotations(for: MockData.testGeoJsonObject(geoJsonDataName: "FeatureCollection: 2 Features, 1 null geometry"), withProperties: [:], debug: false)
        
        XCTAssertEqual(annotations.count, 0)
    }
    
    func testAnnotationsFeatureCollection1FeatureNullGeometry() {
        let annotations = annotationGenerator.annotations(for: MockData.testGeoJsonObject(geoJsonDataName: "FeatureCollection: 1 Feature, null geometry"), withProperties: [:], debug: false)
        
        XCTAssertEqual(annotations.count, 0)
    }
}
