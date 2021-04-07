import GeospatialSwift
import MapKit

extension MKCoordinateRegion {
    var boundingBox: GeodesicBoundingBox {
        let minLatitude = center.latitude - span.latitudeDelta / 2.0
        let minLongitude = center.longitude - span.longitudeDelta / 2.0
        let maxLatitude = center.latitude + span.latitudeDelta / 2.0
        let maxLongitude = center.longitude + span.longitudeDelta / 2.0
        
        return .init(minLongitude: minLongitude, minLatitude: minLatitude, maxLongitude: maxLongitude, maxLatitude: maxLatitude)
    }
}
