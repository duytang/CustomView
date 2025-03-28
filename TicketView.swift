//
//  TicketView.swift
//  Blank
//
//  Created by Dii on 20/3/25.
//

import UIKit

class TicketView: UIView {
    
    var radius: CGFloat = 36
    var circleWidth: CGFloat = 20
    var numberOfCicle: Int = 9
    var bottomY: CGFloat = 152
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .clear
        layer.cornerRadius = 18
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        drawTicket()
    }
    
    func updateView(radius: CGFloat = 36, circleWidth: CGFloat = 20, numberOfCicle: Int = 9, bottomY: CGFloat = 152) {
        self.radius = radius
        self.circleWidth = circleWidth
        self.numberOfCicle = numberOfCicle
        self.bottomY = bottomY
        layoutSubviews()
    }
    
    override func layoutSubviews() {
        drawTicket()
    }
    
    private func drawTicket() {
        let ticketShapeLayer = CAShapeLayer()
        ticketShapeLayer.frame = self.bounds
        ticketShapeLayer.fillColor = UIColor.white.cgColor
        
        let ticketShapePath = UIBezierPath(roundedRect: ticketShapeLayer.bounds, cornerRadius: 0)
        
        let topLeftArcPath = UIBezierPath(arcCenter: CGPoint(x: 0, y: 100),
                                          radius: radius / 2,
                                          startAngle:  CGFloat(Double.pi / 2),
                                          endAngle: CGFloat(Double.pi + Double.pi / 2),
                                          clockwise: false)
        topLeftArcPath.close()
        
        let topRightArcPath = UIBezierPath(arcCenter: CGPoint(x: ticketShapeLayer.frame.width, y: 100),
                                           radius: radius / 2,
                                           startAngle:  CGFloat(Double.pi / 2),
                                           endAngle: CGFloat(Double.pi + Double.pi / 2),
                                           clockwise: true)
        topRightArcPath.close()
        
        let bottomLeftArcPath = UIBezierPath(arcCenter: CGPoint(x: 0, y: frame.height - bottomY),
                                             radius: 36 / 2,
                                             startAngle:  CGFloat(Double.pi / 2),
                                             endAngle: CGFloat(Double.pi + Double.pi / 2),
                                             clockwise: false)
        bottomLeftArcPath.close()
        
        let bottomRightArcPath = UIBezierPath(arcCenter: CGPoint(x: ticketShapeLayer.frame.width, y: frame.height - bottomY),
                                              radius: radius / 2,
                                              startAngle:  CGFloat(Double.pi / 2),
                                              endAngle: CGFloat(Double.pi + Double.pi / 2),
                                              clockwise: true)
        bottomRightArcPath.close()
        
        let widthForCircle: CGFloat = ticketShapeLayer.frame.width - (radius * 2) - (circleWidth * CGFloat(numberOfCicle))
        let space: CGFloat = widthForCircle / CGFloat(numberOfCicle)
        var current: CGFloat = radius
        for index in 1...numberOfCicle {
            let x: CGFloat
            if index == 1 {
                x = space
            } else {
                x = space + circleWidth
            }
            current += x
            let circle = UIBezierPath(arcCenter: CGPoint(x: current, y: frame.height - 152),
                                      radius: circleWidth / 2,
                                      startAngle: 0,
                                      endAngle:  CGFloat(Double.pi + Double.pi),
                                      clockwise: false)
            circle.close()
            ticketShapePath.append(circle)
        }
        
        //        ticketShapePath.append(topLeftArcPath)
        //        ticketShapePath.append(topRightArcPath.reversing())
        ticketShapePath.append(bottomLeftArcPath)
        ticketShapePath.append(bottomRightArcPath.reversing())
        
        ticketShapeLayer.path = ticketShapePath.cgPath
        
        layer.addSublayer(ticketShapeLayer)
        
        // Add elevation
        layer.shadowColor = UIColor.systemGray.cgColor
        layer.shadowOpacity = 0.4
        layer.shadowRadius = 10
        layer.shadowOffset = .zero
    }
}
