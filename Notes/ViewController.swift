//
//  ViewController.swift
//  Notes
//
//  Created by Igor Podolskiy on 30/06/2019.
//  Copyright © 2019 Igor Podolskiy. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var destoyDateSwitch: UISwitch!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var datePickerHeight: NSLayoutConstraint!
    @IBOutlet weak var colorPickBox: ColorPickBox!
    @IBOutlet weak var whiteBox: ColorPickBox!
    @IBOutlet weak var redBox: ColorPickBox!
    @IBOutlet weak var greenBox: ColorPickBox!
    
    var pickerdColor: UIColor = .white
    
    @IBAction func unwindToDataScreen (segue: UIStoryboardSegue) {
        guard segue.identifier == "unwindToData" else { return }
        guard let svc = segue.source as? ColorPickerVC else { return }
        colorPickBox.defaultColor = svc.colorPickerView.pickedColor
    }
    
    @IBAction func destroyDateValueChange(_ sender: UISwitch) {
        view.endEditing(true)
        pickerChangeVisible()
    }
    @IBAction func longPressCPButton(_ sender: UILongPressGestureRecognizer) {
        clearMarks()
        colorPickBox.checkMarkAdd()
        let controller = storyboard?.instantiateViewController(withIdentifier: "ColorPickerVC")
        self.present(controller!, animated: true, completion: nil)
        
    }
    
    @IBAction func greenBoxTapped(_ sender: UITapGestureRecognizer) {
        clearMarks()
        greenBox.checkMarkAdd()
        pickerdColor = greenBox.defaultColor!
    }
    
    @IBAction func whiteBoxTapped(_ sender: UITapGestureRecognizer) {
        clearMarks()
        whiteBox.checkMarkAdd()
        pickerdColor = whiteBox.defaultColor!
    }
    
    @IBAction func redBoxTapped(_ sender: UITapGestureRecognizer) {
        clearMarks()
        redBox.checkMarkAdd()
        pickerdColor = redBox.defaultColor!
    }
    
    private func pickerChangeVisible() {
        datePicker.isHidden = datePicker.isHidden
        if datePickerHeight.constant != 0 {
            datePickerHeight.constant = 0
            scrollView.contentInset.bottom = 0
        } else {
            let dataPickerHeight:CGFloat = 216.0
            datePickerHeight.constant = dataPickerHeight
            scrollView.contentInset.bottom = dataPickerHeight
        }
    }
    
    //private var datePicker: UIDatePicker?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        //pickerChangeVisible()
        
        //datePicker = UIDatePicker()
        //datePicker?.datePickerMode = .date
        //self.view.addSubview(datePicker!)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        registerNotifications()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        unregisterNotifications()
    }
    
    
    private func registerNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func unregisterNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        scrollView.contentInset.bottom = 0
    }
    
    @objc private func keyboardWillShow(notification: NSNotification){
        guard let keyboardFrame = notification.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        scrollView.contentInset.bottom = view.convert(keyboardFrame.cgRectValue, from: nil).size.height
    }
    
    @objc private func keyboardWillHide(notification: NSNotification){
        scrollView.contentInset.bottom = 0
    }
    
    private func clearMarks() {
        redBox.deleteCheckMark()
        greenBox.deleteCheckMark()
        whiteBox.deleteCheckMark()
        colorPickBox.deleteCheckMark()
    }
}

