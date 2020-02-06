import GeospatialSwift

@testable import GeospatialKit

class GeoTestHelper {
    static let geospatial = Geospatial()
    
    static func parse(_ geoJsonDictionary: GeoJsonDictionary) -> GeoJsonObject {
        return geospatial.geoJson.parseObject(fromGeoJson: geoJsonDictionary).success!
    }
    
    static func simplePoint(_ longitude: Double, _ latitude: Double, _ altitude: Double? = nil) -> SimplePoint {
        return SimplePoint(longitude: longitude, latitude: latitude, altitude: altitude)
    }
    
    static func point(_ longitude: Double, _ latitude: Double, _ altitude: Double? = nil) -> GeoJson.Point {
        return geospatial.geoJson.point(longitude: longitude, latitude: latitude, altitude: altitude)
    }
    
    static func multiPoint(_ points: [GeoJson.Point]) -> GeoJson.MultiPoint {
        return geospatial.geoJson.multiPoint(points: points).success!
    }
    
    static func lineString(_ points: [GeoJson.Point]) -> GeoJson.LineString {
        return geospatial.geoJson.lineString(points: points).success!
    }
    
    static func multiLineString(_ lineStrings: [GeoJson.LineString]) -> GeoJson.MultiLineString {
        return geospatial.geoJson.multiLineString(lineStrings: lineStrings).success!
    }
    
    static func polygon(_ mainRing: GeoJson.LineString, _ negativeRings: [GeoJson.LineString]) -> GeoJson.Polygon {
        return geospatial.geoJson.polygon(mainRing: mainRing, negativeRings: negativeRings).success!
    }
    
    static func multiPolygon(_ polygons: [GeoJson.Polygon]) -> GeoJson.MultiPolygon {
        return geospatial.geoJson.multiPolygon(polygons: polygons).success!
    }
    
    static func geometryCollection(_ geometries: [GeoJsonGeometry]) -> GeoJson.GeometryCollection {
        return geospatial.geoJson.geometryCollection(geometries: geometries)
    }
    
    static func feature(_ geometry: GeoJsonGeometry?, _ id: Any?, _ properties: GeoJsonDictionary?) -> GeoJson.Feature {
        return geospatial.geoJson.feature(geometry: geometry, id: id, properties: properties).success!
    }
    
    static func featureCollection(_ features: [GeoJson.Feature]) -> GeoJson.FeatureCollection {
        return geospatial.geoJson.featureCollection(features: features).success!
    }
}
