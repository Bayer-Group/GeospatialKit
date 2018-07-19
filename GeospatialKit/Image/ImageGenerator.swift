public protocol ImageGeneratorProtocol {
    func image(for geoJsonObject: GeoJsonObject, with imageRenderModel: ImageRenderModel, debug: Bool) -> UIImage?
    func snapshot(for geoJsonObject: GeoJsonObject, with imageRenderModel: ImageRenderModel, debug: Bool, completion: @escaping (UIImage?) -> Void)
}

internal struct ImageGenerator: ImageGeneratorProtocol {
    func image(for geoJsonObject: GeoJsonObject, with imageRenderModel: ImageRenderModel, debug: Bool) -> UIImage? {
        return image(for: geoJsonObject, with: imageRenderModel, snapshot: nil, debug: debug)
    }
    
    func snapshot(for geoJsonObject: GeoJsonObject, with imageRenderModel: ImageRenderModel, debug: Bool, completion: @escaping (UIImage?) -> Void) {
        guard let region = geoJsonObject.objectBoundingBox?.mappingBoundingBox(insetPercent: imageRenderModel.inset).region else { completion(nil); return }
        
        let width = imageRenderModel.width * Double(UIScreen.main.scale)
        let height = imageRenderModel.height * Double(UIScreen.main.scale)
        
        let mapSnapshotOptions = MKMapSnapshotOptions()
        mapSnapshotOptions.region = region
        mapSnapshotOptions.scale = UIScreen.main.scale
        mapSnapshotOptions.size = CGSize(width: width, height: height)
        mapSnapshotOptions.showsBuildings = false
        mapSnapshotOptions.showsPointsOfInterest = false
        mapSnapshotOptions.mapType = imageRenderModel.mapType
        
        MKMapSnapshotter(options: mapSnapshotOptions).start { snapshot, error in
            if let error = error { Log.error("Snapshot Error: \(error)", errorType: .internal); completion(UIImage()); return }
            
            guard let snapshot = snapshot else { return }
            
            let finalImage = self.image(for: geoJsonObject, with: imageRenderModel, snapshot: snapshot, debug: debug)
            
            completion(finalImage)
        }
    }
}

extension ImageGenerator {
    private func image(for geoJsonObject: GeoJsonObject, with imageRenderModel: ImageRenderModel, snapshot: MKMapSnapshot?, debug: Bool) -> UIImage? {
        let width = imageRenderModel.width * Double(UIScreen.main.scale)
        let height = imageRenderModel.height * Double(UIScreen.main.scale)
        
        let desiredImageRect = CGRect(x: 0, y: 0, width: width, height: height)
        
        let rendererFormat = UIGraphicsImageRendererFormat()
        rendererFormat.opaque = false
        rendererFormat.scale = 1.0
        
        let renderer = UIGraphicsImageRenderer(size: desiredImageRect.size, format: rendererFormat)
        return renderer.image { context in
            if let snapshot = snapshot {
                snapshot.image.draw(in: desiredImageRect)
            } else {
                imageRenderModel.backgroundColor.setFill()
                context.fill(desiredImageRect)
            }
            
            guard let geometries = geoJsonObject.objectGeometries, let insetBoundingBox = geoJsonObject.objectBoundingBox?.mappingBoundingBox(insetPercent: imageRenderModel.inset) else {
                Log.info("No geometry objects or bounding box for: \(geoJsonObject.geoJson).")
                return
            }
            
            let pointProjector = PointProjector(boundingBox: insetBoundingBox, width: width, height: height)
            
            geometries.forEach {
                drawGeometry(imageRenderModel: imageRenderModel, pointProjector: pointProjector, geometry: $0, context: context.cgContext, snapshot: snapshot, debug: debug)
            }
        }
    }
    
    private func drawGeometry(imageRenderModel: ImageRenderModel, pointProjector: PointProjector, geometry: GeoJsonGeometry, context: CGContext, snapshot: MKMapSnapshot?, debug: Bool) {
        switch geometry {
        case let point as GeoJsonPoint:
            drawPin(imageRenderModel: imageRenderModel, pointProjector: pointProjector, context: context, snapshot: snapshot, point: point)
        case let multiPoint as GeoJsonMultiPoint:
            multiPoint.points.forEach { drawPin(imageRenderModel: imageRenderModel, pointProjector: pointProjector, context: context, snapshot: snapshot, point: $0) }
        case let lineString as GeoJsonLineString:
            drawLine(imageRenderModel: imageRenderModel, context: context, snapshot: snapshot, pointProjector: pointProjector, line: lineString, debug: debug)
        case let multiLineString as GeoJsonMultiLineString:
            multiLineString.lineStrings.forEach { drawLine(imageRenderModel: imageRenderModel, context: context, snapshot: snapshot, pointProjector: pointProjector, line: $0, debug: debug) }
        case let polygon as GeoJsonPolygon:
            drawPolygon(imageRenderModel: imageRenderModel, context: context, snapshot: snapshot, pointProjector: pointProjector, polygon: polygon, debug: debug)
            
            if debug { drawPin(imageRenderModel: imageRenderModel, pointProjector: pointProjector, context: context, snapshot: snapshot, point: polygon.centroid) }
        case let multiPolygon as GeoJsonMultiPolygon:
            multiPolygon.polygons.forEach { drawPolygon(imageRenderModel: imageRenderModel, context: context, snapshot: snapshot, pointProjector: pointProjector, polygon: $0, debug: debug) }
        case let geometryCollection as GeoJsonGeometryCollection:
            geometryCollection.objectGeometries?.forEach {
                drawGeometry(imageRenderModel: imageRenderModel, pointProjector: pointProjector, geometry: $0, context: context, snapshot: snapshot, debug: debug)
            }
        default: return
        }
    }
    
    private func drawPin(imageRenderModel: ImageRenderModel, pointProjector: PointProjector, context: CGContext, snapshot: MKMapSnapshot?, point: GeodesicPoint) {
        let pinView = MKPinAnnotationView(annotation: nil, reuseIdentifier: nil)
        if let pinTintColor = imageRenderModel.pinTintColor { pinView.pinTintColor = pinTintColor }
        let pinImage = pinView.image!
        
        let width = pinImage.size.width * UIScreen.main.scale
        let height = pinImage.size.height * UIScreen.main.scale
        
        var cgPoint: CGPoint
        if let snapshot = snapshot {
            cgPoint = snapshot.point(for: point.locationCoordinate)
        } else {
            cgPoint = pointProjector.asPoints([point]).first!
        }
        
        cgPoint.x -= width / 2
        cgPoint.y -= height / 2
        cgPoint.x += pinView.centerOffset.x * UIScreen.main.scale
        cgPoint.y += pinView.centerOffset.y * UIScreen.main.scale
        
        pinImage.draw(in: CGRect(origin: cgPoint, size: CGSize(width: width, height: height)))
    }
    
    private func drawLine(imageRenderModel: ImageRenderModel, context: CGContext, snapshot: MKMapSnapshot?, pointProjector: PointProjector, line: GeoJsonLineString, debug: Bool) {
        let points = line.points
        
        let cgPoints: [CGPoint]
        if let snapshot = snapshot {
            cgPoints = points.map { snapshot.point(for: $0.locationCoordinate) }
        } else {
            cgPoints = pointProjector.asPoints(points)
        }
        
        context.move(to: CGPoint(x: cgPoints[0].x, y: cgPoints[0].y))
        cgPoints.forEach { context.addLine(to: CGPoint(x: $0.x, y: $0.y)) }
        
        context.setLineWidth(CGFloat(imageRenderModel.lineWidth))
        
        context.setStrokeColor(imageRenderModel.shapeLineColor.cgColor)
        
        context.strokePath()
        
        if debug { points.forEach { drawPin(imageRenderModel: imageRenderModel, pointProjector: pointProjector, context: context, snapshot: snapshot, point: $0) } }
    }
    
    private func drawPolygon(imageRenderModel: ImageRenderModel, context: CGContext, snapshot: MKMapSnapshot?, pointProjector: PointProjector, polygon: GeoJsonPolygon, debug: Bool) {
        context.setLineWidth(CGFloat(imageRenderModel.lineWidth))
        context.setStrokeColor(imageRenderModel.shapeLineColor.cgColor)
        context.setFillColor(imageRenderModel.shapeFillColor.cgColor)
        
        context.beginPath()
        
        polygon.linearRings.reversed().forEach { linearRing in
            let points: [CGPoint]
            if let snapshot = snapshot {
                points = linearRing.points.map { snapshot.point(for: $0.locationCoordinate) }
            } else {
                points = pointProjector.asPoints(linearRing.points)
            }
            
            context.move(to: CGPoint(x: points[0].x, y: points[0].y))
            points.forEach { context.addLine(to: CGPoint(x: $0.x, y: $0.y)) }
        }
        
        context.closePath()
        
        context.drawPath(using: .eoFillStroke)
        
        if debug {
            drawPin(imageRenderModel: imageRenderModel, pointProjector: pointProjector, context: context, snapshot: snapshot, point: polygon.centroid)
            
            polygon.linearRings.forEach { $0.points.forEach { drawPin(imageRenderModel: imageRenderModel, pointProjector: pointProjector, context: context, snapshot: snapshot, point: $0) } }
        }
    }
}
