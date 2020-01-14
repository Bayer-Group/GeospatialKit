public protocol GeospatialMapAnnotation: MKAnnotation {
    var properties: [String: Any] { get }
}

public final class GeospatialPointAnnotation: MKPointAnnotation, GeospatialMapAnnotation {
    public private(set) var properties: [String: Any] = [:]
    
    public init(properties: [String: Any]) {
        self.properties = properties
    }
    
    public convenience init(coordinate: CLLocationCoordinate2D, properties: [String: Any]) {
        self.init(properties: properties)
        
        self.coordinate = coordinate
    }
    
    public convenience init(coordinate: CLLocationCoordinate2D, title: String?, subtitle: String?, properties: [String: Any]) {
        self.init(properties: properties)
        
        self.title = title
        self.subtitle = subtitle
        self.coordinate = coordinate
    }
}
