//
//  GalleryBigImageViewController.swift
//  Notes
//
//  Created by Igor Podolskiy on 18/07/2019.
//  Copyright © 2019 Igor Podolskiy. All rights reserved.
//

import UIKit

class GalleryBigImageViewController: UIViewController {
    
    var images: [String]?
    
    var scrollView = UIScrollView()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let scrollViewRect = view.bounds
        
        scrollView = UIScrollView(frame: scrollViewRect)
        scrollView.isPagingEnabled = true
        scrollView.contentSize = CGSize(width: scrollViewRect.size.width * 3, height: scrollViewRect.size.height)
        view.addSubview(scrollView)
        
        if let images = self.images {
            for imageName in images {
                addNewImageView(imageName: imageName)
            }
        }
        // Do any additional setup after loading the view.
    }
    
    func addNewImageView(imageName: String) {
        var imageViewRect = view.bounds
        let image = UIImage(named: imageName)
        
        imageViewRect.origin.x = imageViewRect.size.width * CGFloat(scrollView.subviews.count)
        
        let imageView = newImageViewWithImage(paramImage: image!, paramFrame: imageViewRect)
        
        scrollView.addSubview(imageView)
    }
    
    func newImageViewWithImage(paramImage: UIImage, paramFrame: CGRect) -> UIImageView {
        let result = UIImageView(frame: paramFrame)
        
        result.contentMode = .scaleAspectFit
        result.image = paramImage
        
        return result
    }


}
