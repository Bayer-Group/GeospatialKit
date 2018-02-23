@testable import GeospatialKit

class MockGeoJsonMultiPolygon: MockGeoJsonMultiCoordinatesGeometry, GeoJsonMultiPolygon {
    private(set) var polygonsCallCount = 0
    
    var polygonsResult: [GeoJsonPolygon] = []
    
    var polygons: [GeoJsonPolygon] {
        polygonsCallCount += 1
        
        return polygonsResult
    }
}
