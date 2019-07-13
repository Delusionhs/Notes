//
//  ColorPickerView.swift
//  Notes
//
//  Created by Igor Podolskiy on 09/07/2019.
//  Copyright © 2019 Igor Podolskiy. All rights reserved.
//

import UIKit

@IBDesignable
class ColorPickerView: UIView {
   
    private let palette = Palette()
    private let pointer = Pointer()
    private let pickedColorView = UIView()
    private let pickedColorHashLabel = UILabel()
    private let brightnessSlider = UISlider()
    private let brightnessLabel = UILabel()
    let doneButton = UIButton()
    
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
        ///////////////////////////////////////////////////////////////////////////////////////////
        let pickedColorViewSize = pickedColorView.intrinsicContentSize
        pickedColorView.frame = CGRect(origin: CGPoint(x: bounds.minX+8, y:  bounds.minY + pickedColorViewSize.height+20),
                                   size: CGSize(width: 80, height: 80))
        pickedColorView.layer.cornerRadius = 7
        pickedColorView.layer.borderWidth = 1
        ///////////////////////////////////////////////////////////////////////////////////////////
        pickedColorHashLabel.frame = CGRect(origin: CGPoint(x: bounds.minX+8,
                                                            y:  pickedColorView.frame.maxY - 15),
                                            size: CGSize(width: 80, height: 20))
        pickedColorHashLabel.backgroundColor = .white
        pickedColorHashLabel.layer.cornerRadius = 7
        pickedColorHashLabel.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        pickedColorHashLabel.layer.borderWidth = 1
        pickedColorHashLabel.textAlignment = .center
        pickedColorHashLabel.font = pickedColorHashLabel.font.withSize(18)
        pickedColorHashLabel.text = uiColorToHex(pickedColor)
        ///////////////////////////////////////////////////////////////////////////////////////////
        palette.frame = CGRect(origin: CGPoint(x: bounds.minX+8,
                                               y: pickedColorHashLabel.frame.maxY+20),
                               size: CGSize(width: self.frame.width-16,
                                            height: self.frame.height-130))//self.frame.height/3))
        ///////////////////////////////////////////////////////////////////////////////////////////
        brightnessSlider.frame = CGRect(origin: CGPoint(x: pickedColorView.bounds.maxX+20,
                                                        y: pickedColorHashLabel.frame.minY),
                                        size: CGSize(width: self.frame.width-pickedColorView.frame.width-40,
                                                     height: 20))
        brightnessSlider.minimumValue = 0.001
        brightnessSlider.maximumValue = 1
        ///////////////////////////////////////////////////////////////////////////////////////////
        brightnessLabel.frame = CGRect(origin: CGPoint(x: pickedColorView.bounds.maxX+20,
                                                       y: pickedColorView.bounds.maxY/2),
                                       size: CGSize(width: 120, height: 35))
        brightnessSlider.addTarget(self, action: #selector(changeVlaue), for: .valueChanged)
        brightnessLabel.text = "Brightness"
        brightnessLabel.font = brightnessLabel.font.withSize(20)
        let point = palette.getPointForColor(color: pickedColor)
        pointer.frame = CGRect(origin: CGPoint(x: point.x-15,
                                               y: point.y-15),
                               size: CGSize(width: 30, height: 30))
        brightnessSlider.setValue(getBrightness(pickedColor), animated: false)
        ///////////////////////////////////////////////////////////////////////////////////////////
        doneButton.setTitle("Done", for: .normal)
        let doneButtonSize = doneButton.intrinsicContentSize
        doneButton.frame = CGRect(origin: CGPoint(x: palette.frame.maxX-doneButtonSize.width-8,
                                               y: pickedColorView.frame.minX+8),
                               size: doneButtonSize)
        doneButton.setTitleColor(doneButton.tintColor, for: .normal)
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
        var a:CGFloat = 0
        
        pickedColor.getHue(&h, saturation: &s, brightness: nil, alpha: &a)
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
        setupPointer()
        let point = palette.getPointForColor(color: pickedColor)
        pointer.frame = CGRect(origin: CGPoint(x: point.x-15,
                                               y: point.y-15),
                               size: CGSize(width: 30, height: 30))
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
        setupPointer()
        addSubview(pickedColorView)
        addSubview(pickedColorHashLabel)
        addSubview(brightnessSlider)
        addSubview(brightnessLabel)
        addSubview(doneButton)
    }
    
    private func setupPointer() {
        palette.addSubview(pointer)
        addSubview(palette)
    }
    
    func updatePickedColor (_ color: UIColor) {
        pickedColor = color
        pickedColorView.backgroundColor = pickedColor
        brightnessSlider.setValue(getBrightness(pickedColor), animated: false)
        setupPointer()
    }
    
    private func uiColorToHex(_ color: UIColor) -> String {
        var r:CGFloat = 0
        var g:CGFloat = 0
        var b:CGFloat = 0
        var a:CGFloat = 0

        color.getRed(&r, green: &g, blue: &b, alpha: &a)
        let rgb:Int = (Int)(r*255)<<16 | (Int)(g*255)<<8 | (Int)(b*255)<<0
        
        return String(format:"#%06x", rgb)
    }
    
    private func getBrightness(_ color: UIColor) -> Float {
        var b:CGFloat = 0
        pickedColor.getHue(nil, saturation: nil, brightness: &b, alpha: nil)
        return Float(b)
    }
    
}

