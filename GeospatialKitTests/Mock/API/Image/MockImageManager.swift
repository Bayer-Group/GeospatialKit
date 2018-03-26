@testable import GeospatialKit

final class MockImageManager: ImageManagerProtocol {
    private(set) var createCallCount = 0
    private(set) var createDebugCallCount = 0
    
    var createResult: UIImage?
    var createDebugResult: UIImage?
    
    func create(for geoJsonObject: GeoJsonObject, with imageRenderModel: ImageRenderModel) -> UIImage? {
        createCallCount += 1
        
        return createResult
    }
    
    func create(for geoJsonObject: GeoJsonObject, with imageRenderModel: ImageRenderModel, debug: Bool) -> UIImage? {
        createDebugCallCount += 1
        
        return createDebugResult
    }
}
