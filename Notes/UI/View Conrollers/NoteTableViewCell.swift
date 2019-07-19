//
//  NoteTableViewCell.swift
//  Notes
//
//  Created by Igor Podolskiy on 16/07/2019.
//  Copyright © 2019 Igor Podolskiy. All rights reserved.
//

import UIKit

class NoteTableViewCell: UITableViewCell {

    @IBOutlet weak var colorBox: UIView!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var dataLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        colorBox.layer.borderWidth = 1
        dataLabel.textColor = .lightGray
        // Initialization code
    }
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        colorBox.backgroundColor = colorBox.backgroundColor
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        let color = colorBox.backgroundColor
        super.setSelected(selected, animated: animated)
        
        if selected {
            colorBox.backgroundColor = color
        }
    }

}
