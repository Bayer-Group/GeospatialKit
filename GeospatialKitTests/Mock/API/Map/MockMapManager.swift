@testable import GeospatialKit

final class MockMapManager: MapManagerProtocol {
    private(set) var overlaysCallCount = 0
    var overlaysResult: [MKOverlay] = []
    func overlays(for geoJsonObject: GeoJsonObject) -> [MKOverlay] {
        overlaysCallCount += 1
        
        return overlaysResult
    }
    
    private(set) var annotationsCallCount = 0
    var annotationsResult: [MKAnnotation] = []
    func annotations(for geoJsonObject: GeoJsonObject) -> [MKAnnotation] {
        annotationsCallCount += 1
        
        return annotationsResult
    }
    
    private(set) var annotationsDebugCallCount = 0
    var annotationsDebugResult: [MKAnnotation] = []
    func annotations(for geoJsonObject: GeoJsonObject, debug: Bool) -> [MKAnnotation] {
        annotationsDebugCallCount += 1
        
        return annotationsDebugResult
    }
    
    private(set) var rendererCallCount = 0
    var rendererResult = MKOverlayRenderer()
    func renderer(for overlay: MKOverlay, with overlayRenderModel: OverlayRenderModel) -> MKOverlayRenderer {
        rendererCallCount += 1
        
        return rendererResult
    }
}
