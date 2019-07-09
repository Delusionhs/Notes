//
//  Palette.swift
//  ColorPicker
//
//  Created by Igor Podolskiy on 08/07/2019.
//  Copyright © 2019 Igor Podolskiy. All rights reserved.
//


import Foundation
import UIKit

@IBDesignable
class Palette: UIView {
    let saturationExponent:Float = 0.8
    
    @IBInspectable var elementSize: CGFloat = 2.0 {
        didSet {
            setNeedsDisplay()
        }
    }
    
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
        for y : CGFloat in stride(from: 0.0 ,to: rect.height, by: elementSize) {
            var saturation = CGFloat(y) / rect.height
            saturation = CGFloat(powf(Float(saturation), saturationExponent))
            for x : CGFloat in stride(from: 0.0 ,to: rect.width, by: elementSize) {
                let hue = x / rect.width
                let color = UIColor(hue: hue, saturation: saturation, brightness: 1.0, alpha: 1.0)
                context!.setFillColor(color.cgColor)
                context!.fill(CGRect(x:x, y:y, width:elementSize,height:elementSize))
            }
        }
    }
    
    func getColorAtPoint(point:CGPoint) -> UIColor {
        let roundedPoint = CGPoint(x:elementSize * CGFloat(Int(point.x / elementSize)),
                                   y:elementSize * CGFloat(Int(point.y / elementSize)))
        var saturation = CGFloat(roundedPoint.y) / self.bounds.height
        saturation = CGFloat(powf(Float(saturation), saturationExponent))
        let hue = roundedPoint.x / self.bounds.width
        return UIColor(hue: hue, saturation: saturation, brightness: 1.0, alpha: 1.0)
    }
    
    func getPointForColor(color:UIColor) -> CGPoint {
        var hue: CGFloat = 0.0
        var saturation: CGFloat = 0.0
        var brightness: CGFloat = 0.0
        color.getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: nil);
        
        var yPos:CGFloat = 0
        let percentageY = powf(Float(saturation), 1.0 / saturationExponent)
            yPos = CGFloat(percentageY) * self.bounds.height
        let xPos = hue * self.bounds.width
        return CGPoint(x: xPos, y: yPos)
    }
}
