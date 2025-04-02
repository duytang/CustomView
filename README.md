# CustomView & Extension
Collect some custom views and extensions on iOS
## NotchView
- Create a view that has the notch (like the iPhone notch) with an image inside the view 
- How to use: Drag a xib view and set class for this view is NotchView

 ![noteview](https://github.com/user-attachments/assets/027f4ed1-c678-4a70-a831-fce2ac17ee7d)

<details>
  <summary>TicketView </summary>
  
- Create a view that like a ticket
- How to use:
```
  let ticketView = TicketView()
  /// radius: the size of the outside circle
  /// circleWidth: the size of the inside circle
  /// numberOfCicle: the number of circles wanna display
  /// bottomY: the space from bottom to the hold
  
  ticketView.updateView(radius: 36, circleWidth: 20, numberOfCicle: 9, bottomY: 104)
  contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
  containerView.insertSubview(ticketView, at: 0)
```
![ticketview](https://github.com/user-attachments/assets/6f3c0856-98f8-4316-87f8-96e8e3228777)
</details>

<details>
  <summary>Gradients</summary>

### Define and extension
```
  enum GradientType: Int {
    case topToBottom
    case bottomToTop
    case topLeftToBottomRight
    case bottomLeftToTopRight
    case leftToRight
    case rightToRight
    
    var start: CGPoint {
        switch self {
        case .topToBottom: return CGPoint(x: 0.5, y: 0)
        case .bottomToTop: return CGPoint(x: 0.5, y: 1)
        case .topLeftToBottomRight: return CGPoint(x: 0, y: 0.5)
        case .bottomLeftToTopRight: return CGPoint(x: 0, y: 1)
        case .leftToRight: return CGPoint(x: 0, y: 0.5)
        case .rightToRight: return CGPoint(x: 1.0, y: 0.5)
        }
    }
    
    var end: CGPoint {
        switch self {
        case .topToBottom: return CGPoint(x: 0.5, y: 1)
        case .bottomToTop: return CGPoint(x: 0.5, y: 0)
        case .topLeftToBottomRight: return CGPoint(x: 0.5, y: 1)
        case .bottomLeftToTopRight: return CGPoint(x: 1, y: 0)
        case .leftToRight: return CGPoint(x: 1.0, y: 0.5)
        case .rightToRight: return CGPoint(x: 0.0, y: 0.5)
        }
    }
}

/// Create a gradient image 
extension UIImage {
    static func gImage(frame: CGRect, type: GradientType = .topToBottom, colors: [UIColor]) -> UIImage {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = frame
        gradientLayer.colors = colors.map(\.cgColor)
        gradientLayer.startPoint = type.start
        gradientLayer.endPoint = type.end
        
        let render = UIGraphicsImageRenderer(bounds: frame)
        
        return render.image { context in
            gradientLayer.render(in: context.cgContext)
        }
    }
}

/// Add the gradient background
extension UIView {
    func addGradientLayer(colors: [UIColor], size: CGSize, type: GradientType) {
        let colors = colors.map { $0.cgColor }
        let gradientLayer = CAGradientLayer()
        gradientLayer.name = "GradientBackground"
        gradientLayer.startPoint = type.start
        gradientLayer.endPoint = type.end
        gradientLayer.frame = CGRect(origin: .zero, size: size)
        gradientLayer.colors = colors
        layer.insertSublayer(gradientLayer, at: 0)
    }
}
```
### Set title color gradient
```
let gradient = UIImage.gImage(frame: CGRect(x: 0, y: 0, width: 100, height: 20),
                              type: .leftToRight,
                              colors: [UIColor(hex: 0x0052CC), UIColor(hex: 0x1A95E8)])
button.setTitleColor(UIColor(patternImage: gradient), for: .normal)
```
![button_title_gradient](https://github.com/user-attachments/assets/ba5e78eb-dfd6-4633-aa97-f916e3d4429d)


### Add background gradient
```
button.addGradientLayer(colors: [UIColor(hex: 0x0052CC), UIColor(hex: 0x1A95E8)], size: .frame.size, type: .leftToRight)
```
![gradient_button](https://github.com/user-attachments/assets/ee1b0e67-95a8-4321-9cf1-978ac323398b)

### Add shadow view 
```
func setShadowCorner(with corners : CGFloat, fillColor: UIColor = .white, shadowColor: UIColor = UIColor.black.withAlphaComponent(0.1), offset: CGSize = CGSize(width: 1, height: 2), opacity: Float = 1, shadowRadius: CGFloat = 8) {
    if let index = layer.sublayers?.firstIndex(where: { $0.name == "ShadowRadiusLayerName" }) {
      layer.sublayers?.remove(at: index)
    }
      
    let shadowLayer = CAShapeLayer()
    shadowLayer.name = "ShadowRadiusLayerName"
      
    shadowLayer.path = UIBezierPath(roundedRect: bounds, cornerRadius: corners).cgPath
    shadowLayer.fillColor = fillColor.cgColor
      
    shadowLayer.shadowColor = shadowColor.cgColor
    shadowLayer.shadowPath = shadowLayer.path
    shadowLayer.shadowOffset = offset
    shadowLayer.shadowOpacity = opacity
    shadowLayer.shadowRadius = shadowRadius
    shadowLayer.shouldRasterize = true
    shadowLayer.rasterizationScale = UIScreen.main.scale
      
    layer.insertSublayer(shadowLayer, at: 0)
}
```
</details>

## Wave tabbar
![wave_tabbar](https://github.com/user-attachments/assets/d1c426d1-61fb-47c8-864f-f929b36d7fa9)
