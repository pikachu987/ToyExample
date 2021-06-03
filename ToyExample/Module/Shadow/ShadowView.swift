//
//  ShadowView.swift
//

import UIKit

class ShadowView: UIView {
    public var shadowRadius: CGFloat = 2.0 {
        didSet {
            update()
        }
    }

    public var shadowOffset: CGSize = CGSize(width: 3.0, height: 3.0) {
        didSet {
            update()
        }
    }

    public var shadowOpacity: Float = 0.7 {
        didSet {
            update()
        }
    }

    public var shadowColor: UIColor = UIColor.black {
        didSet {
            update()
        }
    }
    
    public var fillColor: UIColor = UIColor.black {
        didSet {
            update()
        }
    }

    private var shadowLayer: CAShapeLayer?
    private var isFrameSet = false

    override func layoutSubviews() {
        super.layoutSubviews()

        isFrameSet = true
        update()
    }

    func update() {
        if !isFrameSet { return }
        if shadowLayer == nil {
            shadowLayer = CAShapeLayer()
        } else {
            shadowLayer?.removeFromSuperlayer()
        }
        guard let shadowLayer = shadowLayer else { return }
        shadowLayer.path = UIBezierPath(roundedRect: bounds, cornerRadius: shadowRadius).cgPath
        shadowLayer.shadowColor = shadowColor.cgColor
        shadowLayer.fillColor = fillColor.cgColor
        shadowLayer.shadowOffset = shadowOffset
        shadowLayer.shadowOpacity = shadowOpacity
        shadowLayer.shadowRadius = shadowRadius
        layer.insertSublayer(shadowLayer, at: 0)
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        if #available(iOS 13.0, *) {
            update()
        }
    }
}
