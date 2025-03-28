//
//  ArrowMenuView.swift
//  Blank
//
//  Created by Dii on 5/3/25.
//

import UIKit

final class ArrowMenuView: UIControl {
    
    private var viewModels: [ArrowMenuViewModel] = []
    private var arrowDirection: ArrowMenuDirection = .up
    private var done: ((NSInteger)->Void)?
    
    private lazy var config = ArrowMenuConfiguration()
    
    lazy var menuTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.backgroundColor = .clear
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorColor = config.menuSeparatorColor
        tableView.layer.cornerRadius = config.cornerRadius
        tableView.clipsToBounds = true
        tableView.register(cellWithClass: ArrowMenuCell.self)
        return tableView
    }()
    
    func setupBasicUI() {
        alpha = 1
        layer.shadowOffset = CGSize(width: 2, height: 2)
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.4
        clipsToBounds = false
    }
    
    func show(_ point: CGPoint, frame: CGRect, viewModels: [ArrowMenuViewModel],
              arrowDirection: ArrowMenuDirection, done: @escaping ((NSInteger)->())) {
        self.frame = frame
        self.viewModels = viewModels
        self.arrowDirection = arrowDirection
        self.done = done
        
        self.repositionMenuTableView()
        if config.arrowHeight != 0 && config.arrowWidth != 0 {
            drawBackgroundLayer(point)
        } else {
            let index = AppConfig.share.get(AppConstant.PrefKey.selectedThemeIndex) as? Int
            backgroundColor = index == 1 ? .white : UIColor(hex: 0xF9F9F9)
            xibCornerRadius = 8
        }
    }
    
    private func repositionMenuTableView() {
        let menuRect = CGRect(x: 0, y: arrowDirection == .down ? 0 : config.arrowHeight,
                              width: frame.size.width,
                              height: frame.size.height - config.arrowHeight)
        menuTableView.frame = menuRect
        menuTableView.reloadData()
        if menuTableView.frame.height < config.menuRowHeight * CGFloat(viewModels.count) {
            menuTableView.isScrollEnabled = true
        } else {
            menuTableView.isScrollEnabled = false
        }
        addSubview(menuTableView)
    }
    
    private lazy var backgroundLayer: CAShapeLayer = {
        let layer: CAShapeLayer = CAShapeLayer()
        return layer
    }()
    
    private func drawBackgroundLayer(_ arrowPoint: CGPoint) {
        if backgroundLayer.superlayer != nil {
            backgroundLayer.removeFromSuperlayer()
        }
        backgroundLayer.path = getBackgroundPath(arrowPoint).cgPath
        backgroundLayer.fillColor = config.backgoundTintColor.cgColor
        backgroundLayer.strokeColor = config.borderColor.cgColor
        backgroundLayer.lineWidth = config.borderWidth
        layer.insertSublayer(backgroundLayer, at: 0)
    }
    
    func getBackgroundPath(_ arrowPoint : CGPoint) -> UIBezierPath {
        let radius : CGFloat = config.cornerRadius / 2.0
        let path : UIBezierPath = UIBezierPath()
        path.lineJoinStyle = .round
        path.lineCapStyle = .round
        
        if arrowDirection == .up {
            path.move(to: CGPoint(x: arrowPoint.x - config.arrowWidth,
                                  y: config.arrowHeight))
            path.addLine(to: CGPoint(x: arrowPoint.x, y: 0))
            path.addLine(to: CGPoint(x: arrowPoint.x + config.arrowWidth,
                                     y: config.arrowHeight))
            path.addLine(to: CGPoint(x: bounds.size.width - radius,
                                     y: config.arrowHeight))
            path.addArc(withCenter: CGPoint(x: bounds.size.width - radius,
                                            y: config.arrowHeight + radius),
                        radius: radius,
                        startAngle: CGFloat((Double.pi / 2.0) * 3),
                        endAngle: 0,
                        clockwise: true)
            path.addLine(to: CGPoint(x: bounds.size.width,
                                     y: bounds.size.height - radius))
            path.addArc(withCenter: CGPoint(x: bounds.size.width - radius,
                                            y: bounds.size.height - radius),
                        radius: radius,
                        startAngle: 0,
                        endAngle: CGFloat(Double.pi / 2.0),
                        clockwise: true)
            path.addLine(to: CGPoint(x: radius, y: bounds.size.height))
            path.addArc(withCenter: CGPoint(x: radius, y: bounds.size.height - radius),
                        radius: radius,
                        startAngle: CGFloat(Double.pi / 2.0),
                        endAngle: CGFloat(Double.pi),
                        clockwise: true)
            path.addLine(to: CGPoint(x: 0, y: config.arrowHeight + radius))
            path.addArc(withCenter: CGPoint(x: radius, y: config.arrowHeight + radius),
                        radius: radius,
                        startAngle: CGFloat(Double.pi),
                        endAngle: CGFloat((Double.pi / 2.0) * 3),
                        clockwise: true)
            path.close()
        } else {
            path.move(to: CGPoint(x: arrowPoint.x - config.arrowWidth,
                                  y: bounds.size.height - config.arrowHeight))
            path.addLine(to: CGPoint(x: arrowPoint.x, y: bounds.size.height))
            path.addLine(to: CGPoint(x: arrowPoint.x + config.arrowWidth,
                                     y: bounds.size.height - config.arrowHeight))
            path.addLine(to: CGPoint(x: bounds.size.width - radius,
                                     y: bounds.size.height - config.arrowHeight))
            path.addArc(withCenter: CGPoint(x: bounds.size.width - radius,
                                            y: bounds.size.height - config.arrowHeight - radius),
                        radius: radius,
                        startAngle: CGFloat(Double.pi / 2.0),
                        endAngle: 0,
                        clockwise: false)
            path.addLine(to: CGPoint(x: bounds.size.width, y: radius))
            path.addArc(withCenter: CGPoint(x: bounds.size.width - radius, y: radius),
                        radius: radius,
                        startAngle: 0,
                        endAngle: CGFloat((Double.pi / 2.0)*3),
                        clockwise: false)
            path.addLine(to: CGPoint(x: radius, y: 0))
            path.addArc(withCenter: CGPoint(x: radius, y: radius),
                        radius: radius,
                        startAngle: CGFloat((Double.pi / 2.0)*3),
                        endAngle: CGFloat(Double.pi),
                        clockwise: false)
            path.addLine(to: CGPoint(x: 0,
                                     y: bounds.size.height - config.arrowHeight - radius))
            path.addArc(withCenter: CGPoint(x: radius,
                                            y: bounds.size.height - config.arrowHeight - radius),
                        radius: radius,
                        startAngle: CGFloat(Double.pi),
                        endAngle: CGFloat(Double.pi / 2.0),
                        clockwise: false)
            path.close()
        }
        return path
    }
    
}

extension ArrowMenuView: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return config.menuRowHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        done?(indexPath.row)
    }
    
}

extension ArrowMenuView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = ArrowMenuCell(style: .default,
                                     reuseIdentifier: String(describing: ArrowMenuCell.self))
        let viewModel = viewModels[indexPath.row]
        cell.bindData(viewModel)
        if (indexPath.row == viewModels.count - 1) {
            cell.separatorInset = UIEdgeInsets(top: 0, left: bounds.size.width, bottom: 0, right: 0)
        } else {
            cell.separatorInset = config.menuSeparatorInset
        }
        return cell
    }
}
