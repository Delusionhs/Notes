//
//  CheckMark.swift
//  Notes
//
//  Created by Igor Podolskiy on 11/07/2019.
//  Copyright © 2019 Igor Podolskiy. All rights reserved.
//

import UIKit

@IBDesignable
class checkMark: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clear
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        if let context = UIGraphicsGetCurrentContext() {
            context.setLineWidth(5.0);
            UIColor.black.set()
            let center = CGPoint(x: frame.size.width/2, y: frame.size.height/2)
            let radius = (frame.size.width)/2
            context.addArc(center: center, radius: radius, startAngle: 0.0, endAngle: .pi * 2.0, clockwise: true)
            let path = UIBezierPath()
            path.move(to: CGPoint(x: center.x-radius, y: center.y))
            path.addLine(to: CGPoint(x: center.x, y: center.y+radius))
            path.addLine(to: CGPoint(x: frame.size.width-radius/2, y: 0-radius/2))
            path.lineWidth = 1
            path.stroke()
            context.strokePath()
        }
    }
}
