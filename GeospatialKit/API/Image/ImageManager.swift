public protocol ImageManagerProtocol {
    func image(for geoJsonObject: GeoJsonObject, with drawingRenderModel: DrawingRenderModel, width: Double, height: Double, debug: Bool) -> UIImage?
    func snapshot(for geoJsonObject: GeoJsonObject, with drawingRenderModel: DrawingRenderModel, width: Double, height: Double, debug: Bool, completion: @escaping (UIImage?) -> Void)
}

extension ImageManagerProtocol {
    public func image(for geoJsonObject: GeoJsonObject, with drawingRenderModel: DrawingRenderModel, width: Double, height: Double) -> UIImage? {
        return image(for: geoJsonObject, with: drawingRenderModel, width: width, height: height, debug: false)
    }
    
    public func snapshot(for geoJsonObject: GeoJsonObject, with drawingRenderModel: DrawingRenderModel, width: Double, height: Double, completion: @escaping (UIImage?) -> Void) {
        snapshot(for: geoJsonObject, with: drawingRenderModel, width: width, height: height, debug: false, completion: completion)
    }
    
    public func image(for geoJsonObjects: [GeoJsonObject], with drawingRenderModel: DrawingRenderModel, width: Double, height: Double) -> UIImage? {
        let geometries = geoJsonObjects.compactMap { $0.objectGeometries }.flatMap { $0 }
        let geoJsonObject = Geospatial().geoJson.geometryCollection(geometries: geometries)
        
        return image(for: geoJsonObject, with: drawingRenderModel, width: width, height: height, debug: false)
    }
    
    public func snapshot(for geoJsonObjects: [GeoJsonObject], with drawingRenderModel: DrawingRenderModel, width: Double, height: Double, completion: @escaping (UIImage?) -> Void) {
        let geometries = geoJsonObjects.compactMap { $0.objectGeometries }.flatMap { $0 }
        let geoJsonObject = Geospatial().geoJson.geometryCollection(geometries: geometries)
        
        snapshot(for: geoJsonObject, with: drawingRenderModel, width: width, height: height, debug: false, completion: completion)
    }
}

public struct ImageManager: ImageManagerProtocol {
    internal let imageGenerator: ImageGeneratorProtocol
    
    init() {
        imageGenerator = ImageGenerator()
    }
    
    /**
     Renders an image for the geoJsonObject and drawingRenderModel. The image will obey the correct aspect ratio and yet still fit in the provided width and height with a set padding on the sides.
     
     - geoJsonObject: The GeoJsonObject to render
     - drawingRenderModel: The options to use when rendering
     
     - returns: A UIImage for a GeoJsonObject which can be rendered. For example, an empty Feature Collection cannot be rendered whereas a Polygon can.
     */
    public func image(for geoJsonObject: GeoJsonObject, with drawingRenderModel: DrawingRenderModel, width: Double, height: Double, debug: Bool) -> UIImage? {
        return imageGenerator.image(for: geoJsonObject, with: drawingRenderModel, width: width, height: height, debug: debug)
    }
    
    /**
     Same as create but with a Map background
     
     - returns: A UIImage as with image overlayed onto a Map
     */
    public func snapshot(for geoJsonObject: GeoJsonObject, with drawingRenderModel: DrawingRenderModel, width: Double, height: Double, debug: Bool, completion: @escaping (UIImage?) -> Void) {
        imageGenerator.snapshot(for: geoJsonObject, with: drawingRenderModel, width: width, height: height, debug: debug, completion: completion)
    }
}
