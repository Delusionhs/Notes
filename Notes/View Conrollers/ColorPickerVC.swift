//
//  ColorPickerVC.swift
//  Notes
//
//  Created by Igor Podolskiy on 13/07/2019.
//  Copyright © 2019 Igor Podolskiy. All rights reserved.
//

import UIKit

class ColorPickerVC: UIViewController {
    
    @IBOutlet weak var colorPickerView: ColorPickerView!
    var sendedColor:UIColor = .white
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //colorPickerView.doneButton.addTarget(self, action: #selector(doneButtonAction), for: .touchUpInside)
        colorPickerView.updatePickedColor(sendedColor)
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Done", style: .plain, target: self, action:#selector(doneButtonAction))
    }
    
    @objc func doneButtonAction() {
       performSegue(withIdentifier: "unwindToData", sender: nil)
    }
}

