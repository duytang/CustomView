//
//  ArrowMenu.swift
//  Blank
//
//  Created by Dii on 5/3/25.
//

import UIKit

final class ArrowMenu: NSObject {
    static let shared = ArrowMenu()
    private var config = ArrowMenuConfiguration()
    
    private var sender: UIView?
    private var senderFrame: CGRect?
    private var viewModels: [ArrowMenuViewModel] = []
    private var leading: CGFloat = 0.0
    private var done: ((_ selectedIndex: NSInteger)->Void)?
    private var cancel: (()->Void)?
    
    private lazy var backgroundView: UIView = {
        let view = UIView(frame: UIScreen.main.bounds)
        view.backgroundColor = UIColor.clear
        view.addGestureRecognizer(tapGesture)
        return view
    }()
    
    private lazy var popOverMenu: ArrowMenuView = {
        let menu = ArrowMenuView(frame: CGRect.zero)
        menu.setupBasicUI()
        backgroundView.addSubview(menu)
        return menu
    }()
    
    private var isOnScreen: Bool = false {
        didSet {
            if isOnScreen {
                addOrientationChangeNotification()
            } else {
                removeOrientationChangeNotification()
            }
        }
    }
    
    private lazy var tapGesture: UITapGestureRecognizer = {
        let gesture = UITapGestureRecognizer(target: self,
                                             action: #selector(onBackgroudViewTapped(gesture:)))
        gesture.delegate = self
        return gesture
    }()
    
    private func show(_ sender: UIView?, senderFrame: CGRect? = nil, viewModels: [ArrowMenuViewModel], leading: CGFloat,
                      done: @escaping (NSInteger)->Void, cancel:@escaping ()->Void) {
        self.sender = sender
        self.senderFrame = senderFrame
        self.viewModels = viewModels
        self.leading = leading
        self.done = done
        self.cancel = cancel
        
        UIApplication.shared.keyWindow?.addSubview(backgroundView)
        adjustPostionForPopOverMenu(with: leading)
    }
    
    private func adjustPostionForPopOverMenu(with leading: CGFloat) {
        backgroundView.frame = CGRect(x: config.isHasArrow ? 0 : leading, y: 0, width: UIScreen.screenWidth, height: UIScreen.screenHeight)
        setupPopOverMenu()
        showIfNeeded()
    }
    
    private func setupPopOverMenu() {
        popOverMenu.transform = CGAffineTransform(scaleX: 1, y: 1)
        configurePopMenuFrame()
        
        popOverMenu.show(menuArrowPoint, frame: popMenuFrame,
                         viewModels: viewModels, arrowDirection: arrowDirection,
                         done: { [weak self] (index: NSInteger) in
            guard let strongSelf = self else { return }
            strongSelf.isOnScreen = false
            strongSelf.doneAction(index)
        })
        let anchorPoint = CGPoint(x: menuArrowPoint.x / popMenuFrame.size.width, y: arrowDirection == .down ? 1 : 0)
        popOverMenu.set(anchorPoint)
    }
    
    private var senderRect: CGRect = CGRect.zero
    private var popMenuOriginX: CGFloat = 0
    private var popMenuFrame: CGRect = CGRect.zero
    private var menuArrowPoint: CGPoint = CGPoint.zero
    private var arrowDirection: ArrowMenuDirection = .up
    private var popMenuHeight: CGFloat {
        return config.menuRowHeight * CGFloat(viewModels.count) + config.arrowHeight
    }
    
    private func configurePopMenuFrame() {
        configureSenderRect()
        configureMenuArrowPoint()
        configurePopMenuOriginX()
        if arrowDirection == .up {
            popMenuFrame = CGRect(x: popMenuOriginX, y: (senderRect.origin.y + senderRect.size.height),
                                  width: config.menuWidth, height: popMenuHeight)
            if popMenuFrame.origin.y + popMenuFrame.size.height > UIScreen.screenHeight {
                popMenuFrame = CGRect(x: popMenuOriginX, y: (senderRect.origin.y + senderRect.size.height),
                                      width: config.menuWidth,
                                      height: UIScreen.screenHeight - popMenuFrame.origin.y - config.padding)
            }
        } else {
            popMenuFrame = CGRect(x: popMenuOriginX, y: senderRect.origin.y - popMenuHeight,
                                  width: config.menuWidth, height: popMenuHeight)
            if popMenuFrame.origin.y < 0 {
                popMenuFrame = CGRect(x: popMenuOriginX, y: config.padding,
                                      width: config.menuWidth,
                                      height: senderRect.origin.y - config.padding)
            }
        }
    }
    
    private func configureSenderRect() {
        if sender != nil {
            if sender!.superview != nil {
                senderRect = sender!.superview!.convert(sender!.frame, to: backgroundView)
            } else {
                senderRect = sender!.frame
            }
        } else if senderFrame != nil {
            senderRect = senderFrame!
        }
        senderRect.origin.y = min(UIScreen.screenHeight, senderRect.origin.y)
        arrowDirection = (senderRect.origin.y + senderRect.size.height / 2.0 < UIScreen.screenHeight / 2.0) ? .up : .down
    }
    
    private func configurePopMenuOriginX() {
        var senderXCenter: CGPoint = CGPoint(x: senderRect.origin.x + (senderRect.size.width) / 2.0, y: 0)
        let menuCenterX: CGFloat = config.menuWidth / 2.0 + config.padding
        var menuX: CGFloat = 0
        if (senderXCenter.x + menuCenterX > UIScreen.screenWidth) {
            let sWidth = UIScreen.screenWidth - config.menuWidth - config.padding
            senderXCenter.x = min(senderXCenter.x - sWidth, config.menuWidth - config.arrowWidth - config.padding)
            menuX = sWidth
        } else if senderXCenter.x - menuCenterX < 0 {
            senderXCenter.x = max(config.menuCornerRadius + config.arrowWidth, senderXCenter.x - config.padding)
            menuX = config.padding
        } else {
            senderXCenter.x = config.menuWidth / 2.0
            menuX = senderRect.origin.x + senderRect.size.width / 2.0 - config.menuWidth / 2.0
        }
        popMenuOriginX = menuX
    }
    
    private func configureMenuArrowPoint() {
        var point: CGPoint = CGPoint(x: senderRect.origin.x + (senderRect.size.width) / 2.0, y: 0)
        let menuCenterX: CGFloat = config.menuWidth / 2.0 + config.padding
        if senderRect.origin.y + senderRect.size.height / 2.0 < UIScreen.screenHeight / 2.0 {
            point.y = 0
        } else {
            point.y = popMenuHeight
        }
        if (point.x + menuCenterX) > UIScreen.screenWidth {
            point.x = min(point.x - (UIScreen.screenWidth - config.menuWidth - config.padding),
                          config.menuWidth - config.arrowWidth - config.padding)
        } else if point.x - menuCenterX < 0 {
            point.x = max(config.menuCornerRadius + config.arrowWidth, point.x - config.padding)
        } else {
            point.x = config.menuWidth / 2.0
        }
        menuArrowPoint = point
    }
    
    @objc fileprivate func onBackgroudViewTapped(gesture : UIGestureRecognizer) {
        dismiss()
    }
    
    private func showIfNeeded() {
        if !isOnScreen {
            isOnScreen = true
            popOverMenu.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
            UIView.animate(withDuration: config.duration, animations: {
                self.popOverMenu.alpha = 1
                self.popOverMenu.transform = CGAffineTransform(scaleX: 1, y: 1)
            })
        }
    }
    
    private func dismiss() {
        isOnScreen = false
        doneAction(-1)
    }
    
    private func doneAction(_ selectedIndex: NSInteger) {
        UIView.animate(withDuration: config.duration, animations: {
            self.popOverMenu.alpha = 0
            self.popOverMenu.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        }) { (isFinished) in
            if isFinished {
                self.backgroundView.removeFromSuperview()
                selectedIndex < 0 ? self.cancel?() : self.done?(selectedIndex)
            }
        }
    }
    
    // MARK: Animation
    static func show(_ sender: UIView, viewModels: [ArrowMenuViewModel]?, leading: CGFloat, done: @escaping (NSInteger)->Void, cancel: @escaping ()->Void) {
        guard let viewModels = viewModels, viewModels.count > 0 else { return }
        shared.show(sender, viewModels: viewModels, leading: leading, done: done, cancel: cancel)
    }
    
    static func dismiss() {
        shared.dismiss()
    }
}

// MARK: - Notification
extension ArrowMenu {
    private func addOrientationChangeNotification() {
        NotificationCenter
            .default
            .addObserver(self,
                         selector: #selector(onChangeStatusBarOrientationNotification(notification:)),
                         name: UIApplication.didChangeStatusBarOrientationNotification,
                         object: nil)
    }
    
    private func removeOrientationChangeNotification() {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc private func onChangeStatusBarOrientationNotification(notification : Notification) {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()
                                      + Double(Int64(0.2 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: {
            self.adjustPostionForPopOverMenu(with: self.leading)
        })
    }
}

extension ArrowMenu: UIGestureRecognizerDelegate {
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer,
                                  shouldReceive touch: UITouch) -> Bool {
        let touchPoint = touch.location(in: backgroundView)
        if touch.view?.superview is UITableViewCell {
            return false
        }
        if CGRect(x: 0, y: 0, width: config.menuWidth, height: config.menuRowHeight).contains(touchPoint) {
            self.doneAction(0)
            return false
        }
        return true
    }
    
}
