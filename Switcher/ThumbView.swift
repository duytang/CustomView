//
//  ThumbView.swift
//  JavisApp
//
//  Created by Proton on 3/1/25.
//

import UIKit

final class ThumbView: UIView {
    fileprivate(set) var thumbImageView = UIImageView(frame: .zero)

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(thumbImageView)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        addSubview(thumbImageView)
    }
}

extension ThumbView {
    override func layoutSubviews() {
        super.layoutSubviews()
        thumbImageView.frame = CGRect(x: 0, y: 0, width: frame.width, height: frame.height)
        thumbImageView.layer.cornerRadius = layer.cornerRadius
        thumbImageView.clipsToBounds = clipsToBounds
    }
}
