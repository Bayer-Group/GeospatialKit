import UIKit
import GeospatialKit

class DrawingViewWrapper: UIView {
    @IBOutlet weak var drawingView: UIImageView!
    
    var geospatial: GeospatialCocoa!
    var geoJsonObject: GeoJsonObject!
    var drawingRenderModel: DrawingRenderModel!
    
    override func awakeFromNib() {
        addGestureRecognizer(UIPinchGestureRecognizer(target: self, action: #selector(didPinch(_:))))
        addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(didPan(_:))))
    }
    
    func refresh() {
        drawingView.image = geospatial.image.image(for: geoJsonObject, with: drawingRenderModel, width: Double(drawingView.bounds.width), height: Double(drawingView.bounds.height), debug: false)
    }
    
    // This code should just sets up a global scale and pan and limit the scale and pan
    // The redraw view step for just image can redraw the layer appropriately
    
    // TODO: Double click to zoom
    
    @objc private func didPinch(_ pinch: UIPinchGestureRecognizer) {
        guard pinch.state == .changed else { return }
        
        defer { pinch.scale = 1 }
        
        let imageScale = drawingView.frame.size.width / bounds.size.width
        
        // TODO: Only allow zoom to go to 10x or something. Perhaps this should be based on minimum latitudeDelta longitudeDelta on bounding box.
        let scale = pinch.scale < 1 ? max(pinch.scale, 1 / imageScale) : pinch.scale > 1 ? min(pinch.scale, 10 / imageScale) : 1
        
        let location = pinch.location(in: self)
        let scaleTransform = drawingView.transform.scaledBy(x: scale, y: scale)
        drawingView.transform = scaleTransform
        
        let dx = drawingView.frame.midX - location.x
        let dy = drawingView.frame.midY - location.y
        let x = (dx * scale) - dx
        let y = (dy * scale) - dy
        
        let translationTransform = CGAffineTransform(translationX: x, y: y)
        drawingView.transform = drawingView.transform.concatenating(translationTransform)
        
        var point = CGPoint()
        // Adjust so the imageview is not smaller on any side than the wrapper
        if bounds.maxX - drawingView.frame.maxX > 0 {
            point.x = bounds.maxX - drawingView.frame.maxX
        } else if bounds.minX - drawingView.frame.minX < 0 {
            point.x = bounds.minX - drawingView.frame.minX
        }
        
        if bounds.maxY - drawingView.frame.maxY > 0 {
            point.y = bounds.maxY - drawingView.frame.maxY
        } else if bounds.minY - drawingView.frame.minY < 0 {
            point.y = bounds.minY - drawingView.frame.minY
        }
        
        let transform = drawingView.transform.translatedBy(x: point.x, y: point.y)
        drawingView.transform = transform
    }
    
    @objc private func didPan(_ pan: UIPanGestureRecognizer) {
        guard pan.state == .changed else { return }
        
        defer { pan.setTranslation(.zero, in: self) }
        
        let imageScale = drawingView.frame.size.width / bounds.size.width
        let translation = pan.translation(in: self)
        
        let point = adjustTransform(point: CGPoint(x: translation.x / imageScale, y: translation.y / imageScale))
        
        // TODO: Occasionally there is a graphical artifact when panning while zoomed. Perhaps from the adjustTransform.
        let transform = drawingView.transform.translatedBy(x: point.x, y: point.y)
        drawingView.transform = transform
    }
    
    // Adjusts the transform to not fall outside the bounds of the imageViewWrapper
    private func adjustTransform(point: CGPoint) -> CGPoint {
        //        print("x: \(point.x) \(bounds.minX) \(imageView.frame.minX) \(bounds.maxX) \(imageView.frame.maxX)")
        //        print("y: \(point.y) \(bounds.minY) \(imageView.frame.minY) \(bounds.maxY) \(imageView.frame.maxY)")
        
        var point = point
        
        if point.x < 0 {
            point.x = max(point.x, bounds.maxX - drawingView.frame.maxX)
        } else if point.x > 0 {
            point.x = min(point.x, bounds.minX - drawingView.frame.minX)
        }
        
        if point.y < 0 {
            point.y = max(point.y, bounds.maxY - drawingView.frame.maxY)
        } else if point.y > 0 {
            point.y = min(point.y, bounds.minY - drawingView.frame.minY)
        }
        
        return point
    }
}
