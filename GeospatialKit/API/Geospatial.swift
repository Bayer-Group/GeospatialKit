/**
 A protocol provided for unit testing.
 */
public protocol GeospatialProtocol: class {
    var geoJson: GeoJsonProtocol { get }
    var geohash: GeohashCoderProtocol { get }
    var image: ImageManagerProtocol { get }
    var map: MapManagerProtocol { get }
    
    func parse(wkt: String) -> GeoJsonObject?
}

/**
 A framework to parse GeoJson and create GeoJson by means of a GeoJsonObject. This GeoJsonObject in turn can further be used to create overlays, annotations, and an image. A renderer can also be passed back for overlays and annotations for simple MapKit View interaction.
 
 The GeoJson object has many helper methods including boundingBox, which eliminates the need to add a bbox parameter on the geoJson.
 */
final public class Geospatial: NSObject, GeospatialProtocol {
    /**
     Everything GeoJson. The base of all other functionality.
     */
    public let geoJson: GeoJsonProtocol
    
    /**
     Everything Geohash
     */
    public let geohash: GeohashCoderProtocol
    
    /**
     Everything Image
     */
    public let image: ImageManagerProtocol
    
    /**
     Everything Map
     */
    public let map: MapManagerProtocol
    
    internal let wktParser: WktParserProtocol
    
    /**
     Initialize the interface using a configuration to describe how the interface should react to requests.
     */
    public init(configuration: ConfigurationModel) {
        let logger = Logger(applicationPrefix: "🗺️ Geospatial 🗺️", minimumLogLevelShown: configuration.logLevel)
        let geodesicCalculator = GeodesicCalculator(logger: logger)
        
        geoJson = GeoJson(logger: logger, geodesicCalculator: geodesicCalculator)
        
        geohash = GeohashCoder(logger: logger, geodesicCalculator: geodesicCalculator)
        image = ImageManager(logger: logger)
        map = MapManager(logger: logger)
        wktParser = WktParser(logger: logger, geoJson: geoJson)
        
        super.init()
    }
    
    /**
     Parses a WKT String. Not all formats are currently supported.
     
     - wkt: a String which conforms to a specific WKT format.
     
     - returns: A successfully parsed GeoJsonObject or nil if the specification was not correct
     
     TODO: Experimental, untested, not fully written, and no plans to fully support in the future.
     */
    public func parse(wkt: String) -> GeoJsonObject? {
        return wktParser.geoJsonObject(from: wkt)
    }
}
