import GeospatialKit

class DisplayViewController: UIViewController {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var mapImageView: UIImageView!
    @IBOutlet weak var mapView: MKMapView!
    
    let backgroundColor = UIColor.darkGray
    let strokeColor = UIColor.white
    let fillColor = UIColor.green
    let pinTintColor = UIColor.red
    let alpha: CGFloat = 0.5
    
    var overlayRenderModel: OverlayRenderModel { return OverlayRenderModel(lineWidth: 0.8, strokeColor: strokeColor, fillColor: fillColor, pinTintColor: pinTintColor, alpha: 0.5) }
    
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
            guard let capturedSelf = self else { return }
            
            let imageRenderModel = ImageRenderModel(backgroundColor: capturedSelf.backgroundColor, shapeFillColor: capturedSelf.fillColor.withAlphaComponent(capturedSelf.alpha), shapeLineColor: capturedSelf.strokeColor.withAlphaComponent(capturedSelf.alpha), pinTintColor: capturedSelf.pinTintColor, width: Double(capturedSelf.imageView.bounds.width), height: Double(capturedSelf.imageView.bounds.height), lineWidth: 5.0, inset: 0.20)
            
            capturedSelf.imageView.image = capturedSelf.geospatial.image.image(for: capturedSelf.geoJsonObject, with: imageRenderModel, debug: true)
            capturedSelf.mapImageView.image = capturedSelf.imageView.image
            
            DispatchQueue.main.async {
                capturedSelf.geospatial.image.snapshot(for: capturedSelf.geoJsonObject, with: imageRenderModel, debug: true) { image in
                    guard let image = image else { return }
                    
                    capturedSelf.mapImageView.image = image
                }
            }
            
            guard let insetBoundingBox = capturedSelf.geoJsonObject.objectBoundingBox?.mappingBoundingBox(insetPercent: 0.20) else { print("🗺️ GeospatialExample 🗺️ No Bounding Box"); return }
            
            capturedSelf.mapView.setRegion(insetBoundingBox.region, animated: false)
            
//            DispatchQueue.main.async {
//                print(insetBoundingBox.region)
//                print(capturedSelf.mapView.region)
//                print(capturedSelf.mapView.regionThatFits(capturedSelf.mapView.region))
//
//                MKCoordinateRegion(center: __C.CLLocationCoordinate2D(latitude: -0.050000000000000711, longitude: -0.050000000000000711), span: __C.MKCoordinateSpan(latitudeDelta: 28.140000000000001, longitudeDelta: 28.140000000000001))
//                MKCoordinateRegion(center: __C.CLLocationCoordinate2D(latitude: -0.050000000000011369, longitude: -0.049999999999946004), span: __C.MKCoordinateSpan(latitudeDelta: 28.139999862599879, longitudeDelta: 51.415709046523006))
//                MKCoordinateRegion(center: __C.CLLocationCoordinate2D(latitude: -0.04999999681780104, longitude: -0.049999999999926104), span: __C.MKCoordinateSpan(latitudeDelta: 28.14000000000479, longitudeDelta: 51.415709046522977))
//            }
        }
    }
}

extension DisplayViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        return geospatial.map.renderer(for: overlay, with: overlayRenderModel)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            //return nil so map view draws "blue dot" for standard user location
            
            return nil
        } else {
            return geospatial.map.annotationView(for: annotation, with: overlayRenderModel, from: mapView, reuseId: "pointPin")
        }
    }
}
