public protocol ImageGeneratorProtocol {
    func create(for geoJsonObject: GeoJsonObject, with imageRenderModel: ImageRenderModel, debug: Bool) -> UIImage?
}

internal struct ImageGenerator: ImageGeneratorProtocol {
    let calculator: GeodesicCalculatorProtocol
    
    static let debugAlpha: CGFloat = 0.2
    
    func create(for geoJsonObject: GeoJsonObject, with imageRenderModel: ImageRenderModel, debug: Bool) -> UIImage? {
        let width = imageRenderModel.width * imageRenderModel.pixelsToPointsMultipler
        let height = imageRenderModel.height * imageRenderModel.pixelsToPointsMultipler
        
        let desiredImageRect = CGRect(x: 0, y: 0, width: width, height: height)
        
        UIGraphicsBeginImageContextWithOptions(desiredImageRect.size, false, 1.0)
        guard let context = UIGraphicsGetCurrentContext() else { Log.error("No Graphics Context", errorType: .internal); return nil }
        
        context.setFillColor(imageRenderModel.backgroundColor)
        context.fill(desiredImageRect)
        
        // TODO: Is this the right place to do this?
        guard let geometries = geoJsonObject.objectGeometries, let imageBoundingBox = geoJsonObject.objectBoundingBox?.imageBoundingBox else {
            Log.info("No geometry objects or bounding box for: \(geoJsonObject.geoJson).")
            let image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
            return image
        }
        
        let pointProjector = PointProjector(boundingBox: imageBoundingBox, width: width, height: height)
        
        geometries.forEach {
            drawGeometry(imageRenderModel: imageRenderModel, pointProjector: pointProjector, geometry: $0, context: context, debug: debug)
        }
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image
    }
}

extension ImageGenerator {
    // swiftlint:disable:next cyclomatic_complexity
    fileprivate func drawGeometry(imageRenderModel: ImageRenderModel, pointProjector: PointProjector, geometry: GeoJsonGeometry, context: CGContext, debug: Bool) {
        switch geometry {
        case let point as GeoJsonPoint:
            drawPin(pointProjector: pointProjector, point: point)
        case let multiPoint as GeoJsonMultiPoint:
            multiPoint.points.forEach { drawPin(pointProjector: pointProjector, point: $0) }
            
            if debug { drawPin(pointProjector: pointProjector, point: multiPoint.centroid) }
        case let lineString as GeoJsonLineString:
            drawLine(imageRenderModel: imageRenderModel, context: context, pointProjector: pointProjector, line: lineString, debug: debug)
        case let multiLineString as GeoJsonMultiLineString:
            multiLineString.lineStrings.forEach { drawLine(imageRenderModel: imageRenderModel, context: context, pointProjector: pointProjector, line: $0, debug: debug) }
            
            if debug { drawPin(pointProjector: pointProjector, point: multiLineString.centroid) }
        case let polygon as GeoJsonPolygon:
            drawPolygon(imageRenderModel: imageRenderModel, context: context, pointProjector: pointProjector, polygon: polygon, debug: debug)
            
            if debug {
                if polygon.linearRings.count > 1 {
                    polygon.linearRings.forEach { drawPin(pointProjector: pointProjector, point: calculator.centroid(linearRingSegments: $0.segments)) }
                }
                
                drawPin(pointProjector: pointProjector, point: polygon.centroid)
            }
        case let multiPolygon as GeoJsonMultiPolygon:
            multiPolygon.polygons.forEach { drawPolygon(imageRenderModel: imageRenderModel, context: context, pointProjector: pointProjector, polygon: $0, debug: debug) }
            
            if debug { drawPin(pointProjector: pointProjector, point: multiPolygon.centroid) }
        case let geometryCollection as GeoJsonGeometryCollection:
            geometryCollection.objectGeometries?.forEach {
                drawGeometry(imageRenderModel: imageRenderModel, pointProjector: pointProjector, geometry: $0, context: context, debug: debug)
            }
        default: return
        }
    }
    
    // TODO: Draw the pin to better proportions?
    private func drawPin(pointProjector: PointProjector, point: GeodesicPoint) {
        let pinImage = UIImage.localImage(named: "UIMapPinActive")
        
        var point: CGPoint = pointProjector.asPoints([point]).first!
        point.x -= pinImage.size.width / 2
        // TODO: Remove "/ 2" if the pin bottom should be the exact location.
        point.y -= pinImage.size.height // / 2
        
        let rect = CGRect(origin: point, size: pinImage.size)
        pinImage.draw(in: rect)
    }
    
    private func drawLine(imageRenderModel: ImageRenderModel, context: CGContext, pointProjector: PointProjector, line: GeoJsonLineString, debug: Bool) {
        let points = line.points
        
        if debug {
            points.forEach { drawPin(pointProjector: pointProjector, point: $0) }
            drawPin(pointProjector: pointProjector, point: line.centroid)
        }
        
        let cgPoints: [CGPoint] = pointProjector.asPoints(points)
        
        context.move(to: CGPoint(x: cgPoints[0].x, y: cgPoints[0].y))
        cgPoints.forEach { context.addLine(to: CGPoint(x: $0.x, y: $0.y)) }
        
        context.setLineWidth(3.0)
        
        context.setStrokeColor(debug ? imageRenderModel.shapeLineColor.copy(alpha: ImageGenerator.debugAlpha)! : imageRenderModel.shapeLineColor)
        
        context.strokePath()
    }
    
    private func drawPolygon(imageRenderModel: ImageRenderModel, context: CGContext, pointProjector: PointProjector, polygon: GeoJsonPolygon, debug: Bool) {
        let lines = polygon.linearRings
        
        if debug { drawPin(pointProjector: pointProjector, point: polygon.centroid) }
        
        for (index, line) in lines.enumerated() {
            if debug {
                line.points.forEach { drawPin(pointProjector: pointProjector, point: $0) }
                drawPin(pointProjector: pointProjector, point: line.centroid)
            }
            
            let points: [CGPoint] = pointProjector.asPoints(line.points)
            
            context.beginPath()
            context.move(to: CGPoint(x: points[0].x, y: points[0].y))
            points.forEach { context.addLine(to: CGPoint(x: $0.x, y: $0.y)) }
            // Note: Closing path is not needed if first and end points are the same. This should be the case in the parsers.
            context.closePath()
            
            context.setLineWidth(3.0)
            context.setStrokeColor(debug ? imageRenderModel.shapeLineColor.copy(alpha: ImageGenerator.debugAlpha)! : imageRenderModel.shapeLineColor)
            
            context.setFillColor(index == 0 ? (debug ? imageRenderModel.shapeFillColor.copy(alpha: ImageGenerator.debugAlpha)! : imageRenderModel.shapeFillColor) : (debug ? imageRenderModel.backgroundColor.copy(alpha: ImageGenerator.debugAlpha)! : imageRenderModel.backgroundColor))
            
            context.drawPath(using: .fillStroke)
        }
    }
}
