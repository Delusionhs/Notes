//
//  ViewController.swift
//  Notes
//
//  Created by Igor Podolskiy on 30/06/2019.
//  Copyright © 2019 Igor Podolskiy. All rights reserved.
//

import UIKit

protocol NoteEditViewControllerDelegate: class {
    func reviceNote(note: Note)
}

class NoteEditViewController: UIViewController {
    
    weak var delegate: NoteEditViewControllerDelegate?
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var destoyDateSwitch: UISwitch!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var datePickerHeight: NSLayoutConstraint!
    @IBOutlet weak var colorPickBox: ColorPickBox!
    @IBOutlet weak var whiteBox: ColorPickBox!
    @IBOutlet weak var redBox: ColorPickBox!
    @IBOutlet weak var greenBox: ColorPickBox!
    
    @IBOutlet weak var noteTitleText: UITextField!
    @IBOutlet weak var noteTextView: UITextView!
    
    var note: Note?
    
    var pickerdColor: UIColor = .white
    
    @IBAction func unwindToDataScreen (segue: UIStoryboardSegue) {
        guard segue.identifier == "unwindToData" else { return }
        guard let svc = segue.source as? ColorPickerVC else { return }
        colorPickBox.defaultColor = svc.colorPickerView.pickedColor
        pickerdColor = svc.colorPickerView.pickedColor
    }
    
    @IBAction func destroyDateValueChange(_ sender: UISwitch) {
        view.endEditing(true)
        pickerChangeVisible()
    }
    
    @IBAction func longPressCPButton(_ sender: UILongPressGestureRecognizer) {
        if (sender.state == .ended) {
        } else if (sender.state == .began) {
            performSegue(withIdentifier: "ShowColorPickerSegue", sender: self)
            clearMarks()
            colorPickBox.checkMarkAdd()
        }
    }
    
    @IBAction func greenBoxTapped(_ sender: UITapGestureRecognizer) {
        caseDefaultColor(color: .green)
    }
    
    @IBAction func whiteBoxTapped(_ sender: UITapGestureRecognizer) {
        caseDefaultColor(color: .white)
    }
    
    @IBAction func redBoxTapped(_ sender: UITapGestureRecognizer) {
        caseDefaultColor(color: .red)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        datePicker.isHidden = true
        whiteBox.checkMarkAdd()
        pickerdColor = whiteBox.defaultColor!
        if let note = self.note {
            noteTitleText.text = note.title
            noteTextView.text = note.content
            if let date = note.selfDestructionDate {
                destoyDateSwitch.isOn = true
                pickerChangeVisible()
                datePicker.date = date
            }
        caseDefaultColor(color: note.color)
        }
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(saveNote(_:)))
    }
    
    @objc func saveNote(_ sender: Any) {
        saveNote()
        navigationController?.popViewController(animated: true)
    }
    
    private func pickerChangeVisible() {
        datePicker.isHidden = !datePicker.isHidden
        changePickerHeight()
    }
    
    private func changePickerHeight() {
        if datePickerHeight.constant != 0 {
            datePickerHeight.constant = 0
        } else {
            let dataPickerHeight:CGFloat = 216.0
            datePickerHeight.constant = dataPickerHeight
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        registerNotifications()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        unregisterNotifications()
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowColorPickerSegue",
            let destinationVC = segue.destination as? ColorPickerVC {
            if let color = colorPickBox.defaultColor {
                destinationVC.sendedColor = color
            }
        }
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
    
    private func saveNote() {
        if let note = self.note {
            let newNote: Note? = Note(uid: note.uid,
                                      title: noteTitleText.text!,
                                      content: noteTextView.text!,
                                      color: pickerdColor,
                                      importance: note.importance,
                                      selfDestructionDate: destoyDateSwitch.isOn == true ? datePicker.date : nil)
            delegate?.reviceNote(note: newNote!)
        } else {
            let newNote: Note? = Note(
                                      title: noteTitleText.text!,
                                      content: noteTextView.text!,
                                      color: pickerdColor,
                                      importance: Importance.ordinary,
                                      selfDestructionDate: destoyDateSwitch.isOn == true ? datePicker.date : nil)
            delegate?.reviceNote(note: newNote!)
        }
    }
    
    private func caseDefaultColor (color: UIColor) {
        clearMarks()
        switch color {
        case UIColor.white:
            whiteBox.checkMarkAdd()
            pickerdColor = color
        case UIColor.red:
            redBox.checkMarkAdd()
            pickerdColor = color
        case UIColor.green:
            greenBox.checkMarkAdd()
            pickerdColor = color
        default:
            colorPickBox.checkMarkAdd()
            colorPickBox.defaultColor = color
            pickerdColor = color
        }
    }
}
