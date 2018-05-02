@testable import GeospatialKit

class GeoTestHelper {
    static let geospatial = Geospatial(configuration: ConfigurationModel(logLevel: .debug))
    
    static func parse(_ geoJsonDictionary: GeoJsonDictionary) -> GeoJsonObject {
        return geospatial.geoJson.parse(geoJson: geoJsonDictionary)!
    }
    
    static func simplePoint(_ longitude: Double, _ latitude: Double, _ altitude: Double? = nil) -> SimplePoint {
        return SimplePoint(longitude: longitude, latitude: latitude, altitude: altitude)
    }
    
    static func point(_ longitude: Double, _ latitude: Double, _ altitude: Double? = nil) -> GeoJsonPoint {
        return geospatial.geoJson.point(longitude: longitude, latitude: latitude, altitude: altitude)
    }
    
    static func multiPoint(_ points: [GeoJsonPoint]) -> GeoJsonMultiPoint {
        return geospatial.geoJson.multiPoint(points: points)!
    }
    
    static func lineString(_ points: [GeoJsonPoint]) -> GeoJsonLineString {
        return geospatial.geoJson.lineString(points: points)!
    }
    
    static func multiLineString(_ lineStrings: [GeoJsonLineString]) -> GeoJsonMultiLineString {
        return geospatial.geoJson.multiLineString(lineStrings: lineStrings)!
    }
    
    static func polygon(_ linearRings: [GeoJsonLineString]) -> GeoJsonPolygon {
        return geospatial.geoJson.polygon(linearRings: linearRings)!
    }
    
    static func multiPolygon(_ polygons: [GeoJsonPolygon]) -> GeoJsonMultiPolygon {
        return geospatial.geoJson.multiPolygon(polygons: polygons)!
    }
    
    static func geometryCollection(_ geometries: [GeoJsonGeometry]?) -> GeoJsonGeometryCollection {
        return geospatial.geoJson.geometryCollection(geometries: geometries)
    }
    
    static func feature(_ geometry: GeoJsonGeometry?, _ id: Any?, _ properties: GeoJsonDictionary?) -> GeoJsonFeature {
        return geospatial.geoJson.feature(geometry: geometry, id: id, properties: properties)!
    }
    
    static func featureCollection(_ features: [GeoJsonFeature]) -> GeoJsonFeatureCollection {
        return geospatial.geoJson.featureCollection(features: features)!
    }
}
