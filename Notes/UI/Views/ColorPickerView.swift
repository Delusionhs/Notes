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
        doneButton.frame = CGRect(origin: CGPoint(x: palette.frame.maxX-doneButtonSize.width-12,
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

@IBDesignable
class Pointer: UIView {
    
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
            let radius = (frame.size.width - 10)/2
            context.addArc(center: center, radius: radius, startAngle: 0.0, endAngle: .pi * 2.0, clockwise: true)
            context.strokePath()
        }
    }
    
}


