//
//  Switcher.swift
//  JavisApp
//
//  Created by Proton on 3/1/25.
//

import UIKit

class Switcher: UIControl {

    // MARK: Public properties
    @IBInspectable var isOn: Bool = true {
        didSet {
            self.setupViewsOnAction()
        }
    }

    public var animationDuration: Double = 0.5

    @IBInspectable var padding: CGFloat = 2 {
        didSet {
            self.layoutSubviews()
        }
    }

    @IBInspectable var onTintColor: UIColor = UIColor(hex: 0x00269A) {
        didSet {
            self.setupUI()
        }
    }

    @IBInspectable var offTintColor: UIColor = .white {
        didSet {
            self.setupUI()
        }
    }
    
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return self.privateCornerRadius
        }
        set {
            if newValue > 0.5 || newValue < 0.0 {
                privateCornerRadius = 0.5
            } else {
                privateCornerRadius = newValue
            }
        }
    }
    
    @IBInspectable var labelFont: UIFont?
    @IBInspectable var labelTextColor = UIColor.white
    @IBInspectable var imageCornerRadius: CGFloat = 0.0

    private var privateCornerRadius: CGFloat = 0.5 {
        didSet {
            self.layoutSubviews()
        }
    }

    // thumb properties
    @IBInspectable var thumbTintColor: UIColor = .white {
        didSet {
            self.thumbView.backgroundColor = self.thumbTintColor
        }
    }

    @IBInspectable var thumbCornerRadius: CGFloat {
        get {
            return self.privateThumbCornerRadius
        }
        set {
            if newValue > 0.5 || newValue < 0.0 {
                privateThumbCornerRadius = 0.5
            } else {
                privateThumbCornerRadius = newValue
            }
        }
    }

    private var privateThumbCornerRadius: CGFloat = 0.5 {
        didSet {
            self.layoutSubviews()
        }
    }

    @IBInspectable var thumbSize: CGSize = CGSize.zero {
        didSet {
            self.layoutSubviews()
        }
    }

    @IBInspectable var thumbImage:UIImage? = nil {
        didSet {
            guard let image = thumbImage else {
                return
            }
            thumbView.thumbImageView.image = image
        }
    }

    @IBInspectable var onImage: UIImage? {
        didSet {
            self.onImageView.image = onImage
            self.layoutSubviews()
        }
    }

    @IBInspectable var offImage: UIImage? {
        didSet {
            self.offImageView.image = offImage
            self.layoutSubviews()
        }
    }

    // dodati kasnije
    @IBInspectable var thumbShadowColor: UIColor = UIColor.black {
        didSet {
            self.thumbView.layer.shadowColor = self.thumbShadowColor.cgColor
        }
    }

    @IBInspectable var thumbShadowOffset: CGSize = CGSize(width: 0.75, height: 2) {
        didSet {
            self.thumbView.layer.shadowOffset = self.thumbShadowOffset
        }
    }

    @IBInspectable var thumbShaddowRadius: CGFloat = 1.5 {
        didSet {
            self.thumbView.layer.shadowRadius = self.thumbShaddowRadius
        }
    }

    @IBInspectable var thumbShaddowOppacity: Float = 0.4 {
        didSet {
            self.thumbView.layer.shadowOpacity = self.thumbShaddowOppacity
        }
    }

    // labels
    var labelOff:UILabel = UILabel()
    var labelOn:UILabel = UILabel()

    var areLabelsShown: Bool = false {
        didSet {
            self.setupUI()
        }
    }

    // MARK: Private properties
    fileprivate var thumbView = ThumbView(frame: CGRect.zero)
    fileprivate var onImageView = UIImageView(frame: CGRect.zero)
    fileprivate var offImageView = UIImageView(frame: CGRect.zero)

    fileprivate var onPoint = CGPoint.zero
    fileprivate var offPoint = CGPoint.zero
    fileprivate var isAnimating = false

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupUI()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupUI()
    }
}

// MARK: Private methods
extension Switcher {
    fileprivate func setupUI() {
        // clear self before configuration
        self.clear()
        self.clipsToBounds = false

        // configure thumb view
        thumbView.backgroundColor = self.thumbTintColor
        thumbView.isUserInteractionEnabled = false
        thumbView.clipsToBounds = true
        
        thumbView.layer.shadowColor = self.thumbShadowColor.cgColor
        thumbView.layer.shadowRadius = self.thumbShaddowRadius
        thumbView.layer.shadowOpacity = self.thumbShaddowOppacity
        thumbView.layer.shadowOffset = self.thumbShadowOffset
        backgroundColor = self.isOn ? self.onTintColor : self.offTintColor

        addSubview(thumbView)
        addSubview(onImageView)
        addSubview(offImageView)

        setupLabels()
    }


    private func clear() {
        for view in self.subviews {
            view.removeFromSuperview()
        }
    }

    override open func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        super.beginTracking(touch, with: event)
        self.animate()
        return true
    }

    func setOn(on: Bool, animated:Bool) {
        switch animated {
        case true:
            self.animate(on: on)
        case false:
            self.isOn = on
            self.setupViewsOnAction()
            self.completeAction()
        }
    }

    fileprivate func animate(on: Bool? = nil) {
        self.isOn = on ?? !self.isOn
        self.isAnimating = true

        UIView.animate(withDuration: animationDuration, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5, options: [.curveEaseOut, .beginFromCurrentState, .allowUserInteraction], animations: {
            self.setupViewsOnAction()
        }, completion: { _ in
            self.completeAction()
        })
    }

    private func setupViewsOnAction() {
        self.thumbView.frame.origin.x = self.isOn ? self.onPoint.x : self.offPoint.x
        self.backgroundColor = self.isOn ? self.onTintColor : self.offTintColor

        self.setOnOffImageFrame()
        self.setOnOffLabels()
    }

    private func completeAction() {
        self.isAnimating = false
        self.sendActions(for: .valueChanged)
    }
}

// Mark: Public methods
extension Switcher {
    override func layoutSubviews() {
        super.layoutSubviews()
        if !self.isAnimating {
            self.layer.cornerRadius = self.bounds.size.height * self.cornerRadius
            self.backgroundColor = self.isOn ? self.onTintColor : self.offTintColor

            // thumb managment
            // get thumb size, if none set, use one from bounds
            let thumbSize = self.thumbSize != CGSize.zero ? self.thumbSize : CGSize(width: self.bounds.size.height - 2, height: self.bounds.height - 2)
            let yPostition = (self.bounds.size.height - thumbSize.height) / 2

            self.onPoint = CGPoint(x: self.bounds.size.width - thumbSize.width - self.padding, y: yPostition)
            self.offPoint = CGPoint(x: self.padding, y: yPostition)

            self.thumbView.frame = CGRect(origin: self.isOn ? self.onPoint : self.offPoint, size: thumbSize)
            self.thumbView.layer.cornerRadius = thumbSize.height * self.thumbCornerRadius

            //label frame
            if self.areLabelsShown {
                let labelWidth = self.bounds.width / 1.5 - self.padding * 2
                self.labelOn.frame = CGRect(x: 0, y: 0, width: labelWidth, height: self.frame.height)
                self.labelOff.frame = CGRect(x: self.frame.width - labelWidth, y: 0, width: labelWidth, height: self.frame.height)

            }

            // on/off images
            //set to preserve aspect ratio of image in thumbView
            guard onImage != nil && offImage != nil else {
                return
            }

            let frameSize = thumbSize.width > thumbSize.height ? thumbSize.height * 0.9 : thumbSize.width * 0.9
            let onOffImageSize = CGSize(width: frameSize, height: frameSize)

            onImageView.frame.size = onOffImageSize
            offImageView.frame.size = onOffImageSize
            onImageView.layer.cornerRadius = onOffImageSize.height * self.imageCornerRadius
            offImageView.layer.cornerRadius = onOffImageSize.height * self.imageCornerRadius
            onImageView.clipsToBounds = true
            offImageView.clipsToBounds = true

            onImageView.center = CGPoint(x: self.onPoint.x + self.thumbView.frame.size.width / 2, y: self.thumbView.center.y)
            offImageView.center = CGPoint(x: self.offPoint.x + self.thumbView.frame.size.width / 2, y: self.thumbView.center.y)

            onImageView.alpha = self.isOn ? 1.0 : 0.0
            offImageView.alpha = self.isOn ? 0.0 : 1.0
        }
    }
}

//Mark: Labels frame
extension Switcher {
    fileprivate func setupLabels() {
        guard self.areLabelsShown else {
            self.labelOff.alpha = 0
            self.labelOn.alpha = 0
            return

        }

        self.labelOn.alpha = self.isOn ? 1.0 : 0.0
        self.labelOff.alpha = self.isOn ? 0.0 : 1.0

        let labelWidth = self.bounds.width / 1.5  - self.padding * 2
        self.labelOn.frame = CGRect(x: 0, y: 0, width: labelWidth, height: self.frame.height)
        self.labelOff.frame = CGRect(x: self.frame.width - labelWidth, y: 0, width: labelWidth, height: self.frame.height)
        if let font = self.labelFont{
        self.labelOn.font = font
            self.labelOff.font = font

        }
        self.labelOn.textColor = self.labelTextColor
        self.labelOff.textColor = self.labelTextColor

        self.labelOff.sizeToFit()
        self.labelOn.sizeToFit()
        //self.labelOff.text = "Off"
        //rself.labelOn.text = "On"
        self.labelOff.textAlignment = .center
        self.labelOn.textAlignment = .center

        self.insertSubview(self.labelOff, belowSubview: self.thumbView)
        self.insertSubview(self.labelOn, belowSubview: self.thumbView)
    }
}

//Mark: Animating on/off images
extension Switcher {
    fileprivate func setOnOffImageFrame() {
        guard onImage != nil && offImage != nil else {
            return
        }
        
        self.onImageView.center.x = self.isOn ? self.onPoint.x + self.thumbView.frame.size.width / 2 : self.frame.width
        self.offImageView.center.x = !self.isOn ? self.offPoint.x + self.thumbView.frame.size.width / 2 : 0
        self.onImageView.alpha = self.isOn ? 1.0 : 0.0
        self.offImageView.alpha = self.isOn ? 0.0 : 1.0
    }
    
    fileprivate func setOnOffLabels() {
        guard self.areLabelsShown else {
            return
        }
        
        self.labelOn.alpha = self.isOn ? 1.0 : 0.0
        self.labelOff.alpha = self.isOn ? 0.0 : 1.0
    }
}
