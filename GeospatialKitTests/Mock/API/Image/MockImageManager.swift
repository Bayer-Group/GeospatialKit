@testable import GeospatialKit

final class MockImageManager: ImageManagerProtocol {
    private(set) var imageCallCount = 0
    var imageResult: UIImage?
    func image(for geoJsonObject: GeoJsonObject, with drawingRenderModel: DrawingRenderModel, width: Double, height: Double, debug: Bool) -> UIImage? {
        imageCallCount += 1
        
        return imageResult
    }
    
    private(set) var snapshotCallCount = 0
    var snapshotResult: UIImage?
    func snapshot(for geoJsonObject: GeoJsonObject, with drawingRenderModel: DrawingRenderModel, width: Double, height: Double, debug: Bool, completion: @escaping (UIImage?) -> Void) {
        snapshotCallCount += 1
        
        completion(snapshotResult)
    }
}
