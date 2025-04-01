//
//  Gradient.swift
//  collectiondemo
//
//  Created by Proton on 1/4/25.
//

import UIKit

extension CGPoint {
    func distance(to point: CGPoint) -> CGFloat {
        return hypot(self.x - point.x, self.y - point.y)
    }
    
    static let topLeft = CGPoint(x: 0, y: 0)
    static let topCenter = CGPoint(x: 0.5, y: 0)
    static let topRight = CGPoint(x: 1, y: 0)
    static let centerLeft = CGPoint(x: 0, y: 0.5)
    static let center = CGPoint(x: 0.5, y: 0.5)
    static let centerRight = CGPoint(x: 1, y: 0.5)
    static let bottomLeft = CGPoint(x: 0, y: 1.0)
    static let bottomCenter = CGPoint(x: 0.5, y: 1.0)
    static let bottomRight = CGPoint(x: 1, y: 1)
}

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

extension UIColor {
    
  // usage: let red: UIColor = UIColor(hex: 0xF44336)
  convenience public init(hex: Int, alpha: CGFloat = 1.0) {
    let red = CGFloat(hex >> 16 & 0xFF) / 255.0
    let green = CGFloat(hex >> 8 & 0xFF) / 255.0
    let blue = CGFloat(hex & 0xFF) / 255.0
    self.init(red:red, green:green, blue:blue, alpha:alpha)
  }
  
  // usage: let red: UIColor = UIColor(hexString: "#FF4221")
  convenience init(hexString: String) {
    let hexStringNormalize = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
    var hex = UInt64()
    Scanner(string: hexStringNormalize).scanHexInt64(&hex)
    let alpha = hex > 0xFFFFFF ? CGFloat(hex >> 24) / 255.0 : 1.0
    let red = CGFloat(hex >> 16 & 0xFF) / 255.0
    let green = CGFloat(hex >> 8 & 0xFF) / 255.0
    let blue = CGFloat(hex & 0xFF) / 255.0
    self.init(red: red, green: green, blue: blue, alpha: alpha)
  }
  
  func toHexString() -> String {
    var r:CGFloat = 0
    var g:CGFloat = 0
    var b:CGFloat = 0
    var a:CGFloat = 0
    
    getRed(&r, green: &g, blue: &b, alpha: &a)
    let rgb:Int = (Int)(r*255)<<16 | (Int)(g*255)<<8 | (Int)(b*255)<<0
    
    return String(format:"#%06x", rgb)
  }
    
}
