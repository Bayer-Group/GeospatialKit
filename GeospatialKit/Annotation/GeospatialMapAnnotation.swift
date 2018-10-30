public protocol GeospatialMapAnnotation: MKAnnotation {
    var properties: [String: Any] { get }
}

public final class GeospatialPointAnnotation: MKPointAnnotation, GeospatialMapAnnotation {
    public private(set) var properties: [String: Any] = [:]
    
    init(properties: [String: Any]) {
        self.properties = properties
    }
}
