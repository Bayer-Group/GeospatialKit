public protocol MapManagerProtocol {
    func annotations(for geoJsonObject: GeoJsonObject, debug: Bool) -> [MKAnnotation]
    func annotationView(for annotation: MKAnnotation, with overlayRenderModel: OverlayRenderModel, from mapView: MKMapView, reuseId: String) -> MKAnnotationView
    func overlays(for geoJsonObject: GeoJsonObject) -> [MKOverlay]
    func renderer(for overlay: MKOverlay, with overlayRenderModel: OverlayRenderModel) -> MKOverlayRenderer
}

public extension MapManagerProtocol {
    func annotations(for geoJsonObject: GeoJsonObject) -> [MKAnnotation] {
        return annotations(for: geoJsonObject, debug: false)
    }
}

public struct MapManager: MapManagerProtocol {
    internal let overlayGenerator: OverlayGeneratorProtocol
    internal let annotationGenerator: AnnotationGeneratorProtocol
    
    init() {
        overlayGenerator = OverlayGenerator()
        annotationGenerator = AnnotationGenerator()
    }
    
    /**
     Returns annotations for the qualifying componenets of the GeoJsonObject
     
     - geoJsonObject: The GeoJsonObject used to create annotations
     
     - returns: annotations for qualifying components
     */
    public func annotations(for geoJsonObject: GeoJsonObject, debug: Bool) -> [MKAnnotation] {
        return annotationGenerator.annotations(for: geoJsonObject, debug: debug)
    }
    
    /**
     Returns an annotationView for the annotation using the overlayRenderModel
     
     - geoJsonObject: The GeoJsonObject used to create annotations
     
     - returns: annotations for qualifying components
     */
    public func annotationView(for annotation: MKAnnotation, with overlayRenderModel: OverlayRenderModel, from mapView: MKMapView, reuseId: String) -> MKAnnotationView {
        return annotationGenerator.annotationView(for: annotation, with: overlayRenderModel, from: mapView, reuseId: reuseId)
    }
    
    /**
     Returns overlays for the qualifying componenets of the geoJsonObject
     
     - geoJsonObject: The GeoJsonObject used to create overlays
     
     - returns: overlays for qualifying components
     */
    public func overlays(for geoJsonObject: GeoJsonObject) -> [MKOverlay] {
        return overlayGenerator.overlays(for: geoJsonObject)
    }
    
    /**
     Returns a renderer for the overlay using the overlayRenderModel
     
     - overlay: The overlay for the renderer
     - overlayRenderModel: The options to use when creating the renderer
     
     - returns: A renderer for the overlay
     */
    public func renderer(for overlay: MKOverlay, with overlayRenderModel: OverlayRenderModel) -> MKOverlayRenderer {
        return overlayGenerator.renderer(for: overlay, with: overlayRenderModel)
    }
}
