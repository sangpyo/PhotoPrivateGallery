//
//  PhotoView.swift
//  PhotoPrivateGallery
//
//  Created by park sang pyo on 2018. 7. 20..
//  Copyright © 2018년 park sang pyo. All rights reserved.
//

import UIKit

class PhotoView: UIView {

    private let visualEffectView = UIVisualEffectView()
    private let scrollView = UIScrollView()
    private let imageView = UIImageView()
    
    var baseMargin = CGFloat(44.0) {
        didSet {
            
        }
    }
    
    override var frame: CGRect {
        didSet {
            super.frame = frame
            self.updateSubviews()
        }
    }
    
    var image: UIImage? {
        set {
            self.imageView.image = newValue
            if nil != newValue {
                //scrollView.contentSize = self.frame.size
            }
        }
        get {
            return self.imageView.image
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setup()
    }
    
    private func setup() {
        
        self.scrollView.backgroundColor = UIColor.clear
        self.backgroundColor = UIColor.clear
        
        self.addSubview(self.visualEffectView)
        self.addSubview(self.scrollView)
        self.scrollView.addSubview(self.imageView)
        
        self.visualEffectView.effect = UIBlurEffect(style: .regular)

        self.scrollView.minimumZoomScale = 1.0
        self.scrollView.maximumZoomScale = 4.0
        self.scrollView.delegate = self
        self.scrollView.panGestureRecognizer.allowedTouchTypes = [UITouch.TouchType.direct.rawValue as NSNumber]
        self.scrollView.pinchGestureRecognizer?.allowedTouchTypes = [UITouch.TouchType.direct.rawValue as NSNumber]
        self.imageView.isUserInteractionEnabled = true

        self.imageView.contentMode = .scaleAspectFit
        
        self.updateSubviews()
    }

    func updateProperMaximumZoom() {
        guard let image = self.image else {
            return
        }
        var width = self.scrollView.frame.width
        var height = width * image.aspectRatio
        
        if height > self.scrollView.frame.height {
            height = self.scrollView.frame.height
            width = height / image.aspectRatio
        }
    }
    
    override func layoutSubviews() {
        self.updateSubviews()
    }
    
    private func updateSubviews() {
//        let containerOrigin = CGPoint(x: baseMargin / 2, y: baseMargin / 2)
//        let containerSize = CGSize(width: frame.size.width - baseMargin, height: frame.size.height - baseMargin)
//
//        containerView.frame = CGRect(origin: containerOrigin, size: containerSize)
//        imageView.frame = CGRect(origin: CGPoint.zero, size: containerSize)
        
        let rect = CGRect(origin: CGPoint.zero, size: self.frame.size)
        self.visualEffectView.frame = rect
        self.scrollView.frame = rect
        
        if let image = self.imageView.image {
            let width = self.scrollView.frame.width
            let height = width * image.aspectRatio
            let imageRect = CGRect(origin: CGPoint.zero, size: CGSize(width: width, height: height))
            self.imageView.frame = imageRect
        }
        
        self.centering()
    }
    
    func centering() {
        let heightInset = max((self.scrollView.frame.height - self.imageView.frame.height) / 2, 0) + self.baseMargin / 2
        let widthInset = max((self.scrollView.frame.width - self.imageView.frame.width) / 2, 0) + self.baseMargin / 2
        let contentInset = UIEdgeInsets(top: heightInset, left: widthInset, bottom: heightInset, right: widthInset)
        self.scrollView.contentInset = contentInset
    }

}

extension PhotoView: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.imageView
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        centering()
    }
    
    func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
        print("\(scale)")
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        scrollView.con
    }
}


