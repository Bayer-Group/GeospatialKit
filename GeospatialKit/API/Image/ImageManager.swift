public protocol ImageManagerProtocol {
    func create(for geoJsonObject: GeoJsonObject, with imageRenderModel: ImageRenderModel) -> UIImage?
    func create(for geoJsonObject: GeoJsonObject, with imageRenderModel: ImageRenderModel, debug: Bool) -> UIImage?
}

public struct ImageManager: ImageManagerProtocol {
    internal let imageGenerator: ImageGeneratorProtocol
    
    static let debugAlpha: CGFloat = 0.2
    
    init(logger: LoggerProtocol, calculator: GeodesicCalculatorProtocol) {
        imageGenerator = ImageGenerator(logger: logger, calculator: calculator)
    }
    
    /**
     Renders an image for the geoJsonObject and imageRenderModel. The image will obey the correct aspect ratio and yet still fit in the provided width and height with a set padding on the sides.
     
     - geoJsonObject: The GeoJsonObject to render
     - imageRenderModel: The options to use when rendering
     
     - returns: A UIImage for a GeoJsonObject which can be rendered. For example, an empty Feature Collection cannot be rendered whereas a Polygon can.
     */
    public func create(for geoJsonObject: GeoJsonObject, with imageRenderModel: ImageRenderModel) -> UIImage? {
        return imageGenerator.create(for: geoJsonObject, with: imageRenderModel, debug: false)
    }
    public func create(for geoJsonObject: GeoJsonObject, with imageRenderModel: ImageRenderModel, debug: Bool) -> UIImage? {
        return imageGenerator.create(for: geoJsonObject, with: imageRenderModel, debug: debug)
    }
}
