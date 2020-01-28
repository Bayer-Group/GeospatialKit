import GeospatialSwift

public protocol ImageGeneratorProtocol {
    func image(for geoJsonObject: GeoJsonObject, with drawingRenderModel: DrawingRenderModel, width: Double, height: Double, debug: Bool) -> UIImage?
    func snapshot(for geoJsonObject: GeoJsonObject, with drawingRenderModel: DrawingRenderModel, width: Double, height: Double, debug: Bool, completion: @escaping (UIImage?) -> Void) -> SnapshotRequest?
}

public protocol SnapshotRequest {
    func cancel()
}

extension MKMapSnapshotter: SnapshotRequest { }

internal struct SnapshotSettings {
    let snapshot: MKMapSnapshotter.Snapshot
    let scale: Double
}

internal class ImageGenerator: ImageGeneratorProtocol {
    func image(for geoJsonObject: GeoJsonObject, with drawingRenderModel: DrawingRenderModel, width: Double, height: Double, debug: Bool) -> UIImage? {
        return image(for: geoJsonObject, with: drawingRenderModel, width: width * Double(UIScreen.main.scale), height: height * Double(UIScreen.main.scale), snapshotSettings: nil, debug: debug)
    }
    
    func snapshot(for geoJsonObject: GeoJsonObject, with drawingRenderModel: DrawingRenderModel, width: Double, height: Double, debug: Bool, completion: @escaping (UIImage?) -> Void) -> SnapshotRequest? {
        guard let region = geoJsonObject.objectBoundingBox?.mappingBoundingBox(insetPercent: drawingRenderModel.inset).region else { completion(nil); return nil }
        
        #warning("Decide snapshot scale - the number will vary based on if latitude or longitude is chosen as the limiting factor based on view width and height.")
        //let shouldScale = max(region.span.longitudeDelta, region.span.latitudeDelta) < 0.002880360609112
        let snapshotScale = 1.0 //shouldScale ? max(region.span.longitudeDelta, region.span.latitudeDelta) * 805000 : 1
        let width = width * Double(UIScreen.main.scale) / snapshotScale
        let height = height * Double(UIScreen.main.scale) / snapshotScale
        
        let mapSnapshotOptions = MKMapSnapshotter.Options()
        mapSnapshotOptions.region = region
        mapSnapshotOptions.scale = UIScreen.main.scale
        mapSnapshotOptions.size = CGSize(width: width, height: height)
        mapSnapshotOptions.showsBuildings = false
        mapSnapshotOptions.showsPointsOfInterest = false
        mapSnapshotOptions.mapType = drawingRenderModel.mapType
        
        let snapshotter = MKMapSnapshotter(options: mapSnapshotOptions)
        snapshotter.start { snapshot, error in
            if let error = error { Log.error("Snapshot Error: \(error)", errorType: .internal); completion(nil); return }
            
            guard let snapshot = snapshot else { return }
            
            let snapshotSettings = SnapshotSettings(snapshot: snapshot, scale: snapshotScale)
            
            let finalImage = self.image(for: geoJsonObject, with: drawingRenderModel, width: width, height: height, snapshotSettings: snapshotSettings, debug: debug)
            
            completion(finalImage)
        }
        
        return snapshotter
    }
}

extension ImageGenerator {
    private func image(for geoJsonObject: GeoJsonObject, with drawingRenderModel: DrawingRenderModel, width: Double, height: Double, snapshotSettings: SnapshotSettings?, debug: Bool) -> UIImage? {
        let desiredImageRect = CGRect(x: 0, y: 0, width: width, height: height)
        
        let rendererFormat = UIGraphicsImageRendererFormat()
        rendererFormat.opaque = false
        rendererFormat.scale = 1.0
        
        let renderer = UIGraphicsImageRenderer(size: desiredImageRect.size, format: rendererFormat)
        return renderer.image { context in
            let drawing = GeometryProjector(context: context.cgContext, drawingRenderModel: drawingRenderModel, snapshotSettings: snapshotSettings, debug: debug)
            
            drawing.draw(geoJsonObject: geoJsonObject, width: width, height: height)
        }
    }
}
