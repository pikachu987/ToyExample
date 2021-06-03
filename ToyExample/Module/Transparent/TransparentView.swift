//
//  TransparentView.swift
//

import UIKit

class TransparentView: UIView {
    var color = UIColor(white: 255/255, alpha: 1) {
        didSet {
            setNeedsDisplay()
        }
    }

    var gray = UIColor(white: 192/255, alpha: 1) {
        didSet {
            setNeedsDisplay()
        }
    }
    
    var size: CGFloat = 16 {
        didSet {
            setNeedsDisplay()
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor(white: 255/255, alpha: 1)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func draw(_ rect: CGRect) {
        let horizontalCount = Int(ceil(rect.width / size))
        let verticalCount = Int(ceil(rect.height / size))
        
        for v in 0..<verticalCount {
            for h in 0..<horizontalCount {
                if (h + v) % 2 == 0 {
                    gray.set()
                } else {
                    color.set()
                }
                let hValue = CGFloat(h)
                let vValue = CGFloat(v)
                let path = UIBezierPath()
                path.move(to: CGPoint(x: size * hValue, y: size * vValue))
                path.addLine(to: CGPoint(x: (size * hValue) + size, y: size * vValue))
                path.addLine(to: CGPoint(x: (size * hValue) + size, y: (size * vValue) + size))
                path.addLine(to: CGPoint(x: size * hValue, y: (size * vValue) + size))
                path.fill()
                path.close()
            }
        }
    }
}
