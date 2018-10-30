import UIKit

extension UIImage {
    static func localImage(named name: String) -> UIImage {
        return UIImage(named: name, in: .source, compatibleWith: nil)!
    }
    
    func resize(newSize: CGSize) -> UIImage {
        let horizontalRatio = newSize.width / size.width
        let verticalRatio = newSize.height / size.height
        
        let ratio = max(horizontalRatio, verticalRatio)
        let newSize = CGSize(width: size.width * ratio, height: size.height * ratio)
        
        let renderFormat = UIGraphicsImageRendererFormat.default()
        renderFormat.opaque = false
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: newSize.width, height: newSize.height), format: renderFormat)
        
        return renderer.image { _ in
            draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        }
    }
    
    func crop( rect: CGRect) -> UIImage {
        let rect = CGRect(x: rect.origin.x * scale, y: rect.origin.y * scale, width: rect.size.width * scale, height: rect.size.height * scale)
        
        return UIImage(cgImage: cgImage!.cropping(to: rect)!, scale: scale, orientation: imageOrientation)
    }
}
