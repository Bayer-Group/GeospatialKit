import MapKit

/**
 A model representing options to use when generating an image
 
 - backgroundColor: The background color
 - shapeFillColor: The fill color for polygons
 - shapeLineColor: The line color
 - width: The width in points of the rendered image
 - height: The height in points of the rendered image
 - height: The height in points of the rendered image
 */
public struct DrawingRenderModel {
    internal let backgroundColor: UIColor
    internal let shapeFillColor: UIColor
    internal let shapeLineColor: UIColor
    internal let pinTintColor: UIColor?
    internal let lineWidth: Double
    internal let inset: Double
    internal let mapType: MKMapType
    
    // Width and height should be set from the image view after the image view's layout have been finalized
    public init(backgroundColor: UIColor, shapeFillColor: UIColor, shapeLineColor: UIColor, pinTintColor: UIColor? = nil, lineWidth: Double, inset: Double, mapType: MKMapType = MKMapType.satellite) {
        self.backgroundColor = backgroundColor
        self.shapeFillColor = shapeFillColor
        self.shapeLineColor = shapeLineColor
        self.pinTintColor = pinTintColor
        self.lineWidth = lineWidth
        self.inset = inset
        self.mapType = mapType
    }
}
