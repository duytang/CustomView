//
//  AdvancedPageControl.swift
//  Blank
//
//  Created by Dii on 8/1/25.
//

import Foundation
import UIKit

class AdvancedPageControlView: UIView {
    var animDuration = 0.2
    
    private var mustGoCurrentItem: CGFloat = 0
    private var previuscurrentItem: CGFloat = 0
    private var displayLink: CADisplayLink?
    private var startTime = 0.0
    
    var numberOfPages: Int { get { return drawer.numberOfPages } set(val) {
        setNeedsDisplay()
        drawer.numberOfPages = val
    }}
    
    var drawer: AdvancedPageControlDraw = ExtendedDotDrawer()
    
    init() {
        super.init(frame: .zero)
        backgroundColor = .clear
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        backgroundColor = .clear
    }
    
    func setPageOffset(_ offset: CGFloat) {
        drawer.currentItem = CGFloat(offset)
        setNeedsDisplay()
    }
    
    func setPage(_ index: Int) {
        if mustGoCurrentItem != CGFloat(index) {
            previuscurrentItem = round(drawer.currentItem)
            self.mustGoCurrentItem = CGFloat(index)
            startDisplayLink()
        }
    }
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: self.drawer.size, height: self.drawer.size + 16)
    }
    
    override func draw(_ rect: CGRect) {
        drawer.draw(rect)
    }
    
    private func startDisplayLink() {
        stopDisplayLink() // make sure to stop a previous running display link
        startTime = Date.timeIntervalSinceReferenceDate // reset start time
        let displayLink = CADisplayLink(
            target: self, selector: #selector(displayLinkDidFire)
        )
        displayLink.add(to: .current, forMode: .common)
        self.displayLink = displayLink
    }
    
    @objc private func displayLinkDidFire(_: CADisplayLink) {
        var elapsed = Date.timeIntervalSinceReferenceDate - startTime
        
        if elapsed > animDuration {
            stopDisplayLink()
            elapsed = animDuration // clamp the elapsed time to the anim length
        }
        let progress = CGFloat(elapsed / animDuration)
        
        let sign = mustGoCurrentItem - previuscurrentItem
        
        drawer.currentItem = CGFloat(progress * sign + previuscurrentItem)
        
        setNeedsDisplay()
    }
    
    // invalidate display link if it's non-nil, then set to nil
    private func stopDisplayLink() {
        displayLink?.invalidate()
        displayLink = nil
    }
}

public func addColor(_ color1: UIColor, with color2: UIColor) -> UIColor {
    var (r1, g1, b1, a1) = (CGFloat(0), CGFloat(0), CGFloat(0), CGFloat(0))
    var (r2, g2, b2, a2) = (CGFloat(0), CGFloat(0), CGFloat(0), CGFloat(0))

    color1.getRed(&r1, green: &g1, blue: &b1, alpha: &a1)
    color2.getRed(&r2, green: &g2, blue: &b2, alpha: &a2)

    // add the components, but don't let them go above 1.0
    return UIColor(red: min(r1 + r2, 1), green: min(g1 + g2, 1), blue: min(b1 + b2, 1), alpha: (a1 + a2) / 2)
}

public func multiplyColor(_ color: UIColor, by multiplier: CGFloat) -> UIColor {
    var (r, g, b, a) = (CGFloat(0), CGFloat(0), CGFloat(0), CGFloat(0))
    color.getRed(&r, green: &g, blue: &b, alpha: &a)
    return UIColor(red: r * multiplier, green: g * multiplier, blue: b * multiplier, alpha: a)
}

public func + (color1: UIColor, color2: UIColor) -> UIColor {
    return addColor(color1, with: color2)
}

public func * (color: UIColor, multiplier: Double) -> UIColor {
    return multiplyColor(color, by: CGFloat(multiplier))
}
