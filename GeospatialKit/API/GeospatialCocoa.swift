import CoreGraphics
import GeospatialSwift

/**
 Extends GeospatialSwift with Cocoa functionality. Create an image or render overlays and annotations for simple MapKit View interaction.
 */
final public class GeospatialCocoa: Geospatial {
    /**
     Everything Image
     */
    public let image: ImageManager
    
    /**
     Everything Map
     */
    public let map: MapManager
    
    /**
     Initialize the interface using a configuration to describe how the interface should react to requests.
     */
    public override init() {
        image = ImageManager()
        map = MapManager()
        
        super.init()
    }
    
    public func drawing(context: CGContext, drawingRenderModel: DrawingRenderModel) -> GeometryProjector {
        return GeometryProjector(context: context, drawingRenderModel: drawingRenderModel, debug: false)
    }
}
