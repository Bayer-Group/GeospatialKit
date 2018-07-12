/**
 A model representing options to use when generating an image
 
 - backgroundColor: The background color
 - shapeFillColor: The fill color for polygons
 - shapeLineColor: The line color
 - width: The width in points of the rendered image
 - height: The height in points of the rendered image
 - height: The height in points of the rendered image
 */
public struct ImageRenderModel {
    internal let backgroundColor: UIColor
    internal let shapeFillColor: UIColor
    internal let shapeLineColor: UIColor
    internal let pinTintColor: UIColor?
    internal let width: Double
    internal let height: Double
    internal let lineWidth: CGFloat
    internal let mapType: MKMapType
    
//    // Width and height should be set from the image view after the image view's layout have been finalized
    public init(backgroundColor: UIColor, shapeFillColor: UIColor, shapeLineColor: UIColor, pinTintColor: UIColor? = nil, width: Double, height: Double, lineWidth: CGFloat, mapType: MKMapType = MKMapType.satellite) {
        self.backgroundColor = backgroundColor
        self.shapeFillColor = shapeFillColor
        self.shapeLineColor = shapeLineColor
        self.pinTintColor = pinTintColor
        self.width = width
        self.height = height
        self.lineWidth = lineWidth
        self.mapType = mapType
    }
}
