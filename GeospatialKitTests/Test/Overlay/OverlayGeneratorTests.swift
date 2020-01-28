import XCTest

import GeospatialSwift

@testable import GeospatialKit

// swiftlint:disable type_body_length file_length
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
    
    @available(iOS 13.0, *)
    func testGroupedOverlaysPoint() {
        let overlays = overlayGenerator.groupedOverlays(for: [MockData.testGeoJsonObject(geoJsonDataName: "Point")], withProperties: [:])
        
        XCTAssertEqual(overlays.count, 0)
    }
    
    func testOverlaysMultiPoint() {
        let overlays = overlayGenerator.overlays(for: MockData.testGeoJsonObject(geoJsonDataName: "MultiPoint 3 Point"), withProperties: [:])
        
        XCTAssertEqual(overlays.count, 0)
    }
    
    @available(iOS 13.0, *)
    func testGroupedOverlaysMultiPoint() {
        let overlays = overlayGenerator.groupedOverlays(for: [MockData.testGeoJsonObject(geoJsonDataName: "MultiPoint 3 Point")], withProperties: [:])
        
        XCTAssertEqual(overlays.count, 0)
    }
    
    func testOverlaysLineString() {
        let overlays = overlayGenerator.overlays(for: MockData.testGeoJsonObject(geoJsonDataName: "LineString 4 Point"), withProperties: [:])
        
        XCTAssertEqual(overlays.count, 1)
        
        let renderer = overlayGenerator.renderer(for: overlays[0], with: overlayRenderModel)
        
        XCTAssertTrue(renderer is MKPolylineRenderer)
    }
    
    @available(iOS 13.0, *)
    func testGroupedOverlaysLineString() {
        let overlays = overlayGenerator.groupedOverlays(for: [MockData.testGeoJsonObject(geoJsonDataName: "LineString 4 Point")], withProperties: [:])
        
        XCTAssertEqual(overlays.count, 1)
        
        let renderer = overlayGenerator.renderer(for: overlays[0], with: overlayRenderModel)
        
        XCTAssertTrue(renderer is MKMultiPolylineRenderer)
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
    
    @available(iOS 13.0, *)
    func testGroupedOverlaysMultiLineString() {
        let overlays = overlayGenerator.groupedOverlays(for: [MockData.testGeoJsonObject(geoJsonDataName: "MultiLineString 3 Line")], withProperties: [:])
        
        guard overlays.count == 1 else { XCTFail("Overlay count: \(overlays.count)"); return }
        
        let renderer = overlayGenerator.renderer(for: overlays[0], with: overlayRenderModel)
        
        XCTAssertTrue(renderer is MKMultiPolylineRenderer)
    }
    
    func testOverlaysPolygon() {
        let overlays = overlayGenerator.overlays(for: MockData.testGeoJsonObject(geoJsonDataName: "Polygon 6 Line"), withProperties: [:])
        
        XCTAssertEqual(overlays.count, 1)
        
        let renderer = overlayGenerator.renderer(for: overlays[0], with: overlayRenderModel)
        
        XCTAssertTrue(renderer is MKPolygonRenderer)
    }
    
    @available(iOS 13.0, *)
    func testGroupedOverlaysPolygon() {
        let overlays = overlayGenerator.groupedOverlays(for: [MockData.testGeoJsonObject(geoJsonDataName: "Polygon 6 Line")], withProperties: [:])
        
        XCTAssertEqual(overlays.count, 1)
        
        let renderer = overlayGenerator.renderer(for: overlays[0], with: overlayRenderModel)
        
        XCTAssertTrue(renderer is MKMultiPolygonRenderer)
    }
    
    func testOverlaysPolygonMultipleRings() {
        let overlays = overlayGenerator.overlays(for: MockData.testGeoJsonObject(geoJsonDataName: "Polygon: Multiple Rings"), withProperties: [:])
        
        XCTAssertEqual(overlays.count, 1)
        
        let renderer = overlayGenerator.renderer(for: overlays[0], with: overlayRenderModel)
        
        XCTAssertTrue(renderer is MKPolygonRenderer)
    }
    
    @available(iOS 13.0, *)
    func testGroupedOverlaysPolygonMultipleRings() {
        let overlays = overlayGenerator.groupedOverlays(for: [MockData.testGeoJsonObject(geoJsonDataName: "Polygon: Multiple Rings")], withProperties: [:])
        
        XCTAssertEqual(overlays.count, 1)
        
        let renderer = overlayGenerator.renderer(for: overlays[0], with: overlayRenderModel)
        
        XCTAssertTrue(renderer is MKMultiPolygonRenderer)
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
    
    @available(iOS 13.0, *)
    func testGroupedOverlaysMultiPolygon() {
        let overlays = overlayGenerator.groupedOverlays(for: [MockData.testGeoJsonObject(geoJsonDataName: "MultiPolygon 3")], withProperties: [:])
        
        guard overlays.count == 1 else { XCTFail("Overlay count: \(overlays.count)"); return }
        
        let renderer = overlayGenerator.renderer(for: overlays[0], with: overlayRenderModel)
        
        XCTAssertTrue(renderer is MKMultiPolygonRenderer)
    }
    
    func testOverlaysGeometryCollection() {
        let overlays = overlayGenerator.overlays(for: MockData.testGeoJsonObject(geoJsonDataName: "GeometryCollection"), withProperties: [:])
        
        XCTAssertEqual(overlays.count, 1)
        
        let renderer = overlayGenerator.renderer(for: overlays[0], with: overlayRenderModel)
        
        XCTAssertTrue(renderer is MKPolylineRenderer)
    }
    
    @available(iOS 13.0, *)
    func testGroupedOverlaysGeometryCollection() {
        let overlays = overlayGenerator.groupedOverlays(for: [MockData.testGeoJsonObject(geoJsonDataName: "GeometryCollection")], withProperties: [:])
        
        XCTAssertEqual(overlays.count, 1)
        
        let renderer = overlayGenerator.renderer(for: overlays[0], with: overlayRenderModel)
        
        XCTAssertTrue(renderer is MKMultiPolylineRenderer)
    }
    
    func testOverlaysGeometryCollectionEmptyGeometries() {
        let overlays = overlayGenerator.overlays(for: MockData.testGeoJsonObject(geoJsonDataName: "GeometryCollection: Empty geometries"), withProperties: [:])
        
        XCTAssertEqual(overlays.count, 0)
    }
    
    @available(iOS 13.0, *)
    func testGroupedOverlaysGeometryCollectionEmptyGeometries() {
        let overlays = overlayGenerator.groupedOverlays(for: [MockData.testGeoJsonObject(geoJsonDataName: "GeometryCollection: Empty geometries")], withProperties: [:])
        
        XCTAssertEqual(overlays.count, 0)
    }
    
    func testOverlaysFeature() {
        let overlays = overlayGenerator.overlays(for: MockData.testGeoJsonObject(geoJsonDataName: "Feature"), withProperties: [:])
        
        XCTAssertEqual(overlays.count, 1)
        
        let renderer = overlayGenerator.renderer(for: overlays[0], with: overlayRenderModel)
        
        XCTAssertTrue(renderer is MKPolygonRenderer)
    }
    
    @available(iOS 13.0, *)
    func testGroupedOverlaysFeature() {
        let overlays = overlayGenerator.groupedOverlays(for: [MockData.testGeoJsonObject(geoJsonDataName: "Feature")], withProperties: [:])
        
        XCTAssertEqual(overlays.count, 1)
        
        let renderer = overlayGenerator.renderer(for: overlays[0], with: overlayRenderModel)
        
        XCTAssertTrue(renderer is MKMultiPolygonRenderer)
    }
    
    func testOverlaysFeatureGeometryCollection() {
        let overlays = overlayGenerator.overlays(for: MockData.testGeoJsonObject(geoJsonDataName: "Feature: Geometry Collection"), withProperties: [:])
        
        XCTAssertEqual(overlays.count, 2)
        
        var renderer = overlayGenerator.renderer(for: overlays[0], with: overlayRenderModel)
        
        XCTAssertTrue(renderer is MKPolylineRenderer)
        
        renderer = overlayGenerator.renderer(for: overlays[1], with: overlayRenderModel)
        
        XCTAssertTrue(renderer is MKPolygonRenderer)
    }
    
    @available(iOS 13.0, *)
    func testGroupedOverlaysFeatureGeometryCollection() {
        let overlays = overlayGenerator.groupedOverlays(for: [MockData.testGeoJsonObject(geoJsonDataName: "Feature: Geometry Collection")], withProperties: [:])
        
        XCTAssertEqual(overlays.count, 2)
        
        var renderer = overlayGenerator.renderer(for: overlays[0], with: overlayRenderModel)
        
        XCTAssertTrue(renderer is MKMultiPolylineRenderer)
        
        renderer = overlayGenerator.renderer(for: overlays[1], with: overlayRenderModel)
        
        XCTAssertTrue(renderer is MKMultiPolygonRenderer)
    }
    
    func testOverlaysFeatureNullGeometry() {
        let overlays = overlayGenerator.overlays(for: MockData.testGeoJsonObject(geoJsonDataName: "Feature: null geometry"), withProperties: [:])
        
        XCTAssertEqual(overlays.count, 0)
    }
    
    @available(iOS 13.0, *)
    func testGroupedOverlaysFeatureNullGeometry() {
        let overlays = overlayGenerator.groupedOverlays(for: [MockData.testGeoJsonObject(geoJsonDataName: "Feature: null geometry")], withProperties: [:])
        
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
    
    @available(iOS 13.0, *)
    func testGroupedOverlaysFeatureCollection() {
        let overlays = overlayGenerator.groupedOverlays(for: [MockData.testGeoJsonObject(geoJsonDataName: "FeatureCollection")], withProperties: [:])
        
        XCTAssertEqual(overlays.count, 2)
        
        var renderer = overlayGenerator.renderer(for: overlays[0], with: overlayRenderModel)
        
        XCTAssertTrue(renderer is MKMultiPolylineRenderer)
        
        renderer = overlayGenerator.renderer(for: overlays[1], with: overlayRenderModel)
        
        XCTAssertTrue(renderer is MKMultiPolygonRenderer)
    }
    
    func testOverlaysFeatureCollection2Features1NullGeometry() {
        let overlays = overlayGenerator.overlays(for: MockData.testGeoJsonObject(geoJsonDataName: "FeatureCollection: 2 Features, 1 null geometry"), withProperties: [:])
        
        XCTAssertEqual(overlays.count, 1)
        
        let renderer = overlayGenerator.renderer(for: overlays[0], with: overlayRenderModel)
        
        XCTAssertTrue(renderer is MKPolylineRenderer)
    }
    
    @available(iOS 13.0, *)
    func testGroupedOverlaysFeatureCollection2Features1NullGeometry() {
        let overlays = overlayGenerator.groupedOverlays(for: [MockData.testGeoJsonObject(geoJsonDataName: "FeatureCollection: 2 Features, 1 null geometry")], withProperties: [:])
        
        XCTAssertEqual(overlays.count, 1)
        
        let renderer = overlayGenerator.renderer(for: overlays[0], with: overlayRenderModel)
        
        XCTAssertTrue(renderer is MKMultiPolylineRenderer)
    }
    
    func testOverlaysFeatureCollection1FeatureNullGeometry() {
        let overlays = overlayGenerator.overlays(for: MockData.testGeoJsonObject(geoJsonDataName: "FeatureCollection: 1 Feature, null geometry"), withProperties: [:])
        
        XCTAssertEqual(overlays.count, 0)
    }
    
    @available(iOS 13.0, *)
    func testGroupedOverlaysFeatureCollection1FeatureNullGeometry() {
        let overlays = overlayGenerator.groupedOverlays(for: [MockData.testGeoJsonObject(geoJsonDataName: "FeatureCollection: 1 Feature, null geometry")], withProperties: [:])
        
        XCTAssertEqual(overlays.count, 0)
    }
    
    func testRendererUnsupportedOverlay() {
        let renderer = overlayGenerator.renderer(for: MKCircle(), with: overlayRenderModel)
        
        XCTAssertFalse(renderer is MKPolygonRenderer)
        XCTAssertFalse(renderer is MKPolylineRenderer)
    }
    
    @available(iOS 13.0, *)
    func testGroupedOverlaysLotsOfGeometries() {
        let lotOfGeometries: [GeoJsonObject] = MockData.geoJsonTestAllData.compactMap { geoJsonData in
            // swiftlint:disable:next force_cast
            guard (geoJsonData["name"] as! String) != "Invalid Geometry" else { return nil }
            
            // swiftlint:disable:next force_cast
            return GeoTestHelper.parse(geoJsonData["geoJson"] as! GeoJsonDictionary)
        }
        
        let overlays = overlayGenerator.groupedOverlays(for: lotOfGeometries, withProperties: [:])
        
        XCTAssertEqual(overlays.count, 2)
        XCTAssertTrue(overlays.at(0) is GeospatialMultiPolylineOverlay)
        XCTAssertTrue(overlays.at(1) is GeospatialMultiPolygonOverlay)
        
        XCTAssertEqual((overlays.at(0) as? GeospatialMultiPolylineOverlay)?.polylines.count, 11)
        XCTAssertEqual((overlays.at(1) as? GeospatialMultiPolygonOverlay)?.polygons.count, 4622)
        
        let renderers = overlays.map { overlayGenerator.renderer(for: $0, with: overlayRenderModel) }
        
        XCTAssertEqual(renderers.count, 2)
    }
    
    @available(iOS 13.0, *)
    func disabled_testGroupedOverlaysLotsOfGeometries_Performance() {
        let bigData = (0..<22).flatMap { _ in MockData.geoJsonTestDataBig }
        var time = Date().timeIntervalSince1970
        let lotOfGeometries: [GeoJsonObject] = bigData.compactMap { geoJsonData in
            // swiftlint:disable:next force_cast
            guard (geoJsonData["name"] as! String) != "Invalid Geometry" else { return nil }
            
            // swiftlint:disable:next force_cast
            return GeoTestHelper.geospatial.geoJson.parseObject(fromValidatedGeoJson: geoJsonData["geoJson"] as! GeoJsonDictionary)
            // return GeoTestHelper.parse(geoJsonData["geoJson"] as! GeoJsonDictionary)
        }
        print("GeoJson parsing time: \(Date().timeIntervalSince1970 - time)")
        
        time = Date().timeIntervalSince1970
        let groupedOverlays = overlayGenerator.groupedOverlays(for: lotOfGeometries, withProperties: [:])
        print("Grouped Overlays time: \(Date().timeIntervalSince1970 - time)")
        
        XCTAssertEqual(groupedOverlays.count, 1)
        XCTAssertTrue(groupedOverlays.at(0) is GeospatialMultiPolygonOverlay)
        
        XCTAssertEqual((groupedOverlays.at(0) as? GeospatialMultiPolygonOverlay)?.polygons.count, 101376)
        
        time = Date().timeIntervalSince1970
        let groupedOverlayRenderers = groupedOverlays.map { overlayGenerator.renderer(for: $0, with: overlayRenderModel) }
        print("Grouped Overlays Renderers time: \(Date().timeIntervalSince1970 - time)")
        
        XCTAssertEqual(groupedOverlayRenderers.count, 1)
        
        time = Date().timeIntervalSince1970
        // swiftlint:disable:next force_cast
        let polygons = lotOfGeometries.flatMap { $0.closedGeometries.compactMap { ($0 as! GeoJson.Polygon) } }
        let multiPolygon = GeoTestHelper.geospatial.geoJson.multiPolygon(polygons: polygons).success!
        let overlays = overlayGenerator.overlays(for: multiPolygon, withProperties: [:])
        print("Overlays time: \(Date().timeIntervalSince1970 - time)")

        XCTAssertEqual(overlays.count, 1)
        XCTAssertTrue(overlays.at(0) is GeospatialMultiPolygonOverlay)

        XCTAssertEqual((overlays.at(0) as? GeospatialMultiPolygonOverlay)?.polygons.count, 101376)

        time = Date().timeIntervalSince1970
        let overlayRenderers = overlays.map { overlayGenerator.renderer(for: $0, with: overlayRenderModel) }
        print("Grouped Overlays Renderers time: \(Date().timeIntervalSince1970 - time)")

        XCTAssertEqual(overlayRenderers.count, 1)
    }
}
