//
//  WaveTabbarController.swift
//  collectiondemo
//
//  Created by Proton on 1/4/25.
//

import UIKit

final class WaveTabbarController: UITabBarController, UITabBarControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tabBar = { () -> CustomizedTabBar in
            let tabBar = CustomizedTabBar()
            tabBar.delegate = self
            return tabBar
        }()
        self.setValue(tabBar, forKey: "tabBar")
        delegate = self
        
        let homeVC = HomeViewController(with: "Home")
        homeVC.tabBarItem = UITabBarItem(title: "Home",
                                         image: UIImage(systemName: "house")?.withRenderingMode(.alwaysOriginal),
                                         selectedImage: UIImage(systemName: "house.fill")?.withRenderingMode(.alwaysOriginal))
        let navi = UINavigationController(rootViewController: homeVC)
        let discoveryVC = HomeViewController(with: "Discover")
        discoveryVC.tabBarItem = UITabBarItem(title: "Discover",
                                              image: UIImage(systemName: "figure.run.circle")?.withRenderingMode(.alwaysOriginal),
                                              selectedImage: UIImage(systemName: "figure.run.circle.fill")?.withRenderingMode(.alwaysOriginal))
        let scanVC = ScanViewController()
        scanVC.tabBarItem = UITabBarItem(title: "",
                                         image: UIImage(named: "scan")?.withRenderingMode(.alwaysOriginal),
                                         selectedImage: UIImage(named: "scan")?.withRenderingMode(.alwaysOriginal))
        let chatVC = HomeViewController(with: "ChatVC")
        chatVC.tabBarItem = UITabBarItem(title: "Chat",
                                         image: UIImage(systemName: "ellipsis.message")?.withRenderingMode(.alwaysOriginal),
                                         selectedImage: UIImage(systemName: "ellipsis.message")?.withRenderingMode(.alwaysOriginal))
        let profileVC = HomeViewController(with: "Profile")
        profileVC.tabBarItem =  UITabBarItem(title: "Profile",
                                            image: UIImage(systemName: "person.circle")?.withRenderingMode(.alwaysOriginal),
                                            selectedImage: UIImage(systemName: "person.circle.fill")?.withRenderingMode(.alwaysOriginal))
        
        viewControllers = [navi, discoveryVC, scanVC, chatVC, profileVC]
        for tabBarItem in tabBar.items! where tabBarItem == scanVC.tabBarItem {
            tabBarItem.title = ""
            tabBarItem.imageInsets = UIEdgeInsets(top: -20, left: 0, bottom: 0, right: 0)
        }
        if #available(iOS 15, *) {
            let tabBarAppearance = UITabBarAppearance()
            tabBarAppearance.configureWithOpaqueBackground()
            tabBarAppearance.shadowImage = nil
            tabBarAppearance.shadowColor = nil
            let gradient = UIImage.gImage(frame: CGRect(origin: .zero, size: CGSize(width: 100, height: 40)), type: .leftToRight,  colors: [UIColor(hex: 0x00C0FF), UIColor(hex: 0x5558FF)])
            tabBarAppearance.stackedLayoutAppearance.selected.titleTextAttributes = [.foregroundColor: UIColor(patternImage: gradient), .font: UIFont.systemFont(ofSize: 10, weight: .bold)]
            tabBarAppearance.stackedLayoutAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor(hex: 0x64758F), .font: UIFont.systemFont(ofSize: 10, weight: .bold)]
            tabBar.standardAppearance = tabBarAppearance
            tabBar.scrollEdgeAppearance = tabBarAppearance
            tabBar.tintColor = UIColor(patternImage: gradient)
        } else {
            let gradient = UIImage.gImage(frame: CGRect(origin: .zero, size: CGSize(width: 100, height: 40)), type: .leftToRight, colors: [UIColor(hex: 0x00C0FF), UIColor(hex: 0x5558FF)])
            UITabBarItem.appearance().setTitleTextAttributes([.foregroundColor: UIColor(hex: 0x103F9A), .font: UIFont.systemFont(ofSize: 10, weight: .bold)], for: .selected)
            UITabBarItem.appearance().setTitleTextAttributes([.foregroundColor: UIColor(hex: 0x64758F), .font: UIFont.systemFont(ofSize: 10, weight: .bold)], for: .normal)
            tabBar.tintColor = UIColor(patternImage: gradient)
            tabBar.shadowImage = UIImage()
            tabBar.backgroundImage = UIImage()
        }
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        guard let index = tabBar.items?.firstIndex(of: item) else { return }
        if index == 2 {
            let scanVC = ScanViewController()
            present(scanVC, animated: true)
            return
        }
    }
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        if viewController is ScanViewController {
            return false
        }
        return true
    }
}

class CustomizedTabBar: UITabBar {
    @IBInspectable var height: CGFloat = 94
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        var sizeThatFits = super.sizeThatFits(size)
        if height > 0.0 {
            sizeThatFits.height = height
        }
        return sizeThatFits
    }
    
    
    private var shapeLayer: CALayer?
    private func addShape() {
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = createPath()
        shapeLayer.fillColor = UIColor.white.cgColor
        // uncomment below if wants to add a line
//        shapeLayer.strokeColor = UIColor.lightGray.cgColor
//        shapeLayer.lineWidth = 1.0
        
        //The below 4 lines are for shadow above the bar. you can skip them if you do not want a shadow
        shapeLayer.shadowOffset = CGSize(width:0, height:0)
        shapeLayer.shadowRadius = 10
        shapeLayer.shadowColor = UIColor.lightGray.cgColor
        shapeLayer.shadowOpacity = 0.3
        
        if let oldShapeLayer = self.shapeLayer {
            self.layer.replaceSublayer(oldShapeLayer, with: shapeLayer)
        } else {
            self.layer.insertSublayer(shapeLayer, at: 0)
        }
        self.shapeLayer = shapeLayer
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        self.addShape()
    }
    
    
    func createPath() -> CGPath {
        let height: CGFloat = 26
        let path = UIBezierPath()
        let centerWidth = self.frame.width / 2
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: (centerWidth - height * 2), y: 0))
        
        path.addCurve(to: CGPoint(x: centerWidth, y: -height),
                      controlPoint1: CGPoint(x: (centerWidth - 30), y: 0), controlPoint2: CGPoint(x: centerWidth - 35, y: -height))
        
        path.addCurve(to: CGPoint(x: (centerWidth + height * 2), y: 0),
                      controlPoint1: CGPoint(x: centerWidth + 35, y: -height), controlPoint2: CGPoint(x: (centerWidth + 30), y: 0))
        
        path.addLine(to: CGPoint(x: self.frame.width, y: 0))
        path.addLine(to: CGPoint(x: self.frame.width, y: self.frame.height))
        path.addLine(to: CGPoint(x: 0, y: self.frame.height))
        path.close()
        return path.cgPath
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        guard !clipsToBounds && !isHidden && alpha > 0 else { return nil }
        for member in subviews.reversed() {
            let subPoint = member.convert(point, from: self)
            guard let result = member.hitTest(subPoint, with: event) else { continue }
            return result
        }
        return nil
    }
}
