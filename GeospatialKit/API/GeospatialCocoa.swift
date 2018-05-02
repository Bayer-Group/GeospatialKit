public typealias ConfigurationModel = GeospatialSwift.ConfigurationModel

/**
 A protocol provided for unit testing.
 */
public protocol GeospatialCocoaProtocol: GeospatialProtocol {
    var image: ImageManagerProtocol! { get }
    var map: MapManagerProtocol! { get }
}

/**
 Extends GeospatialSwift with Cocoa functionality. Create an image or render overlays and annotations for simple MapKit View interaction.
 */
final public class GeospatialCocoa: Geospatial, GeospatialCocoaProtocol {
    /**
     Everything Image
     */
    public private(set) var image: ImageManagerProtocol!
    
    /**
     Everything Map
     */
    public private(set) var map: MapManagerProtocol!
    
    /**
     Initialize the interface using a configuration to describe how the interface should react to requests.
     */
    public override init(configuration: ConfigurationModel) {
        let logger = Logger(applicationPrefix: "🗺️ GeospatialKit 🗺️", minimumLogLevelShown: configuration.logLevel)
        
        super.init(configuration: configuration)
        
        image = ImageManager(logger: logger, calculator: calculator)
        map = MapManager(logger: logger, calculator: calculator)
    }
}
