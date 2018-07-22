//
//  ViewController.swift
//  PhotoPrivateGallery
//
//  Created by park sang pyo on 2018. 7. 22..
//  Copyright © 2018년 park sang pyo. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    let photoGallery = PhotoGallery(photoFolderName: PhotoGalleryViewController.photoFolderName)

    var photo: Photo!
    let photoView = PhotoView()
    
    init(photo: Photo) {
        self.photo = photo
        //self.photoView.image = photo.uiImage
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let photo = photoGallery.photoAt(6)!
        let photoShow = PhotoShowController(photo: photo)
        self.providesPresentationContextTransitionStyle = true
        self.definesPresentationContext = true
        self.modalPresentationStyle = .overCurrentContext
        self.present(photoShow, animated: true) {
            photoShow.view.backgroundColor = UIColor.clear
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        _ = photoGallery.fetchPhotos()
        self.view.backgroundColor = UIColor.clear
        self.view.isOpaque = false
        
        let imageView = UIImageView(image: photoGallery.photoAt(10)!.uiImage)

        self.view.addSubview(imageView)
        imageView.frame = self.view.frame

        //self.view.addSubview(photoView)
        //photoView.frame = view.frame
        //photoView.image = photo.uiImage
        //self.view = photoView


    }
    

}
