@testable import GeospatialKit

class MockGeoJsonBoundingBox: GeoJsonBoundingBox {
    private(set) var minLongitudeCallCount = 0
    private(set) var minLatitudeCallCount = 0
    private(set) var maxLongitudeCallCount = 0
    private(set) var maxLatitudeCallCount = 0
    private(set) var polygonCallCount = 0
    private(set) var pointsCallCount = 0
    private(set) var centroidCallCount = 0
    private(set) var regionCallCount = 0
    private(set) var imageBoundingBoxCallCount = 0
    private(set) var bestCallCount = 0
    private(set) var containsCallCount = 0
    private(set) var overlapsCallCount = 0
    private(set) var boundingCoordinatesCallCount = 0
    
    var minLongitudeResult: Double = 0
    var minLatitudeResult: Double = 0
    var maxLongitudeResult: Double = 0
    var maxLatitudeResult: Double = 0
    lazy var polygonResult: GeoJsonPolygon = MockGeoJsonPolygon()
    var pointsResult: [GeoJsonPoint] = []
    lazy var centroidResult: GeoJsonPoint = MockGeoJsonPoint()
    lazy var regionResult: MKCoordinateRegion = MKCoordinateRegion()
    lazy var imageBoundingBoxResult: GeoJsonBoundingBox = MockGeoJsonBoundingBox()
    lazy var bestResult: GeoJsonBoundingBox = MockGeoJsonBoundingBox()
    var containsResult: Bool = false
    var overlapsResult: Bool = false
    var boundingCoordinatesResult: BoundingCoordinates = (0, 0, 0, 0)

    var description: String = ""

    var minLongitude: Double {
        minLongitudeCallCount += 1
        
        return minLongitudeResult
    }
    
    var minLatitude: Double {
        minLatitudeCallCount += 1
        
        return minLatitudeResult
    }
    
    var maxLongitude: Double {
        maxLongitudeCallCount += 1
        
        return maxLongitudeResult
    }
    
    var maxLatitude: Double {
        maxLatitudeCallCount += 1
        
        return maxLatitudeResult
    }
    
    var polygon: GeoJsonPolygon {
        polygonCallCount += 1
        
        return polygonResult
    }
    
    var points: [GeodesicPoint] {
        pointsCallCount += 1
        
        return pointsResult
    }
    
    var centroid: GeodesicPoint {
        centroidCallCount += 1
        
        return centroidResult
    }
    
    var region: MKCoordinateRegion {
        regionCallCount += 1
        
        return regionResult
    }
    
    var imageBoundingBox: GeoJsonBoundingBox {
        imageBoundingBoxCallCount += 1
        
        return imageBoundingBoxResult
    }
    
    func best(_ boundingBoxes: [GeoJsonBoundingBox]) -> GeoJsonBoundingBox {
        bestCallCount += 1
        
        return bestResult
    }
    
    func contains(longitude: Double, latitude: Double) -> Bool {
        containsCallCount += 1
        
        return containsResult
    }
    
    func overlaps(boundingBox: GeoJsonBoundingBox) -> Bool {
        overlapsCallCount += 1
        
        return overlapsResult
    }
    
    var boundingCoordinates: BoundingCoordinates {
        boundingCoordinatesCallCount += 1
        
        return boundingCoordinatesResult
    }
}
