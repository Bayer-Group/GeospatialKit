public typealias BoundingCoordinates = (minLongitude: Double, minLatitude: Double, maxLongitude: Double, maxLatitude: Double)

public protocol GeoJsonBoundingBox: CustomStringConvertible {
    var minLongitude: Double { get }
    var minLatitude: Double { get }
    var maxLongitude: Double { get }
    var maxLatitude: Double { get }
    
    var points: [GeodesicPoint] { get }
    var centroid: GeodesicPoint { get }
    var boundingCoordinates: BoundingCoordinates { get }
    
    var region: MKCoordinateRegion { get }
    
    var imageBoundingBox: GeoJsonBoundingBox { get }
    
    func best(_ boundingBoxes: [GeoJsonBoundingBox]) -> GeoJsonBoundingBox
    func contains(longitude: Double, latitude: Double) -> Bool
    func overlaps(boundingBox: GeoJsonBoundingBox) -> Bool
}

/**
 A bounding box intended to exactly fit a GeoJsonObject. Also known as a "Minimum Bounding Box", "Bounding Envelope".
 */
public class BoundingBox: GeoJsonBoundingBox, Equatable {
    public var description: String {
        return "BoundingBox: (\n\tminLongitude: \(minLongitude),\n\tminLatitude: \(minLatitude),\n\tmaxLongitude: \(maxLongitude),\n\tmaxLatitude: \(maxLatitude),\n\tcentroid: \(centroid)\n)"
    }
    
    public var points: [GeodesicPoint]
    
    public let centroid: GeodesicPoint
    
    // A region for displaying on the map. Should be called from viewDidAppear or later.
    public var region: MKCoordinateRegion {
        let coordinateSpan = MKCoordinateSpanMake(latitudeDelta * BoundingBox.mapRegionInset, longitudeDelta * BoundingBox.mapRegionInset)
        
        let centerCoordinate = CLLocationCoordinate2D(latitude: centroid.latitude, longitude: centroid.longitude)
        
        return MKCoordinateRegionMake(centerCoordinate, coordinateSpan)
    }
    
    public var boundingCoordinates: BoundingCoordinates { return (minLongitude: minLongitude, minLatitude: minLatitude, maxLongitude: maxLongitude, maxLatitude: maxLatitude) }
    
    public var imageBoundingBox: GeoJsonBoundingBox {
        let longitudeAdjustment = minLongitude == maxLongitude ? BoundingBox.imageMinimumAdjustment : 0
        let latitudeAdjustment = minLatitude == maxLatitude ? BoundingBox.imageMinimumAdjustment : 0
        
        let boundingCoordinates = (minLongitude: minLongitude - longitudeAdjustment, minLatitude: minLatitude - latitudeAdjustment, maxLongitude: maxLongitude + longitudeAdjustment, maxLatitude: maxLatitude + latitudeAdjustment)
        
        return BoundingBox(boundingCoordinates: boundingCoordinates)
    }
    
    public let minLongitude: Double
    public let minLatitude: Double
    public let maxLongitude: Double
    public let maxLatitude: Double
    
    internal let longitudeDelta: Double
    internal let latitudeDelta: Double
    
    internal init(boundingCoordinates: BoundingCoordinates) {
        minLongitude = boundingCoordinates.minLongitude
        minLatitude = boundingCoordinates.minLatitude
        maxLongitude = boundingCoordinates.maxLongitude
        maxLatitude = boundingCoordinates.maxLatitude
        
        points = [SimplePoint(longitude: minLongitude, latitude: minLatitude), SimplePoint(longitude: minLongitude, latitude: maxLatitude), SimplePoint(longitude: maxLongitude, latitude: maxLatitude), SimplePoint(longitude: maxLongitude, latitude: minLatitude)]
        
        longitudeDelta = maxLongitude - minLongitude
        latitudeDelta = maxLatitude - minLatitude
        
        centroid = SimplePoint(longitude: maxLongitude - (longitudeDelta / 2), latitude: maxLatitude - (latitudeDelta / 2))
    }
    
    public func contains(longitude: Double, latitude: Double) -> Bool {
        return longitude >= minLongitude && longitude <= maxLongitude && latitude >= minLatitude && latitude <= maxLatitude
    }
    
    public func overlaps(boundingBox: GeoJsonBoundingBox) -> Bool {
        return contains(longitude: boundingBox.minLongitude, latitude: boundingBox.minLatitude)
            || contains(longitude: boundingBox.minLongitude, latitude: boundingBox.maxLatitude)
            || contains(longitude: boundingBox.maxLongitude, latitude: boundingBox.minLatitude)
            || contains(longitude: boundingBox.maxLongitude, latitude: boundingBox.maxLatitude)
            || boundingBox.contains(longitude: minLongitude, latitude: minLatitude)
            || boundingBox.contains(longitude: minLongitude, latitude: maxLatitude)
            || boundingBox.contains(longitude: maxLongitude, latitude: minLatitude)
            || boundingBox.contains(longitude: maxLongitude, latitude: maxLatitude)
    }
    
    // TODO: This should follow the rule "5.2. The Antimeridian" in the GeoJson spec.
    public func best(_ boundingBoxes: [GeoJsonBoundingBox]) -> GeoJsonBoundingBox {
        return boundingBoxes.reduce(self) {
            let boundingCoordinates = (minLongitude: min($0.minLongitude, $1.minLongitude), minLatitude: min($0.minLatitude, $1.minLatitude), maxLongitude: max($0.maxLongitude, $1.maxLongitude), maxLatitude: max($0.maxLatitude, $1.maxLatitude))
            
            return BoundingBox(boundingCoordinates: boundingCoordinates)
        }
    }
    
    public static func == (lhs: BoundingBox, rhs: BoundingBox) -> Bool { return lhs as GeoJsonBoundingBox == rhs as GeoJsonBoundingBox }
}

internal extension BoundingBox {
    static internal var imageMinimumAdjustment: Double { return 0.00005 }
    static internal var mapRegionInset: Double { return 1.2 }
    
    internal static func best(_ boundingBoxes: [GeoJsonBoundingBox]) -> GeoJsonBoundingBox? {
        guard let firstBoundingBox = boundingBoxes.first else { return nil }
        
        guard let boundingBoxesTail = boundingBoxes.tail, !boundingBoxesTail.isEmpty else { return firstBoundingBox }
        
        return firstBoundingBox.best(boundingBoxesTail)
    }
}

public func == (lhs: GeoJsonBoundingBox, rhs: GeoJsonBoundingBox) -> Bool {
    return lhs.minLongitude == rhs.minLongitude && lhs.minLatitude == rhs.minLatitude && lhs.maxLongitude == rhs.maxLongitude && lhs.maxLatitude == rhs.maxLatitude
}
