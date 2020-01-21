@testable import GeospatialKit

final class MockMapManager: MapManagerProtocol {
    private(set) var groupedOverlaysCallCount = 0
    var groupedOverlaysResult: [GeospatialMapOverlay] = []
    func groupedOverlays(for geoJsonObjects: [GeoJsonObject], withProperties properties: [String: Any]) -> [GeospatialMapOverlay] {
        groupedOverlaysCallCount += 1
        
        return groupedOverlaysResult
    }
    
    private(set) var overlaysCallCount = 0
    var overlaysResult: [GeospatialMapOverlay] = []
    func overlays(for geoJsonObject: GeoJsonObject, withProperties properties: [String: Any]) -> [GeospatialMapOverlay] {
        overlaysCallCount += 1
        
        return overlaysResult
    }
    
    private(set) var annotationViewCallCount = 0
    var annotationViewResult: MKAnnotationView = MKAnnotationView()
    func annotationView(for annotation: MKAnnotation, with overlayRenderModel: OverlayRenderModel, from mapView: MKMapView, reuseId: String) -> MKAnnotationView {
        annotationViewCallCount += 1
        
        return annotationViewResult
    }
    
    private(set) var annotationsCallCount = 0
    var annotationsResult: [GeospatialMapAnnotation] = []
    func annotations(for geoJsonObject: GeoJsonObject, withProperties properties: [String: Any], debug: Bool) -> [GeospatialMapAnnotation] {
        annotationsCallCount += 1
        
        return annotationsResult
    }
    
    private(set) var rendererCallCount = 0
    var rendererResult = MKOverlayRenderer()
    func renderer(for overlay: MKOverlay, with overlayRenderModel: OverlayRenderModel) -> MKOverlayRenderer {
        rendererCallCount += 1
        
        return rendererResult
    }
}
