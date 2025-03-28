//
//  ArrowMenuConfiguration.swift
//  Blank
//
//  Created by Dii on 5/3/25.
//


import UIKit

enum ArrowMenuDirection {
    case up
    case down
}

struct ArrowMenuConfiguration {
    public var duration: TimeInterval = 0.2
    public var menuCornerRadius: CGFloat = 4
    public var padding: CGFloat = 12
    public var iconSize: CGFloat = 24
    public var menuRowHeight: CGFloat = 36
    public var arrowHeight: CGFloat = 0
    public var arrowWidth: CGFloat = 0
    public var menuWidth: CGFloat = 152.scaling
    public var textColor: UIColor = UIColor(hexString: "#0E121B")
    public var textFont: UIFont = UIFont.systemFont(ofSize: 14)
    public var borderColor: UIColor = .white
    public var borderWidth: CGFloat = 0
    public var backgoundTintColor: UIColor = .white
    public var cornerRadius: CGFloat = 12
    public var textAlignment: NSTextAlignment = .left
    public var ignoreImageOriginalColor: Bool = false
    public var menuSeparatorColor: UIColor = .clear
    public var menuSeparatorInset: UIEdgeInsets = .init(top: 0, left: 4, bottom: 0, right: 4)
    
    var isHasArrow: Bool {
        arrowWidth != 0 && arrowHeight != 0
    }
}
