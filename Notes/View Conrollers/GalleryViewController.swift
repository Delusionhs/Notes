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
    private var images: [UIImage] = [UIImage(named: "Foggy")!,
                                     UIImage(named: "MilkyWay")!,
                                     UIImage(named: "Rainbow")!,
                                     UIImage(named: "Star")!,
                                     UIImage(named: "Bridge")!,
                                     UIImage(named: "CityNight")!,
                                     UIImage(named: "CitySun")!]

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
            self.chooseImagePicker(source: .photoLibrary)
    }
}

extension GalleryViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = imageCollectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! GalleryCollectionViewCell
        cell.imageView.image = images[indexPath.row]
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showBigImage", sender: nil)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let controller = segue.destination as? GalleryBigImageViewController {
            controller.images = self.images
            if let indexPath = self.imageCollectionView.indexPathsForSelectedItems?.first {
                controller.page = indexPath.row
            }
            controller.hidesBottomBarWhenPushed = true
        }
    }
}

extension GalleryViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    func chooseImagePicker (source: UIImagePickerController.SourceType) {
        if UIImagePickerController.isSourceTypeAvailable(source) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.allowsEditing = true
            imagePicker.sourceType = source
            present(imagePicker, animated: true)
        }
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        if let image = info[.editedImage] as? UIImage {
            images.append(image)
        }
        imageCollectionView.reloadData()
        dismiss(animated: true, completion: nil)

    }
}
