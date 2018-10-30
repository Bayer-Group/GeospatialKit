internal protocol OverlayGeneratorProtocol {
    func overlays(for geoJsonObject: GeoJsonObject, withProperties properties: [String: Any]) -> [GeospatialMapOverlay]
    func renderer(for overlay: MKOverlay, with overlayRenderModel: OverlayRenderModel) -> MKOverlayRenderer
}

internal struct OverlayGenerator: OverlayGeneratorProtocol {
    func overlays(for geoJsonObject: GeoJsonObject, withProperties properties: [String: Any]) -> [GeospatialMapOverlay] {
        guard let geometries = geoJsonObject.objectGeometries else { Log.info("No geometry objects for: \(geoJsonObject.geoJson)."); return [] }
        
        return geometries.flatMap { overlays(for: $0, withProperties: properties) }
    }
    
    func renderer(for overlay: MKOverlay, with overlayRenderModel: OverlayRenderModel) -> MKOverlayRenderer {
        if overlay is MKPolygon {
            let polygonRenderer = MKPolygonRenderer(overlay: overlay)
            
            polygonRenderer.lineWidth = overlayRenderModel.lineWidth
            polygonRenderer.strokeColor = overlayRenderModel.strokeColor
            polygonRenderer.fillColor = overlayRenderModel.fillColor
            polygonRenderer.alpha = overlayRenderModel.alpha
            
            return polygonRenderer
        } else if overlay is MKPolyline {
            let polylineRenderer = MKPolylineRenderer(overlay: overlay)
            
            polylineRenderer.lineWidth = overlayRenderModel.lineWidth
            polylineRenderer.strokeColor = overlayRenderModel.strokeColor
            polylineRenderer.fillColor = overlayRenderModel.fillColor
            polylineRenderer.alpha = overlayRenderModel.alpha
            
            return polylineRenderer
        }
        
        return MKOverlayRenderer()
    }
    
    private func overlays(for geometry: GeoJsonGeometry, withProperties properties: [String: Any]) -> [GeospatialMapOverlay] {
        switch geometry {
        case let lineString as GeoJsonLineString:
            return [overlay(for: lineString, withProperties: properties)]
        case let multiLineString as GeoJsonMultiLineString:
            #warning("Should this be the same overlay?")
            return multiLineString.lineStrings.flatMap { overlays(for: $0, withProperties: properties) }
        case let polygon as GeoJsonPolygon:
            return [overlay(for: polygon, withProperties: properties)]
        case let multiPolygon as GeoJsonMultiPolygon:
            #warning("Should this be the same overlay?")
            return multiPolygon.polygons.flatMap { overlays(for: $0, withProperties: properties) }
        case let geometryCollection as GeoJsonGeometryCollection:
            #warning("Should this be the same overlay?")
            return geometryCollection.objectGeometries?.flatMap { overlays(for: $0, withProperties: properties) } ?? []
        default: return []
        }
    }
    
    private func overlay(for lineString: GeoJsonLineString, withProperties properties: [String: Any]) -> GeospatialMapOverlay {
        let coordinates = lineString.points.map { $0.locationCoordinate }
        
        return GeospatialPolylineOverlay(coordinates: coordinates, count: coordinates.count, properties: properties)
    }
    
    private func overlay(for polygon: GeoJsonPolygon, withProperties properties: [String: Any]) -> GeospatialMapOverlay {
        let linearRingsCoordinates = polygon.linearRings.map { $0.points.map { $0.locationCoordinate } }
        
        let firstCoordinates = linearRingsCoordinates.first!
        
        let interiorPolygons = linearRingsCoordinates.tail?.map { MKPolygon(coordinates: $0, count: $0.count) }
        
        return GeospatialPolygonOverlay(coordinates: firstCoordinates, count: firstCoordinates.count, interiorPolygons: interiorPolygons, properties: properties)
    }
}
