import GeospatialKit

class DisplayViewController: UIViewController {
    @IBOutlet weak var drawingViewWrapper: DrawingViewWrapper!
    
    @IBOutlet weak var mapImageView: UIImageView!
    
    @IBOutlet weak var mapView: MKMapView!
    
    let backgroundColor = UIColor.darkGray
    let strokeColor = UIColor.white
    let fillColor = UIColor.green
    let pinTintColor = UIColor.red
    let alpha: CGFloat = 0.5
    
    var overlayRenderModel: OverlayRenderModel { return OverlayRenderModel(lineWidth: 0.8, strokeColor: strokeColor, fillColor: fillColor, pinTintColor: pinTintColor, alpha: 0.5) }
    
    var drawingRenderModel: DrawingRenderModel { return DrawingRenderModel(backgroundColor: backgroundColor, shapeFillColor: fillColor.withAlphaComponent(alpha), shapeLineColor: strokeColor.withAlphaComponent(alpha), pinTintColor: pinTintColor, lineWidth: 5.0, inset: 0.20) }
    
    var geospatial: GeospatialCocoa!
    var geoJsonObject: GeoJsonObject! {
        didSet {
            //            guard let geoJsonObject = geoJsonObject, let boundingBoxes = geoJsonObject.objectGeometries?.compactMap({ $0.objectBoundingBox }) else { return }
            //            geohashBoxes = boundingBoxes.flatMap { geospatial.geohash.geohashBoxes(for: $0, precision: 4) }
        }
    }
    
    var geohashBoxes: [GeoJsonGeohashBox]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let geoJsonObject = geoJsonObject else { return }
        
        drawingViewWrapper.geospatialCocoa = geospatial
        drawingViewWrapper.geoJsonObject = geoJsonObject
        drawingViewWrapper.drawingRenderModel = drawingRenderModel
        
        mapView.addOverlays(geospatial.map.overlays(for: geoJsonObject))
        mapView.addAnnotations(geospatial.map.annotations(for: geoJsonObject, withProperties: [:], debug: false))
        
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
            guard let geospatial = self?.geospatial, let geoJsonObject = self?.geoJsonObject, let drawingRenderModel = self?.drawingRenderModel, let mapView = self?.mapView, let mapImageView = self?.mapImageView else { return }
            
            mapImageView.image = geospatial.image.image(for: geoJsonObject, with: drawingRenderModel, width: Double(mapImageView.bounds.width), height: Double(mapImageView.bounds.height), debug: false)
            
            // For small geometries: region.span.latitudeDelta > 0.008 || region.span.longitudeDelta > 0.008
            
            DispatchQueue.main.async {
                // let coordinator =
                geospatial.image.snapshot(for: geoJsonObject, with: drawingRenderModel, width: Double(mapImageView.bounds.width), height: Double(mapImageView.bounds.height), debug: false) { image in
                    guard let image = image else { return }
                    
                    mapImageView.image = image
                }
                
                //coordinator?.cancel()
            }
            
            guard let insetBoundingBox = geoJsonObject.objectBoundingBox?.mappingBoundingBox(insetPercent: 0.20) else { print("🗺️ GeospatialExample 🗺️ No Bounding Box"); return }
            
            mapView.setRegion(insetBoundingBox.region, animated: false)
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
