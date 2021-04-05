import MapKit
import GeospatialSwift

public class GeometryProjector {
    private let context: CGContext
    private let drawingRenderModel: DrawingRenderModel
    private let snapshotSettings: SnapshotSettings?
    private let debug: Bool
    
    init(context: CGContext, drawingRenderModel: DrawingRenderModel, snapshotSettings: SnapshotSettings? = nil, debug: Bool = false) {
        self.context = context
        self.drawingRenderModel = drawingRenderModel
        self.snapshotSettings = snapshotSettings
        self.debug = debug
    }
    
    #warning("Zoom and centerOffset?")
    public func draw(geoJsonObject: GeoJsonObject, width: Double, height: Double, zoom: Double = 1, centerOffset: CGPoint? = nil) {
        let desiredImageRect = CGRect(x: 0, y: 0, width: width, height: height)
        
        if let snapshotSettings = snapshotSettings {
            snapshotSettings.snapshot.image.draw(in: desiredImageRect)
        } else {
            drawingRenderModel.backgroundColor.setFill()
            context.fill(desiredImageRect)
        }
        
        guard let insetBoundingBox = geoJsonObject.objectBoundingBox?.mappingBoundingBox(insetPercent: drawingRenderModel.inset) else {
            Log.info("No bounding box for: \(geoJsonObject.geoJson).")
            return
        }
        
        let pointProjector = PointProjector(boundingBox: insetBoundingBox, width: width, height: height)
        
        geoJsonObject.objectGeometries.forEach {
            drawGeometry(pointProjector: pointProjector, geometry: $0)
        }
    }
    
    private func drawGeometry(pointProjector: PointProjector, geometry: GeoJsonGeometry) {
        switch geometry {
        case let point as GeoJson.Point:
            drawPin(pointProjector: pointProjector, point: point)
        case let multiPoint as GeoJson.MultiPoint:
            multiPoint.points.forEach { drawPin(pointProjector: pointProjector, point: $0) }
        case let lineString as GeoJson.LineString:
            drawLine(pointProjector: pointProjector, line: lineString)
        case let multiLineString as GeoJson.MultiLineString:
            multiLineString.lines.forEach { drawLine(pointProjector: pointProjector, line: $0) }
        case let polygon as GeoJson.Polygon:
            drawPolygon(pointProjector: pointProjector, polygon: polygon)
            
            if debug { drawPin(pointProjector: pointProjector, point: polygon.centroid) }
        case let multiPolygon as GeoJson.MultiPolygon:
            multiPolygon.polygons.forEach { drawPolygon(pointProjector: pointProjector, polygon: $0) }
        case let geometryCollection as GeoJson.GeometryCollection:
            geometryCollection.objectGeometries.forEach {
                drawGeometry(pointProjector: pointProjector, geometry: $0)
            }
        default: return
        }
    }
    
    private func drawPin(pointProjector: PointProjector, point: GeodesicPoint) {
        let pinView = MKPinAnnotationView(annotation: nil, reuseIdentifier: nil)
        if let pinTintColor = drawingRenderModel.pinTintColor { pinView.pinTintColor = pinTintColor }
        let pinImage = pinView.image!
        
        let width = pinImage.size.width * UIScreen.main.scale
        let height = pinImage.size.height * UIScreen.main.scale
        
        var cgPoint: CGPoint
        if let snapshotSettings = snapshotSettings {
            let scale = CGFloat(snapshotSettings.scale)
            let cgPointTemp = snapshotSettings.snapshot.point(for: point.locationCoordinate)
            cgPoint = CGPoint(x: cgPointTemp.x * scale, y: cgPointTemp.y * scale)
        } else {
            cgPoint = pointProjector.asPoints([point]).first!
        }
        
        cgPoint.x -= width / 2
        cgPoint.y -= height / 2
        cgPoint.x += pinView.centerOffset.x * UIScreen.main.scale
        cgPoint.y += pinView.centerOffset.y * UIScreen.main.scale
        
        pinImage.draw(in: CGRect(origin: cgPoint, size: CGSize(width: width, height: height)))
    }
    
    private func drawLine(pointProjector: PointProjector, line: GeodesicLine) {
        let points = line.points
        
        let cgPoints: [CGPoint]
        if let snapshotSettings = snapshotSettings {
            cgPoints = points.map {
                let scale = CGFloat(snapshotSettings.scale)
                let cgPointTemp = snapshotSettings.snapshot.point(for: $0.locationCoordinate)
                return CGPoint(x: cgPointTemp.x * scale, y: cgPointTemp.y * scale)
            }
        } else {
            cgPoints = pointProjector.asPoints(points)
        }
        
        context.move(to: CGPoint(x: cgPoints[0].x, y: cgPoints[0].y))
        cgPoints.forEach { context.addLine(to: CGPoint(x: $0.x, y: $0.y)) }
        
        context.setLineWidth(CGFloat(drawingRenderModel.lineWidth))
        
        context.setStrokeColor(drawingRenderModel.shapeLineColor.cgColor)
        
        context.strokePath()
        
        if debug { points.forEach { drawPin(pointProjector: pointProjector, point: $0) } }
    }
    
    private func drawPolygon(pointProjector: PointProjector, polygon: GeodesicPolygon) {
        context.setLineWidth(CGFloat(drawingRenderModel.lineWidth))
        context.setStrokeColor(drawingRenderModel.shapeLineColor.cgColor)
        context.setFillColor(drawingRenderModel.shapeFillColor.cgColor)
        
        context.beginPath()
        
        polygon.linearRings.reversed().forEach { linearRing in
            let points: [CGPoint]
            if let snapshotSettings = snapshotSettings {
                points = linearRing.points.map {
                    let scale = CGFloat(snapshotSettings.scale)
                    let cgPointTemp = snapshotSettings.snapshot.point(for: $0.locationCoordinate)
                    return CGPoint(x: cgPointTemp.x * scale, y: cgPointTemp.y * scale)
                }
            } else {
                points = pointProjector.asPoints(linearRing.points)
            }
            
            context.move(to: CGPoint(x: points[0].x, y: points[0].y))
            points.forEach { context.addLine(to: CGPoint(x: $0.x, y: $0.y)) }
        }
        
        context.closePath()
        
        context.drawPath(using: .eoFillStroke)
        
        if debug {
            drawPin(pointProjector: pointProjector, point: polygon.centroid)
            
            polygon.linearRings.forEach { $0.points.forEach { drawPin(pointProjector: pointProjector, point: $0) } }
        }
    }
}
