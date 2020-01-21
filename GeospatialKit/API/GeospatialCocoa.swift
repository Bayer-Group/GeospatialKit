/**
 A protocol provided for unit testing.
 */
public protocol GeospatialCocoaProtocol: GeospatialProtocol {
    var image: ImageManagerProtocol { get }
    var map: MapManagerProtocol { get }
    
    func drawing(context: CGContext, drawingRenderModel: DrawingRenderModel) -> GeometryProjectorProtocol
}

/**
 Extends GeospatialSwift with Cocoa functionality. Create an image or render overlays and annotations for simple MapKit View interaction.
 */
final public class GeospatialCocoa: Geospatial, GeospatialCocoaProtocol {
    /**
     Everything Image
     */
    public let image: ImageManagerProtocol
    
    /**
     Everything Map
     */
    public let map: MapManagerProtocol
    
    /**
     Initialize the interface using a configuration to describe how the interface should react to requests.
     */
    public override init() {
        image = ImageManager()
        map = MapManager()
        
        super.init()
    }
    
    public func drawing(context: CGContext, drawingRenderModel: DrawingRenderModel) -> GeometryProjectorProtocol {
        return GeometryProjector(context: context, drawingRenderModel: drawingRenderModel, debug: false)
    }
}
