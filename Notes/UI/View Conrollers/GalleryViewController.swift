//
//  GalleryViewController.swift
//  Notes
//
//  Created by Igor Podolskiy on 18/07/2019.
//  Copyright © 2019 Igor Podolskiy. All rights reserved.
//

import UIKit

class GalleryViewController: UIViewController {
    
    @IBOutlet weak var imageCollectionView: UICollectionView!
    private var images: [String] = ["screen_1", "screen_2"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageCollectionView.delegate = self
        imageCollectionView.dataSource = self
        self.title = "Галерея"
        imageCollectionView.register(UINib(nibName: "GalleryCollectionViewCell", bundle: nil),
                                     forCellWithReuseIdentifier: "cell")
        imageCollectionView.contentInset = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20) // offset
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewImage(_:)))
    }
    
    @objc func addNewImage(_ sender: Any) {
    }
}

extension GalleryViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = imageCollectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! GalleryCollectionViewCell
        cell.imageView.image = UIImage(named: images[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showBigImage", sender: nil)
    }
}
