//
//  ColorPickerView.swift
//  Notes
//
//  Created by Igor Podolskiy on 09/07/2019.
//  Copyright © 2019 Igor Podolskiy. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable
class ColorPickerView: UIView {
   
    private let palette = Palette()
    private let pointer = Pointer()
    private let pickedColorView = UIView()
    private let pickedColorHashLabel = UILabel()
    private let brightnessSlider = UISlider()
    private let brightnessLabel = UILabel()
    
    private let timeToStepperMargin: CGFloat = 8
    private let actionButtonTopMargin: CGFloat = 8
    
    var pickedColor: UIColor = .white
    
    private func initialize() {
        setupViews()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let pickedColorViewSize = pickedColorView.intrinsicContentSize
        pickedColorView.frame = CGRect(origin: CGPoint(x: bounds.minX+8, y:  bounds.minY + pickedColorViewSize.height+20),
                                   size: CGSize(width: 80, height: 80))
        pickedColorView.layer.cornerRadius = 7
        pickedColorView.layer.masksToBounds = true
        pickedColorView.layer.borderWidth = 1
        
        let pickedColorHashLabelSize = pickedColorHashLabel.intrinsicContentSize
        pickedColorHashLabel.frame = CGRect(origin: CGPoint(x: bounds.minX+8,
                                                            y:  pickedColorView.frame.maxY - pickedColorHashLabelSize.height/2),
                                            size: CGSize(width: 80, height: 20))
        pickedColorHashLabel.backgroundColor = .white
        pickedColorHashLabel.layer.cornerRadius = 7
        pickedColorHashLabel.clipsToBounds = true
        pickedColorHashLabel.layer.borderWidth = 1
        pickedColorHashLabel.textAlignment = .center
        pickedColorHashLabel.font = pickedColorHashLabel.font.withSize(18)
        
        palette.frame = CGRect(origin: CGPoint(x: bounds.minX+8,
                                               y: pickedColorHashLabel.frame.maxY+10),
                               size: CGSize(width: self.frame.width-16,
                                            height: self.frame.height-130))
        
        brightnessSlider.frame = CGRect(origin: CGPoint(x: pickedColorView.bounds.maxX+20,
                                                        y: pickedColorView.bounds.maxY/2),
                                        size: CGSize(width: self.frame.width-pickedColorView.frame.width-40,
                                                     height: 20))
        brightnessSlider.minimumValue = 0.01
        brightnessSlider.maximumValue = 1
        brightnessSlider.setValue(0.5, animated: false)
        
        brightnessLabel.text = "Brightness"
        brightnessLabel.font = brightnessLabel.font.withSize(18)
        brightnessLabel.frame = CGRect(origin: CGPoint(x: pickedColorView.bounds.maxX+20,
                                                       y: brightnessSlider.bounds.maxY),
                                       size: CGSize(width: 120, height: 20))

        var r:CGFloat = 0
        var g:CGFloat = 0
        var b:CGFloat = 0
        var a:CGFloat = 0
        
        pickedColor.getHue(&r, saturation: &g, brightness: &b, alpha: &a)
        brightnessSlider.setValue(Float(b), animated: false)

    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews()
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
       
    }
    
    @objc func changeVlaue(_ sender: UISlider) {
        var h:CGFloat = 0
        var s:CGFloat = 0
        var b:CGFloat = 0
        var a:CGFloat = 0
        
        pickedColor.getHue(&h, saturation: &s, brightness: &b, alpha: &a)
        let color = UIColor(hue: h, saturation: s, brightness: CGFloat(sender.value), alpha: a)
        updatePickedColor(color)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let isHitPalette = touches.contains { (touch) -> Bool in
            let touchPoint = touch.location(in: self)
            return palette.frame.contains(touchPoint) }

            
        if isHitPalette {
            let touch = touches.first!
            let touchPoint = touch.location(in: self)
            let color = palette.getColorAtPoint(point: CGPoint(x: touchPoint.x - palette.frame.origin.x,
                                                               y: touchPoint.y - palette.frame.origin.y))
            updatePickedColor(color)
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let isHitPalette = touches.contains { (touch) -> Bool in
            let touchPoint = touch.location(in: self)
            return palette.frame.contains(touchPoint) }
        
        
        if isHitPalette {
            let touch = touches.first!
            let touchPoint = touch.location(in: self)
            let color = palette.getColorAtPoint(point: CGPoint(x: touchPoint.x - palette.frame.origin.x,
                                                               y: touchPoint.y - palette.frame.origin.y))
            updatePickedColor(color)
        }
    }
    
 
    private func setupViews() {
        addSubview(palette)
        addSubview(pickedColorView)
        addSubview(pickedColorHashLabel)
        addSubview(brightnessSlider)
        addSubview(brightnessLabel)
        palette.translatesAutoresizingMaskIntoConstraints = false
        brightnessSlider.addTarget(self, action: #selector(changeVlaue), for: .valueChanged)
        updateUI()
    }
    
    
    private func updateUI() {
        pickedColorHashLabel.text = "#000000"
    }
    
    func uiColorToHex(_ color: UIColor) -> String {
        var r:CGFloat = 0
        var g:CGFloat = 0
        var b:CGFloat = 0
        var a:CGFloat = 0
        
        color.getRed(&r, green: &g, blue: &b, alpha: &a)
        let rgb:Int = (Int)(r*255)<<16 | (Int)(g*255)<<8 | (Int)(b*255)<<0
        
        return String(format:"#%06x", rgb)
    }
    
    func updatePickedColor (_ color: UIColor) {
        pickedColor = color
        pickedColorView.backgroundColor = pickedColor
        pickedColorHashLabel.text = uiColorToHex(color)
        
        var h:CGFloat = 0
        var s:CGFloat = 0
        var b:CGFloat = 0
        var a:CGFloat = 0
        
        pickedColor.getHue(&h, saturation: &s, brightness: &b, alpha: &a)
        brightnessSlider.setValue(Float(b), animated: false)
    }
    
}

