//
//  PhotoPageViewController.swift
//  PhotoPrivateGallery
//
//  Created by park sang pyo on 2018. 7. 12..
//  Copyright © 2018년 park sang pyo. All rights reserved.
//

import UIKit
import Photos

class PhotoPageViewController: UIPageViewController {

    weak var photoGallery: PhotoGallery!
    var initialIndex: Int = 0
    
    @IBAction func didTouchUpSave(_ sender: UIBarButtonItem) {
        let photo = currentViewController().photo!
        
        //UIImageWriteToSavedPhotosAlbum(photo.uiImage, self, #selector(imageSaved(_:didFinishSavingWithError:contextInfo:)), nil)
        
        PHPhotoLibrary.requestAuthorization { (status) in
            
        }
        
        let result = PHAssetCollection.fetchTopLevelUserCollections(with: nil)
    }
    
    @objc func imageSaved(_ image: UIImage, didFinishSavingWithError error: NSError?, contextInfo: UnsafeRawPointer) {
        if (error != nil) {
            // Something wrong happened.
        } else {
            // Everything is alright.
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.dataSource = photoGallery

        let startingViewController: PhotoViewController = photoGallery.photoGallaryViewControllerAt(index: initialIndex, storyboard: self.storyboard!)!
        
        self.setViewControllers([startingViewController], direction: .forward, animated: true) { (done) in
            
        }
    }
    
    func currentViewController() -> PhotoViewController {
        let viewController = self.viewControllers!.first! as! PhotoViewController
        return viewController
    }

}
