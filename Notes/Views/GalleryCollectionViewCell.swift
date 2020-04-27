//
//  GalleryCollectionViewCell.swift
//  Notes
//
//  Created by Igor Podolskiy on 18/07/2019.
//  Copyright © 2019 Igor Podolskiy. All rights reserved.
//

import UIKit

class GalleryCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var imageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        imageView.layer.borderWidth = 1
        // Initialization code
    }

}
