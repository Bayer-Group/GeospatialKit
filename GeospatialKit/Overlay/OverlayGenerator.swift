internal protocol OverlayGeneratorProtocol {
    func overlays(for geoJsonObject: GeoJsonObject) -> [MKOverlay]
    func renderer(for overlay: MKOverlay, with overlayRenderModel: OverlayRenderModel) -> MKOverlayRenderer
}

internal struct OverlayGenerator: OverlayGeneratorProtocol {
    func overlays(for geoJsonObject: GeoJsonObject) -> [MKOverlay] {
        guard let geometries = geoJsonObject.objectGeometries else { Log.info("No geometry objects for: \(geoJsonObject.geoJson)."); return [] }
        
        return geometries.flatMap { overlays(for: $0) }
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
    
    private func overlays(for geometry: GeoJsonGeometry) -> [MKOverlay] {
        switch geometry {
        case let lineString as GeoJsonLineString:
            return [overlay(for: lineString)]
        case let multiLineString as GeoJsonMultiLineString:
            return multiLineString.lineStrings.flatMap { overlays(for: $0) }
        case let polygon as GeoJsonPolygon:
            return [overlay(for: polygon)]
        case let multiPolygon as GeoJsonMultiPolygon:
            return multiPolygon.polygons.flatMap { overlays(for: $0) }
        case let geometryCollection as GeoJsonGeometryCollection:
            return geometryCollection.objectGeometries?.flatMap { overlays(for: $0) } ?? []
        default: return []
        }
    }
    
    private func overlay(for lineString: GeoJsonLineString) -> MKPolyline {
        let coordinates = lineString.points.map { $0.locationCoordinate }
        
        return MKPolyline(coordinates: coordinates, count: coordinates.count)
    }
    
    private func overlay(for polygon: GeoJsonPolygon) -> MKPolygon {
        let linearRingsCoordinates = polygon.linearRings.map { $0.points.map { $0.locationCoordinate } }
        
        let firstCoordinates = linearRingsCoordinates.first!
        
        let interiorPolygons = linearRingsCoordinates.tail?.map { MKPolygon(coordinates: $0, count: $0.count) }
        
        return MKPolygon(coordinates: firstCoordinates, count: firstCoordinates.count, interiorPolygons: interiorPolygons)
    }
}
