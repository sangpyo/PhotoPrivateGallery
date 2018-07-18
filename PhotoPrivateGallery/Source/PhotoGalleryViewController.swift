//
//  PhotoGalleryViewController.swift
//  PhotoPrivateGallery
//
//  Created by park sang pyo on 2018. 7. 12..
//  Copyright © 2018년 park sang pyo. All rights reserved.
//

import UIKit

class PhotoGalleryViewController: UICollectionViewController {

    static let photoFolderName = "Photos"
    let photoGallery = PhotoGallery(photoFolderName: PhotoGalleryViewController.photoFolderName)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let layout = self.collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.minimumInteritemSpacing = 0.2
        layout.minimumLineSpacing = 1.0
        
        _ = photoGallery.fetchPhotos()
        
        self.collectionView.dataSource = photoGallery

    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let viewController = segue.destination as! PhotoPageViewController
        
        let indexPath = self.collectionView.indexPathsForSelectedItems!.first!
        viewController.initialIndex = indexPath.row
        viewController.photoGallery = self.photoGallery
        
    }

}

extension PhotoGalleryViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        guard let viewLayout = collectionViewLayout as? UICollectionViewFlowLayout else {
            return CGSize()
        }
        let columns = 3
        let columnSpace = viewLayout.minimumInteritemSpacing * CGFloat(columns - 1)
        
        let width = (collectionView.frame.width) / CGFloat(columns) - columnSpace
        let height = width
        return CGSize(width: width, height: height)
    }
}
