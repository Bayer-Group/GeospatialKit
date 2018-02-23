/**
 A model representing options to use when rendering
 
 - lineWidth: The line width
 - strokeColor: The line color
 - fillColor: The fill color for polygons
 - alpha: The alpha for the fill color
 */
public struct OverlayRenderModel {
    internal let lineWidth: CGFloat
    internal let strokeColor: UIColor
    internal let fillColor: UIColor
    internal let alpha: CGFloat
    
    public init(lineWidth: CGFloat, strokeColor: UIColor, fillColor: UIColor, alpha: CGFloat) {
        self.lineWidth = lineWidth
        self.strokeColor = strokeColor
        self.fillColor = fillColor
        self.alpha = alpha
    }
}
