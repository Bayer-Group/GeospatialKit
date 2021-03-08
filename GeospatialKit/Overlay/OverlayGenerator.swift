import MapKit
import GeospatialSwift

internal struct OverlayGenerator {
    func overlays(for geoJsonObject: GeoJsonObject, withProperties properties: [String: Any]) -> [GeospatialMapOverlay] {
        return geoJsonObject.objectGeometries.flatMap { overlays(for: $0, withProperties: properties) }
    }
    
    @available(iOS 13.0, *)
    func groupedOverlays(for geoJsonObjects: [GeoJsonObject], withProperties properties: [String: Any]) -> [GeospatialMapOverlay] {
        let geometries = geoJsonObjects.compactMap({ $0.coordinatesGeometries }).flatMap { $0 }
        
        return groupedOverlays(for: geometries, withProperties: properties)
    }
    
    @available(iOS 13.0, *)
    func groupedOverlays(for geoJsonCoordinatesGeometries: [GeoJsonCoordinatesGeometry], withProperties properties: [String: Any]) -> [GeospatialMapOverlay] {
        guard geoJsonCoordinatesGeometries.count > 0 else { Log.info("No geometry objects."); return [] }
        
        var lines = [GeodesicLine]()
        var polygons = [GeodesicPolygon]()
        geoJsonCoordinatesGeometries.forEach { geometry in
            switch geometry {
            case let geometry as GeoJson.MultiPolygon:
                polygons.append(contentsOf: geometry.polygons)
            case let geometry as GeoJson.MultiLineString:
                lines.append(contentsOf: geometry.lines)
            case let geometry as GeodesicPolygon:
                polygons.append(geometry)
            case let geometry as GeodesicLine:
                lines.append(geometry)
            default:
                ()
            }
        }
        
        return (groupedOverlay(for: lines, withProperties: properties).flatMap { [$0] } ?? []) + (groupedOverlay(for: polygons, withProperties: properties).flatMap { [$0] } ?? [])
    }
    
    func renderer(for overlay: MKOverlay, with overlayRenderModel: OverlayRenderModel) -> MKOverlayRenderer {
        if #available(iOS 13.0, *), overlay is MKMultiPolygon {
            let renderer = MKMultiPolygonRenderer(overlay: overlay)
            
            renderer.lineWidth = overlayRenderModel.lineWidth
            renderer.strokeColor = overlayRenderModel.strokeColor
            renderer.fillColor = overlayRenderModel.fillColor
            renderer.alpha = overlayRenderModel.alpha
            
            return renderer
        }
        
        if #available(iOS 13.0, *), overlay is MKMultiPolyline {
            let renderer = MKMultiPolylineRenderer(overlay: overlay)
            
            renderer.lineWidth = overlayRenderModel.lineWidth
            renderer.strokeColor = overlayRenderModel.strokeColor
            renderer.fillColor = overlayRenderModel.fillColor
            renderer.alpha = overlayRenderModel.alpha
            
            return renderer
        }
        
        if overlay is MKPolygon {
            let renderer = MKPolygonRenderer(overlay: overlay)
            
            renderer.lineWidth = overlayRenderModel.lineWidth
            renderer.strokeColor = overlayRenderModel.strokeColor
            renderer.fillColor = overlayRenderModel.fillColor
            renderer.alpha = overlayRenderModel.alpha
            
            return renderer
        }
        
        if overlay is MKPolyline {
            let renderer = MKPolylineRenderer(overlay: overlay)
            
            renderer.lineWidth = overlayRenderModel.lineWidth
            renderer.strokeColor = overlayRenderModel.strokeColor
            renderer.fillColor = overlayRenderModel.fillColor
            renderer.alpha = overlayRenderModel.alpha
            
            return renderer
        }
        
        return MKOverlayRenderer()
    }
    
    private func overlays(for geometry: GeoJsonGeometry, withProperties properties: [String: Any]) -> [GeospatialMapOverlay] {
        switch geometry {
        case let lineString as GeodesicLine:
            return [overlay(for: lineString, withProperties: properties)]
        case let multiLineString as GeoJson.MultiLineString:
            #warning("Should this be the same overlay?")
            if #available(iOS 13.0, *) {
                return [overlay(for: multiLineString, withProperties: properties)]
            } else {
                return multiLineString.lines.map { overlay(for: $0, withProperties: properties) }
            }
        case let polygon as GeodesicPolygon:
            return [overlay(for: polygon, withProperties: properties)]
        case let multiPolygon as GeoJson.MultiPolygon:
            #warning("Should this be the same overlay?")
            if #available(iOS 13.0, *) {
                return [overlay(for: multiPolygon, withProperties: properties)]
            } else {
                return multiPolygon.polygons.map { overlay(for: $0, withProperties: properties) }
            }
        case let geometryCollection as GeoJson.GeometryCollection:
            #warning("Should this be the same overlay?")
            return geometryCollection.objectGeometries.flatMap { overlays(for: $0, withProperties: properties) }
        default: return []
        }
    }
    
    @available(iOS 13.0, *)
    private func groupedOverlay(for lines: [GeodesicLine], withProperties properties: [String: Any]) -> GeospatialMapOverlay? {
        guard lines.count > 0 else { return nil }
        
        // swiftlint:disable:next force_cast
        let lines = lines.map { overlay(for: $0, withProperties: properties) as! GeospatialPolylineOverlay }
        
        return GeospatialMultiPolylineOverlay(lines: lines, properties: properties)
    }
    
    @available(iOS 13.0, *)
    private func groupedOverlay(for polygons: [GeodesicPolygon], withProperties properties: [String: Any]) -> GeospatialMapOverlay? {
        guard polygons.count > 0 else { return nil }
        
        // swiftlint:disable:next force_cast
        let polygons = polygons.map { overlay(for: $0, withProperties: properties) as! GeospatialPolygonOverlay }
        
        return GeospatialMultiPolygonOverlay(polygons: polygons, properties: properties)
    }
    
    private func overlay(for line: GeodesicLine, withProperties properties: [String: Any]) -> GeospatialMapOverlay {
        let coordinates = line.points.map { $0.locationCoordinate }
        
        return GeospatialPolylineOverlay(coordinates: coordinates, count: coordinates.count, properties: properties)
    }
    
    private func overlay(for polygon: GeodesicPolygon, withProperties properties: [String: Any]) -> GeospatialMapOverlay {
        let linearRingsCoordinates = polygon.linearRings.map { $0.points.map { $0.locationCoordinate } }
        
        let firstCoordinates = linearRingsCoordinates.first!
        
        let interiorPolygons = linearRingsCoordinates.tail?.map { MKPolygon(coordinates: $0, count: $0.count) }
        
        return GeospatialPolygonOverlay(coordinates: firstCoordinates, count: firstCoordinates.count, interiorPolygons: interiorPolygons, properties: properties)
    }
    
    @available(iOS 13.0, *)
    private func overlay(for multiLineString: GeoJson.MultiLineString, withProperties properties: [String: Any]) -> GeospatialMapOverlay {
        // swiftlint:disable:next force_cast
        let lines = multiLineString.lines.map { overlay(for: $0, withProperties: properties) as! GeospatialPolylineOverlay }
        
        return GeospatialMultiPolylineOverlay(lines: lines, properties: properties)
    }
    
    @available(iOS 13.0, *)
    private func overlay(for multiPolygon: GeoJson.MultiPolygon, withProperties properties: [String: Any]) -> GeospatialMapOverlay {
        // swiftlint:disable:next force_cast
        let polygons = multiPolygon.polygons.map { overlay(for: $0, withProperties: properties) as! GeospatialPolygonOverlay }
        
        return GeospatialMultiPolygonOverlay(polygons: polygons, properties: properties)
    }
}
