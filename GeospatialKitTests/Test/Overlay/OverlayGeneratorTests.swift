import XCTest

@testable import GeospatialKit

class OverlayGeneratorTests: XCTestCase {
    var overlayGenerator: OverlayGenerator!
    
    var overlayRenderModel: OverlayRenderModel!
    
    override func setUp() {
        super.setUp()
        
        overlayGenerator = OverlayGenerator()
        
        overlayRenderModel = OverlayRenderModel(lineWidth: 1, strokeColor: .black, fillColor: .blue, alpha: 0.8)
    }
    
    func testOverlaysPoint() {
        let overlays = overlayGenerator.overlays(for: MockData.testGeoJsonObject(geoJsonDataName: "Point"), withProperties: [:])
        
        XCTAssertEqual(overlays.count, 0)
    }
    
    func testOverlaysMultiPoint() {
        let overlays = overlayGenerator.overlays(for: MockData.testGeoJsonObject(geoJsonDataName: "MultiPoint 3 Point"), withProperties: [:])
        
        XCTAssertEqual(overlays.count, 0)
    }
    
    func testOverlaysLineString() {
        let overlays = overlayGenerator.overlays(for: MockData.testGeoJsonObject(geoJsonDataName: "LineString 4 Point"), withProperties: [:])
        
        XCTAssertEqual(overlays.count, 1)
        
        let renderer = overlayGenerator.renderer(for: overlays[0], with: overlayRenderModel)
        
        XCTAssertTrue(renderer is MKPolylineRenderer)
    }
    
    func testOverlaysMultiLineString() {
        let overlays = overlayGenerator.overlays(for: MockData.testGeoJsonObject(geoJsonDataName: "MultiLineString 3 Line"), withProperties: [:])
        
        if #available(iOS 13.0, *) {
            guard overlays.count == 1 else { XCTFail("Overlay count: \(overlays.count)"); return }
            
            let renderer = overlayGenerator.renderer(for: overlays[0], with: overlayRenderModel)
            
            XCTAssertTrue(renderer is MKMultiPolylineRenderer)
        } else {
            XCTAssertEqual(overlays.count, 3)
            
            var renderer = overlayGenerator.renderer(for: overlays[0], with: overlayRenderModel)
            
            XCTAssertTrue(renderer is MKPolylineRenderer)
            
            renderer = overlayGenerator.renderer(for: overlays[1], with: overlayRenderModel)
            
            XCTAssertTrue(renderer is MKPolylineRenderer)
        }
    }
    
    func testOverlaysPolygon() {
        let overlays = overlayGenerator.overlays(for: MockData.testGeoJsonObject(geoJsonDataName: "Polygon 6 Line"), withProperties: [:])
        
        XCTAssertEqual(overlays.count, 1)
        
        let renderer = overlayGenerator.renderer(for: overlays[0], with: overlayRenderModel)
        
        XCTAssertTrue(renderer is MKPolygonRenderer)
    }
    
    func testOverlaysPolygonMultipleRings() {
        let overlays = overlayGenerator.overlays(for: MockData.testGeoJsonObject(geoJsonDataName: "Polygon: Multiple Rings"), withProperties: [:])
        
        XCTAssertEqual(overlays.count, 1)
        
        let renderer = overlayGenerator.renderer(for: overlays[0], with: overlayRenderModel)
        
        XCTAssertTrue(renderer is MKPolygonRenderer)
    }
    
    func testOverlaysMultiPolygon() {
        let overlays = overlayGenerator.overlays(for: MockData.testGeoJsonObject(geoJsonDataName: "MultiPolygon 3"), withProperties: [:])
        
        if #available(iOS 13.0, *) {
            guard overlays.count == 1 else { XCTFail("Overlay count: \(overlays.count)"); return }
            
            let renderer = overlayGenerator.renderer(for: overlays[0], with: overlayRenderModel)
            
            XCTAssertTrue(renderer is MKMultiPolygonRenderer)
        } else {
            guard overlays.count == 3 else { XCTFail("Overlay count: \(overlays.count)"); return }
            
            var renderer = overlayGenerator.renderer(for: overlays[0], with: overlayRenderModel)
            
            XCTAssertTrue(renderer is MKPolygonRenderer)
            
            renderer = overlayGenerator.renderer(for: overlays[1], with: overlayRenderModel)
            
            XCTAssertTrue(renderer is MKPolygonRenderer)
        }
    }
    
    func testOverlaysGeometryCollection() {
        let overlays = overlayGenerator.overlays(for: MockData.testGeoJsonObject(geoJsonDataName: "GeometryCollection"), withProperties: [:])
        
        XCTAssertEqual(overlays.count, 1)
        
        let renderer = overlayGenerator.renderer(for: overlays[0], with: overlayRenderModel)
        
        XCTAssertTrue(renderer is MKPolylineRenderer)
    }
    
    func testOverlaysGeometryCollectionEmptyGeometries() {
        let overlays = overlayGenerator.overlays(for: MockData.testGeoJsonObject(geoJsonDataName: "GeometryCollection: Empty geometries"), withProperties: [:])
        
        XCTAssertEqual(overlays.count, 0)
    }
    
    func testOverlaysFeature() {
        let overlays = overlayGenerator.overlays(for: MockData.testGeoJsonObject(geoJsonDataName: "Feature"), withProperties: [:])
        
        XCTAssertEqual(overlays.count, 1)
        
        let renderer = overlayGenerator.renderer(for: overlays[0], with: overlayRenderModel)
        
        XCTAssertTrue(renderer is MKPolygonRenderer)
    }
    
    func testOverlaysFeatureGeometryCollection() {
        let overlays = overlayGenerator.overlays(for: MockData.testGeoJsonObject(geoJsonDataName: "Feature: Geometry Collection"), withProperties: [:])
        
        XCTAssertEqual(overlays.count, 2)
        
        var renderer = overlayGenerator.renderer(for: overlays[0], with: overlayRenderModel)
        
        XCTAssertTrue(renderer is MKPolylineRenderer)
        
        renderer = overlayGenerator.renderer(for: overlays[1], with: overlayRenderModel)
        
        XCTAssertTrue(renderer is MKPolygonRenderer)
    }
    
    func testOverlaysFeatureNullGeometry() {
        let overlays = overlayGenerator.overlays(for: MockData.testGeoJsonObject(geoJsonDataName: "Feature: null geometry"), withProperties: [:])
        
        XCTAssertEqual(overlays.count, 0)
    }
    
    func testOverlaysFeatureCollection() {
        let overlays = overlayGenerator.overlays(for: MockData.testGeoJsonObject(geoJsonDataName: "FeatureCollection"), withProperties: [:])
        
        XCTAssertEqual(overlays.count, 2)
        
        var renderer = overlayGenerator.renderer(for: overlays[0], with: overlayRenderModel)
        
        XCTAssertTrue(renderer is MKPolylineRenderer)
        
        renderer = overlayGenerator.renderer(for: overlays[1], with: overlayRenderModel)
        
        XCTAssertTrue(renderer is MKPolygonRenderer)
    }
    
    func testOverlaysFeatureCollection2Features1NullGeometry() {
        let overlays = overlayGenerator.overlays(for: MockData.testGeoJsonObject(geoJsonDataName: "FeatureCollection: 2 Features, 1 null geometry"), withProperties: [:])
        
        XCTAssertEqual(overlays.count, 1)
        
        let renderer = overlayGenerator.renderer(for: overlays[0], with: overlayRenderModel)
        
        XCTAssertTrue(renderer is MKPolylineRenderer)
    }
    
    func testOverlaysFeatureCollection1FeatureNullGeometry() {
        let overlays = overlayGenerator.overlays(for: MockData.testGeoJsonObject(geoJsonDataName: "FeatureCollection: 1 Feature, null geometry"), withProperties: [:])
        
        XCTAssertEqual(overlays.count, 0)
    }
    
    func testRendererUnsupportedOverlay() {
        let renderer = overlayGenerator.renderer(for: MKCircle(), with: overlayRenderModel)
        
        XCTAssertFalse(renderer is MKPolygonRenderer)
        XCTAssertFalse(renderer is MKPolylineRenderer)
    }
}
