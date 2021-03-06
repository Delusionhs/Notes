//
//  GalleryBigImageViewController.swift
//  Notes
//
//  Created by Igor Podolskiy on 18/07/2019.
//  Copyright © 2019 Igor Podolskiy. All rights reserved.
//

import UIKit

class GalleryBigImageViewController: UIViewController {

    var images: [UIImage]?
    var page: Int = 0

    var scrollView = UIScrollView()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .black
        let scrollViewRect = view.bounds

        scrollView = UIScrollView(frame: scrollViewRect)
        scrollView.delegate = self
        scrollView.isPagingEnabled = true
        if let images = self.images {
            scrollView.contentSize = CGSize(width: scrollViewRect.size.width * CGFloat(images.count), height: scrollViewRect.size.height)
        }
        view.addSubview(scrollView)

        if let images = self.images, images.count > 0 {
            for imageName in images {
                addNewImageView(imageName: imageName)
            }
        }

        self.scrollToPage(page: self.page)
    }

    override func viewDidLayoutSubviews() {
        for subview in scrollView.subviews {
            subview.removeFromSuperview()
        }

        let scrollViewRect = view.bounds

        scrollView.frame = view.frame
        if let images = self.images {
            scrollView.contentSize = CGSize(width: scrollViewRect.size.width * CGFloat(images.count), height: scrollViewRect.size.height)
        }

        if let images = self.images, images.count > 0 {
            for imageName in images {
                addNewImageView(imageName: imageName)
            }
        }

        self.scrollToPage(page: self.page)
    }

    func addNewImageView(imageName: UIImage) {
        var imageViewRect = view.bounds
        let image = imageName

        imageViewRect.origin.x = imageViewRect.size.width * CGFloat(scrollView.subviews.count)

        let imageView = newImageViewWithImage(paramImage: image, paramFrame: imageViewRect)

        scrollView.addSubview(imageView)
    }

    func newImageViewWithImage(paramImage: UIImage, paramFrame: CGRect) -> UIImageView {
        let result = UIImageView(frame: paramFrame)

        result.contentMode = .scaleAspectFit
        result.image = paramImage

        return result
    }

    func scrollToPage(page: Int) {
        var frame: CGRect = self.scrollView.frame
        frame.origin.x = frame.size.width * CGFloat(page)
        frame.origin.y = 0
        self.scrollView.scrollRectToVisible(frame, animated: false)
    }

}

extension GalleryBigImageViewController: UIScrollViewDelegate {

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageWidth = scrollView.frame.size.width
        let page = Int(floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1)
        self.page = page
    }
}
