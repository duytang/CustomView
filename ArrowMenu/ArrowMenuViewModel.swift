//
//  ArrowMenuViewModel.swift
//  Blank
//
//  Created by Dii on 5/3/25.
//

import Foundation

final class ArrowMenuViewModel {
    
    var title: String?
    var imageName: String?
    
    public init(title: String, imageName: String) {
        self.title = title
        self.imageName = imageName
    }
    
}

extension UIScreen {
    static var screenWidth: CGFloat {
        main.bounds.size.width
    }
    
    static var screenHeight: CGFloat {
        main.bounds.size.height
    }
    
}

extension UIControl {
  
  func set(_ anchorPoint: CGPoint) {
    var newPoint = CGPoint(x: bounds.size.width * anchorPoint.x,
                           y: bounds.size.height * anchorPoint.y)
    var oldPoint = CGPoint(x: bounds.size.width * layer.anchorPoint.x,
                           y: bounds.size.height * layer.anchorPoint.y)
    
    newPoint = newPoint.applying(transform)
    oldPoint = oldPoint.applying(transform)
    
    var position = layer.position
    position.x -= oldPoint.x
    position.x += newPoint.x
    
    position.y -= oldPoint.y
    position.y += newPoint.y
    
    layer.position = position
    layer.anchorPoint = anchorPoint
  }
}
