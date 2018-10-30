import MapKit

extension MKMapView {
    open var currentZoomLevel: Int {
        let maxZoom: Double = 24
        let zoomScale = visibleMapRect.size.width / Double(frame.size.width)
        let zoomExponent = log2(zoomScale)
        return Int(maxZoom - ceil(zoomExponent))
    }
    
    open func setCenterCoordinate(_ centerCoordinate: CLLocationCoordinate2D, withZoomLevel zoomLevel: Int, animated: Bool) {
        let minZoomLevel = min(zoomLevel, 28)
        
        let span = coordinateSpan(centerCoordinate, andZoomLevel: minZoomLevel)
        let region = MKCoordinateRegion(center: centerCoordinate, span: span)
        
        setRegion(region, animated: animated)
    }
}

private let mercatorOffset: Double = 268435456
private let mercatorRadius: Double = 85445659.44705395
struct PixelSpace {
    public var x: Double
    public var y: Double
}

fileprivate extension MKMapView {
    func coordinateSpan(_ centerCoordinate: CLLocationCoordinate2D, andZoomLevel zoomLevel: Int) -> MKCoordinateSpan {
        let space = pixelSpace(fromLongitue: centerCoordinate.longitude, withLatitude: centerCoordinate.latitude)
        
        // determine the scale value from the zoom level
        let zoomExponent = 20 - zoomLevel
        let zoomScale = pow(2.0, Double(zoomExponent))
        
        // scale the map’s size in pixel space
        let mapSizeInPixels = self.bounds.size
        let scaledMapWidth = Double(mapSizeInPixels.width) * zoomScale
        let scaledMapHeight = Double(mapSizeInPixels.height) * zoomScale
        
        // figure out the position of the top-left pixel
        let topLeftPixelX = space.x - (scaledMapWidth / 2)
        let topLeftPixelY = space.y - (scaledMapHeight / 2)
        
        var minSpace = space
        minSpace.x = topLeftPixelX
        minSpace.y = topLeftPixelY
        
        var maxSpace = space
        maxSpace.x += scaledMapWidth
        maxSpace.y += scaledMapHeight
        
        // find delta between left and right longitudes
        let minLongitude = coordinate(fromPixelSpace: minSpace).longitude
        let maxLongitude = coordinate(fromPixelSpace: maxSpace).longitude
        let longitudeDelta = maxLongitude - minLongitude
        
        // find delta between top and bottom latitudes
        let minLatitude = coordinate(fromPixelSpace: minSpace).latitude
        let maxLatitude = coordinate(fromPixelSpace: maxSpace).latitude
        let latitudeDelta = -1 * (maxLatitude - minLatitude)
        
        return MKCoordinateSpan(latitudeDelta: latitudeDelta, longitudeDelta: longitudeDelta)
    }
    
    func pixelSpace(fromLongitue longitude: Double, withLatitude latitude: Double) -> PixelSpace {
        let x = round(mercatorOffset + mercatorRadius * longitude * Double.pi / 180.0)
        let y = round(mercatorOffset - mercatorRadius * log((1 + sin(latitude * Double.pi / 180.0)) / (1 - sin(latitude * Double.pi / 180.0))) / 2.0)
        return PixelSpace(x: x, y: y)
    }
    
    func coordinate(fromPixelSpace pixelSpace: PixelSpace) -> CLLocationCoordinate2D {
        let longitude = ((round(pixelSpace.x) - mercatorOffset) / mercatorRadius) * 180.0 / Double.pi
        let latitude = (Double.pi / 2.0 - 2.0 * atan(exp((round(pixelSpace.y) - mercatorOffset) / mercatorRadius))) * 180.0 / Double.pi
        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}
