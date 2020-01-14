internal protocol OverlayGeneratorProtocol {
    func overlays(for geoJsonObject: GeoJsonObject, withProperties properties: [String: Any]) -> [GeospatialMapOverlay]
    @available(iOS 13.0, *)
    func groupedOverlays(for geoJsonObject: GeoJsonObject, withProperties properties: [String: Any]) -> [GeospatialMapOverlay]
    func renderer(for overlay: MKOverlay, with overlayRenderModel: OverlayRenderModel) -> MKOverlayRenderer
}

internal struct OverlayGenerator: OverlayGeneratorProtocol {
    func overlays(for geoJsonObject: GeoJsonObject, withProperties properties: [String: Any]) -> [GeospatialMapOverlay] {
        guard let geometries = geoJsonObject.objectGeometries else { Log.info("No geometry objects for: \(geoJsonObject.geoJson)."); return [] }
        
        return geometries.flatMap { overlays(for: $0, withProperties: properties) }
    }
    
    @available(iOS 13.0, *)
    func groupedOverlays(for geoJsonObject: GeoJsonObject, withProperties properties: [String: Any]) -> [GeospatialMapOverlay] {
        guard let geometries = geoJsonObject.objectGeometries else { Log.info("No geometry objects for: \(geoJsonObject.geoJson)."); return [] }
        
        func reduceGeometriesByType(geometries: [GeoJsonGeometry]) -> [GeoJsonObjectType: [GeoJsonGeometry]] {
            geometries.reduce(into: [GeoJsonObjectType: [GeoJsonGeometry]]()) { bucket, geometry in
                switch geometry {
                case let geometry as GeoJsonGeometryCollection:
                    reduceGeometriesByType(geometries: geometry.objectGeometries ?? []).forEach { type, geometries in
                        bucket[type] = bucket[type].flatMap { $0 + geometries } ?? geometries
                    }
                case let geometry as GeoJsonMultiPolygon:
                    reduceGeometriesByType(geometries: geometry.polygons).forEach { type, geometries in
                        bucket[type] = bucket[type].flatMap { $0 + geometries } ?? geometries
                    }
                case let geometry as GeoJsonMultiLineString:
                reduceGeometriesByType(geometries: geometry.lineStrings).forEach { type, geometries in
                    bucket[type] = bucket[type].flatMap { $0 + geometries } ?? geometries
                }
                default:
                    bucket[geometry.type] = bucket[geometry.type].flatMap { $0 + [geometry] } ?? [geometry]
                }
            }
        }
        
        let geometriesByType = reduceGeometriesByType(geometries: geometries)
        
        return geometriesByType.compactMap { type, geometries in
            switch type {
            case .lineString:
                // Convert to one large MultiLineString
                // swiftlint:disable:next force_cast
                return groupedOverlay(for: geometries as! [GeoJsonLineString], withProperties: properties)
            case .polygon:
                // Convert to one large MultiPolygon
                // swiftlint:disable:next force_cast
                return groupedOverlay(for: geometries as! [GeoJsonPolygon], withProperties: properties)
            case .point, .multiPoint, .multiLineString, .multiPolygon, .geometryCollection, .feature, .featureCollection: return nil
            }
        }
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
    
    @available(iOS 13.0, *)
    private func groupedOverlay(for lineStrings: [GeoJsonLineString], withProperties properties: [String: Any]) -> GeospatialMapOverlay {
        // swiftlint:disable:next force_cast
        let lineStrings = lineStrings.map { overlay(for: $0, withProperties: properties) as! GeospatialPolylineOverlay }
        
        return GeospatialMultiPolylineOverlay(lineStrings: lineStrings, properties: properties)
    }
    
    @available(iOS 13.0, *)
    private func groupedOverlay(for polygons: [GeoJsonPolygon], withProperties properties: [String: Any]) -> GeospatialMapOverlay {
        // swiftlint:disable:next force_cast
        let polygons = polygons.map { overlay(for: $0, withProperties: properties) as! GeospatialPolygonOverlay }
        
        return GeospatialMultiPolygonOverlay(polygons: polygons, properties: properties)
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
    private func overlay(for multiLineString: GeoJsonMultiLineString, withProperties properties: [String: Any]) -> GeospatialMapOverlay {
        // swiftlint:disable:next force_cast
        let lineStrings = multiLineString.lineStrings.map { overlay(for: $0, withProperties: properties) as! GeospatialPolylineOverlay }
        
        return GeospatialMultiPolylineOverlay(lineStrings: lineStrings, properties: properties)
    }
    
    @available(iOS 13.0, *)
    private func overlay(for multiPolygon: GeoJsonMultiPolygon, withProperties properties: [String: Any]) -> GeospatialMapOverlay {
        // swiftlint:disable:next force_cast
        let polygons = multiPolygon.polygons.map { overlay(for: $0, withProperties: properties) as! GeospatialPolygonOverlay }
        
        return GeospatialMultiPolygonOverlay(polygons: polygons, properties: properties)
    }
}
