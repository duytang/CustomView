//
//  NotchView.swift
//  Blank
//
//  Created by Dii on 8/1/25.
//

import UIKit

final class NotchView: UIView {
    public var cornerRadius: CGFloat = 20 { didSet { setNeedsLayout() } }
    public var notchRadius: CGFloat = 20 { didSet { setNeedsLayout() } }
    public var notchWidthPercent: CGFloat = 0.8 { didSet { setNeedsLayout() } }
    public var color: UIColor = .clear { didSet { shapeLayer.fillColor = color.cgColor } }

    // This allows us to use the "base" layer as a shape layer instead of adding a sublayer
    lazy var shapeLayer: CAShapeLayer = self.layer as! CAShapeLayer
    override class var layerClass: AnyClass {
        return CAShapeLayer.self
    }

    // Image view for the image that will be displayed on top of the custom shape
    var imageView: UIImageView!

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    func commonInit() {
        // Initialize imageView with a sample image (or nil if you want to set it later)
        imageView = UIImageView(frame: CGRect.zero)
        imageView.contentMode = .scaleAspectFill // Adjust image scaling
        addSubview(imageView) // Add imageView as a subview of the NotchView
        
        shapeLayer.fillColor = UIColor.white.cgColor // Set initial fill color (for testing)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        
        // Set the shapeLayer's path to the custom shape (with the notch)
        var pth = CGMutablePath()
        let w: CGFloat = bounds.width * (1.0 - notchWidthPercent) * 0.5
        
        var pt1: CGPoint = .zero
        var pt2: CGPoint = .zero
        
        pth = CGMutablePath()
        
        // Define the path for the notch (same as your original code)
        pt1 = .init(x: bounds.minX, y: bounds.midY)
        pth.move(to: pt1)
        
        pt1 = .init(x: bounds.minX, y: bounds.minY)
        pt2 = .init(x: w, y: bounds.minY)
        pth.addArc(tangent1End: pt1, tangent2End: pt2, radius: cornerRadius)
        
        pt1 = pt2
        pt2.x += notchRadius
        pt2.y += notchRadius
        pth.addArc(tangent1End: pt1, tangent2End: pt2, radius: notchRadius)

        pt1 = pt2
        pt2.x = bounds.maxX - (w + notchRadius)
        pth.addArc(tangent1End: pt1, tangent2End: pt2, radius: notchRadius)

        pt1 = pt2
        pt2.x += notchRadius
        pt2.y -= notchRadius
        pth.addArc(tangent1End: pt1, tangent2End: pt2, radius: notchRadius)

        pt1 = pt2
        pt2.x = bounds.maxX
        pth.addArc(tangent1End: pt1, tangent2End: pt2, radius: notchRadius)

        pt1 = pt2
        pt2.y = bounds.maxY
        pth.addArc(tangent1End: pt1, tangent2End: pt2, radius: cornerRadius)

        pt1 = pt2
        pt2.x = bounds.minX
        pth.addArc(tangent1End: pt1, tangent2End: pt2, radius: cornerRadius)

        pt1 = pt2
        pt2.y = cornerRadius
        pth.addArc(tangent1End: pt1, tangent2End: pt2, radius: cornerRadius)

        pth.closeSubpath()
        
        shapeLayer.path = pth
        imageView.frame = bounds

        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        let maskLayer = CAShapeLayer()
        maskLayer.path = pth
        imageView.layer.mask = maskLayer
    }
    
    func setImage(with image: UIImage?) {
        imageView.image = image
    }
}
