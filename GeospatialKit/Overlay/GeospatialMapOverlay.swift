import MapKit

public protocol GeospatialMapOverlay: MKOverlay {
    var properties: [String: Any] { get }
}

@available(iOS 13.0, *)
public final class GeospatialMultiPolygonOverlay: MKMultiPolygon, GeospatialMapOverlay {
    public private(set) var properties: [String: Any] = [:]
    
    public convenience init(polygons: [GeospatialPolygonOverlay], properties: [String: Any]) {
        self.init(polygons)
        
        self.properties = properties
    }
}

@available(iOS 13.0, *)
public final class GeospatialMultiPolylineOverlay: MKMultiPolyline, GeospatialMapOverlay {
    public private(set) var properties: [String: Any] = [:]
    
    public convenience init(lines: [GeospatialPolylineOverlay], properties: [String: Any]) {
        self.init(lines)
        
        self.properties = properties
    }
}

public final class GeospatialPolygonOverlay: MKPolygon, GeospatialMapOverlay {
    public private(set) var properties: [String: Any] = [:]
    
    public convenience init(coordinates coords: UnsafePointer<CLLocationCoordinate2D>, count: Int, interiorPolygons: [MKPolygon]?, properties: [String: Any]) {
        self.init(coordinates: coords, count: count, interiorPolygons: interiorPolygons)
        
        self.properties = properties
    }
}

public final class GeospatialPolylineOverlay: MKPolyline, GeospatialMapOverlay {
    public private(set) var properties: [String: Any] = [:]
    
    public convenience init(coordinates coords: UnsafePointer<CLLocationCoordinate2D>, count: Int, properties: [String: Any]) {
        self.init(coordinates: coords, count: count)
        
        self.properties = properties
    }
}
