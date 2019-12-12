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
        if #available(iOS 13.0, *), overlay is MKMultiPolygon {
            let renderer = MKMultiPolygonRenderer(overlay: overlay)
            
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
        case let lineString as GeoJsonLineString:
            return [overlay(for: lineString, withProperties: properties)]
        case let multiLineString as GeoJsonMultiLineString:
            #warning("Should this be the same overlay?")
            return multiLineString.lineStrings.flatMap { overlays(for: $0, withProperties: properties) }
        case let polygon as GeoJsonPolygon:
            return [overlay(for: polygon, withProperties: properties)]
        case let multiPolygon as GeoJsonMultiPolygon:
            #warning("Should this be the same overlay?")
            if #available(iOS 13.0, *) {
                return [overlay(for: multiPolygon, withProperties: properties)]
            } else {
                return multiPolygon.polygons.flatMap { overlays(for: $0, withProperties: properties) }
            }
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
    
    @available(iOS 13.0, *)
    private func overlay(for multiPolygon: GeoJsonMultiPolygon, withProperties properties: [String: Any]) -> GeospatialMapOverlay {
        // swiftlint:disable:next force_cast
        let polygons = multiPolygon.polygons.map { overlay(for: $0, withProperties: properties) as! GeospatialPolygonOverlay }
        
        return GeospatialMultiPolygonOverlay(polygons: polygons, properties: properties)
    }
}
