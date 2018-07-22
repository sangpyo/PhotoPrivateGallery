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

    
    override func viewDidAppear(_ animated: Bool) {

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
    
    private func popupPhoto() {
        //UIViewPropertyAnimator(duration: 1.5, dampingRatio: 1.0) {
        UIViewPropertyAnimator(duration: 0.3, curve: .easeIn) {
            
        }.startAnimation()
    }

    @IBAction func handlePopupPhoto(_ sender: UIButton) {
        let cell = sender.superview!.superview! as! UICollectionViewCell
        if let index = self.collectionView?.indexPath(for: cell) {
            let photo = photoGallery.photoAt(index.row)!
            let photoShow = PhotoShowController(photo: photo)
            self.present(photoShow, animated: true) {

            }
        }
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
