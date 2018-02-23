@testable import GeospatialKit

class MockMapManager: MapManagerProtocol {
    private(set) var overlaysCallCount = 0
    private(set) var annotationsCallCount = 0
    private(set) var annotationsDebugCallCount = 0
    private(set) var rendererCallCount = 0
    
    var overlaysResult: [MKOverlay] = []
    var annotationsResult: [MKAnnotation] = []
    var annotationsDebugResult: [MKAnnotation] = []
    var rendererResult = MKOverlayRenderer()
    
    func overlays(for geoJsonObject: GeoJsonObject) -> [MKOverlay] {
        overlaysCallCount += 1
        
        return overlaysResult
    }
    
    func annotations(for geoJsonObject: GeoJsonObject) -> [MKAnnotation] {
        annotationsCallCount += 1
        
        return annotationsResult
    }
    
    func annotations(for geoJsonObject: GeoJsonObject, debug: Bool) -> [MKAnnotation] {
        annotationsDebugCallCount += 1
        
        return annotationsDebugResult
    }
    
    func renderer(for overlay: MKOverlay, with overlayRenderModel: OverlayRenderModel) -> MKOverlayRenderer {
        rendererCallCount += 1
        
        return rendererResult
    }
}
