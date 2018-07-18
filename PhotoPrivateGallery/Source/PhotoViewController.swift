//
//  PhotoViewController.swift
//  PhotoPrivateGallery
//
//  Created by park sang pyo on 2018. 7. 12..
//  Copyright © 2018년 park sang pyo. All rights reserved.
//

import UIKit

class PhotoViewController: UIViewController {

    static let storyboardId = "photoViewController"
    var photo: Photo!
    let scrollView = UIScrollView()
    let imageView = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = 4.0
        scrollView.delegate = self

        scrollView.frame = self.view.frame

        self.view.addSubview(scrollView)
        self.scrollView.addSubview(imageView)
        
        var width = self.view.frame.width
        var height = width * photo.aspectRatio
        
        if height > self.view.frame.height {
            height = self.view.frame.height
            width = height / photo.aspectRatio
        }
        self.imageView.frame.size = CGSize(width: width, height: height)
        
        self.imageView.image = photo.uiImage
        
        updateContentInset()
        
    }
    
    func updateContentInset() {
        let heightInset = max((self.view.frame.height - imageView.frame.height) / 2, 0)
        let widthInset = max((self.view.frame.width - imageView.frame.width) / 2, 0)
        let contentInset = UIEdgeInsets(top: heightInset, left: widthInset, bottom: 0, right: 0)
        self.scrollView.contentInset = contentInset
    }

}

extension PhotoViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.imageView
    }

    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        updateContentInset()
    }
}
