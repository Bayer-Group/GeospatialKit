import CoreLocation
import GeospatialSwift

public extension SimplePolygon {
    init?(locationCoordinates: [CLLocationCoordinate2D]) {
        guard let mainRing = SimpleLine(locationCoordinates: locationCoordinates) else { return nil }
        
        self.init(mainRing: mainRing)
    }
    
    init?(mainRingLocationCoordinates: [CLLocationCoordinate2D], negativeRingsLocationCoordinates: [[CLLocationCoordinate2D]]) {
        guard let mainRing = SimpleLine(locationCoordinates: mainRingLocationCoordinates) else { return nil }
        
        let negativeRings = negativeRingsLocationCoordinates.compactMap { SimpleLine(locationCoordinates: $0) }
        
        guard negativeRingsLocationCoordinates.count == negativeRings.count else { return nil }
        
        self.init(mainRing: mainRing, negativeRings: negativeRings)
    }
}
