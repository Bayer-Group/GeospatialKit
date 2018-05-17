import GeospatialKit

class DisplayViewController: UIViewController {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var mapView: MKMapView!
    
    var geospatial: GeospatialCocoa!
    var geoJsonObject: GeoJsonObject! {
        didSet {
            guard let geoJsonObject = geoJsonObject, let boundingBoxes = geoJsonObject.objectGeometries?.compactMap({ $0.objectBoundingBox }) else { return }
            geohashBoxes = boundingBoxes.flatMap { geospatial.geohash.geohashBoxes(for: $0, precision: 4) }
        }
    }
    
    var geohashBoxes: [GeoJsonGeohashBox]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let geoJsonObject = geoJsonObject else { return }
        
        mapView.addOverlays(geospatial.map.overlays(for: geoJsonObject))
        mapView.addAnnotations(geospatial.map.annotations(for: geoJsonObject, debug: true))
        
//        geohashBoxes?.forEach {
//            let linearRing = geospatial.geoJson.lineString(points: ($0.points + [$0.points.first!]).map { geospatial.geoJson.point(longitude: $0.longitude, latitude: $0.latitude) })!
//            mapView.addOverlays(geospatial.map.overlays(for: geospatial.geoJson.polygon(linearRings: [linearRing])!))
//        }
        
        refreshViews()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        refreshViews()
    }
    
    private func refreshViews() {
        DispatchQueue.main.async { [weak self] in
            guard let imageView = self?.imageView, let mapView = self?.mapView, let geoJsonObject = self?.geoJsonObject else { return }
            
            let imageRenderModel = ImageRenderModel(backgroundColor: UIColor.gray.cgColor, shapeFillColor: UIColor.blue.cgColor, shapeLineColor: UIColor.green.cgColor, width: Double(imageView.bounds.width), height: Double(imageView.bounds.height))
            
            imageView.image = self?.geospatial.image.create(for: geoJsonObject, with: imageRenderModel, debug: true)
            
            guard let boundingBox = geoJsonObject.objectBoundingBox else { print("🗺️ GeospatialExample 🗺️ No Bounding Box"); return }
            
            mapView.setRegion(boundingBox.region, animated: false)
        }
    }
}

extension DisplayViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let overlayRenderModel = OverlayRenderModel(lineWidth: 1.0, strokeColor: .white, fillColor: .green, alpha: 0.5)
        
        return geospatial.map.renderer(for: overlay, with: overlayRenderModel)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            //return nil so map view draws "blue dot" for standard user location
            
            return nil
        } else {
            let reuseId = "pointPin"
            let reusableAnnotationView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
            let pinView = reusableAnnotationView ?? MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            
            pinView.annotation = annotation
            pinView.pinTintColor = MKPinAnnotationView.redPinColor()
            
            return pinView
        }
    }
}
