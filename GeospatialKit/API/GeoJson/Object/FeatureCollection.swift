internal typealias FeatureCollection = GeoJson.FeatureCollection

public protocol GeoJsonFeatureCollection: GeoJsonObject {
    var features: [GeoJsonFeature] { get }
}

extension GeoJson {
    /**
     Creates a GeoJsonFeatureCollection
     */
    public func featureCollection(features: [GeoJsonFeature]) -> GeoJsonFeatureCollection? {
        return FeatureCollection(logger: logger, features: features)
    }
    
    public class FeatureCollection: GeoJsonFeatureCollection, Equatable {
        public let type: GeoJsonObjectType = .featureCollection
        public var geoJson: GeoJsonDictionary { return ["type": type.rawValue, "features": features.map { $0.geoJson } ] }
        
        public var description: String {
            return """
            FeatureCollection: \(
            """
            (\n\(features.enumerated().map { "Line \($0) - \($1)" }.joined(separator: ",\n"))
            """
            .replacingOccurrences(of: "\n", with: "\n\t")
            )\n)
            """
        }
        
        private let logger: LoggerProtocol
        
        public let features: [GeoJsonFeature]
        
        public let objectGeometries: [GeoJsonGeometry]?
        public let objectBoundingBox: GeoJsonBoundingBox?
        
        internal convenience init?(logger: LoggerProtocol, geoJsonParser: GeoJsonParserProtocol, geoJsonDictionary: GeoJsonDictionary) {
            guard let featuresJson = geoJsonDictionary["features"] as? [GeoJsonDictionary] else { logger.error("A valid FeatureCollection must have a \"features\" key: String : \(geoJsonDictionary)"); return nil }
            
            var features = [GeoJsonFeature]()
            for featureJson in featuresJson {
                if let feature = Feature(logger: logger, geoJsonParser: geoJsonParser, geoJsonDictionary: featureJson) {
                    features.append(feature)
                } else {
                    logger.error("Invalid Feature in FeatureCollection")
                    return nil
                }
            }
            
            self.init(logger: logger, features: features)
        }
        
        fileprivate init?(logger: LoggerProtocol, features: [GeoJsonFeature]) {
            guard features.count >= 1 else { logger.error("A valid FeatureCollection must have at least one feature."); return nil }
            
            self.logger = logger
            
            self.features = features
            
            let geometries = features.flatMap { $0.objectGeometries }.flatMap { $0 }
            
            self.objectGeometries = geometries.count > 0 ? geometries : nil
            
            objectBoundingBox = BoundingBox.best(geometries.flatMap { $0.objectBoundingBox })
        }
        
        public func objectDistance(to point: GeodesicPoint, errorDistance: Double) -> Double? { return features.flatMap { $0.objectDistance(to: point, errorDistance: errorDistance) }.min() }
        
        public func contains(_ point: GeodesicPoint, errorDistance: Double) -> Bool { return features.first { $0.contains(point, errorDistance: errorDistance) } != nil }
        
        public static func == (lhs: FeatureCollection, rhs: FeatureCollection) -> Bool { return lhs as GeoJsonObject == rhs as GeoJsonObject }
    }
}
