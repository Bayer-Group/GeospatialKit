/**
 A model representing options to use when generating an image
 
 - backgroundColor: The background color
 - shapeFillColor: The fill color for polygons
 - shapeLineColor: The line color
 - width: The width in points of the rendered image
 - height: The height in points of the rendered image
 - pixelsToPointsMultipler: The pixels per points ratio. Defaults to 3.0 to support all devices.
 */
public struct ImageRenderModel {
    internal let backgroundColor: CGColor
    internal let shapeFillColor: CGColor
    internal let shapeLineColor: CGColor
    internal let width: Double
    internal let height: Double
    
    // Should be device specific but 3 is the max per any current device.
    internal let pixelsToPointsMultipler: Double
    
    // Width and height should be set from the image view after the image view's layout have been finalized
    public init(backgroundColor: CGColor, shapeFillColor: CGColor, shapeLineColor: CGColor, width: Double, height: Double, pixelsToPointsMultipler: Double = 3.0) {
        self.backgroundColor = backgroundColor
        self.shapeFillColor = shapeFillColor
        self.shapeLineColor = shapeLineColor
        self.width = width
        self.height = height
        self.pixelsToPointsMultipler = pixelsToPointsMultipler
    }
}
