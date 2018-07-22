//
//  PhotoShowController.swift
//  PhotoPrivateGallery
//
//  Created by park sang pyo on 2018. 7. 22..
//  Copyright © 2018년 park sang pyo. All rights reserved.
//

import UIKit

class PhotoShowController: UIViewController {
    
    let photo: Photo
    let photoView = PhotoView()
    
    init(photo: Photo) {
        self.photo = photo
        self.photoView.image = photo.uiImage
        super.init(nibName: nil, bundle: nil)
        self.modalPresentationStyle = .overCurrentContext
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.clear
        self.view.isOpaque = false
                
        photoView.frame = view.frame
        self.view = photoView

        photoView.image = photo.uiImage
    }
    
}