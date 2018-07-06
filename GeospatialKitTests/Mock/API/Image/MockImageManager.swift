@testable import GeospatialKit

final class MockImageManager: ImageManagerProtocol {
    private(set) var createCallCount = 0
    var createResult: UIImage?
    func create(for geoJsonObject: GeoJsonObject, with imageRenderModel: ImageRenderModel) -> UIImage? {
        createCallCount += 1
        
        return createResult
    }
    
    private(set) var createDebugCallCount = 0
    var createDebugResult: UIImage?
    func create(for geoJsonObject: GeoJsonObject, with imageRenderModel: ImageRenderModel, debug: Bool) -> UIImage? {
        createDebugCallCount += 1
        
        return createDebugResult
    }
}
