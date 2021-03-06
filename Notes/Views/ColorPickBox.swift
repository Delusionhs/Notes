//
//  ColorPickBox.swift
//
//
//  Created by Igor Podolskiy on 12/07/2019.
//

import UIKit

@IBDesignable
class ColorPickBox: UIView {
    let saturationExponent: Float = 0.8

    private let checkMark = CheckMark()

    @IBInspectable var elementSize: CGFloat = 2.0 {
        didSet {
            setNeedsDisplay()
        }
    }

    @IBInspectable var defaultColor: UIColor? = nil {
        didSet {
            setNeedsDisplay()
        }
    }

    private let isPicked = false

    private func initialize() {
        self.clipsToBounds = true
        self.layer.borderWidth = 1
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }

    override func draw(_ rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        if let defaultColor = defaultColor {
            context!.clear(rect)
            let color: UIColor = defaultColor
            context!.setFillColor(color.cgColor)
            context!.fill(rect)
        } else {
            for y: CGFloat in stride(from: 0.0, to: rect.height, by: elementSize) {
                var saturation = CGFloat(y) / rect.height
                saturation = CGFloat(powf(Float(saturation), saturationExponent))
                for x: CGFloat in stride(from: 0.0, to: rect.width, by: elementSize) {
                    let hue = x / rect.width
                    let color = UIColor(hue: hue, saturation: saturation, brightness: 1.0, alpha: 1.0)
                    context!.setFillColor(color.cgColor)
                    context!.fill(CGRect(x: x, y: y, width: elementSize, height: elementSize))
                }
            }
        }

    }

    func checkMarkAdd() {
        checkMark.frame = CGRect(origin: CGPoint(x: bounds.maxX-self.frame.size.height/3, y: bounds.minY),
                                 size: CGSize(width: self.frame.size.height/3, height: self.frame.size.width/3))
        self.addSubview(checkMark)
    }

    func deleteCheckMark() {
        checkMark.removeFromSuperview()
    }

}
