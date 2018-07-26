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
    private let containerView = UIView()
    private let imageView = UIImageView()
    
    var baseMargin = CGFloat(44.0) {
        didSet {
            centering()
        }
    }
    
    var minimumZoomScale: CGFloat {
//        guard let image = self.imageView.image else {
//            return 0.5
//        }
        
        var zoomScale: CGFloat = 0.5
//        if image.size.width < self.frame.width && image.size.height < self.frame.height {
//            zoomScale = 1.0
//        } else {
//            zoomScale = self.scrollView.frame.size.width / image.size.width
//
//            let hScaled = image.size.height * zoomScale
//            if hScaled > self.scrollView.frame.size.height {
//                zoomScale = self.scrollView.frame.size.height / image.size.height
//            }
//        }
        
        if containerView.frame.size.width < self.frame.width && containerView.frame.size.height < self.frame.height {
            zoomScale = 1.0
        } else {
            zoomScale = self.scrollView.frame.size.width / containerView.frame.size.width
            
            let hScaled = containerView.frame.size.height * zoomScale
            if hScaled > self.scrollView.frame.size.height {
                zoomScale = self.scrollView.frame.size.height / containerView.frame.size.height
            }
        }
        
        return zoomScale
    }
    
    var maximumZoomScale: CGFloat {
//        guard let image = self.imageView.image else {
//            return 2.0
//        }
        
        var zoomScale: CGFloat = minimumZoomScale * 2.0
//        if image.size.width < self.frame.width && image.size.height < self.frame.height {
//            zoomScale = fitZoomScale * 2.0
//        } else {
//            let wScale = image.size.width / self.scrollView.frame.width
//            let hScale = image.size.height / self.scrollView.frame.height
//
//            zoomScale = max(wScale, hScale)
//            if zoomScale < 2.0 {
//                zoomScale = 2.0
//            }
//        }
        
        if containerView.frame.size.width < self.frame.width && containerView.frame.size.height < self.frame.height {
            zoomScale = fitZoomScale * 2.0
        } else {
            let wScale = containerView.frame.size.width / self.scrollView.frame.width
            let hScale = containerView.frame.size.height / self.scrollView.frame.height
            
            zoomScale = max(wScale, hScale)
            if zoomScale < 2.0 {
                zoomScale = 2.0
            }
        }

        return zoomScale
    }
    
    var fitZoomScale: CGFloat {
//        guard let image = self.image else {
//            return 1.0
//
//        }
        
        var zoomScale = minimumZoomScale
//        if image.size.width < self.frame.width && image.size.height < self.frame.height {
//            zoomScale = self.scrollView.frame.size.width / image.size.width
//
//            let hScaled = image.size.height * zoomScale
//            if hScaled > self.scrollView.frame.size.height {
//                zoomScale = self.scrollView.frame.size.height / image.size.height
//            }
//        }
        if containerView.frame.size.width < self.frame.width && containerView.frame.size.height < self.frame.height {
            zoomScale = self.scrollView.frame.size.width / containerView.frame.size.width
            
            let hScaled = containerView.frame.size.height * zoomScale
            if hScaled > self.scrollView.frame.size.height {
                zoomScale = self.scrollView.frame.size.height / containerView.frame.size.height
            }
        }
        return zoomScale
    }
    
    override var frame: CGRect {
        didSet {
            self.updateSubviews()
             print("fr - \(self.containerView.frame) \(self.scrollView.frame)")
        }
    }
    
    override var center: CGPoint {
        didSet {
            self.updateSubviews()
            self.scrollView.zoomScale = fitZoomScale
            self.scrollView.minimumZoomScale = minimumZoomScale
            self.scrollView.maximumZoomScale = maximumZoomScale
             print("ct - \(self.containerView.frame) \(self.scrollView.frame)")
        }
    }
    
    override func layoutSubviews() {
        self.updateSubviews()
    }
    
    var image: UIImage? {
        set {
            self.imageView.image = newValue
            if let image = newValue {
                self.imageView.frame.size = image.size
                self.containerView.frame.origin = CGPoint.zero
                self.containerView.frame.size = image.size
                self.scrollView.zoomScale = fitZoomScale
                self.scrollView.minimumZoomScale = minimumZoomScale
                self.scrollView.maximumZoomScale = maximumZoomScale
                centering()
                print("im - \(self.containerView.frame) \(self.scrollView.frame) \(image.size)")
            }
        }
        get {
            return self.imageView.image
        }
    }
    
    convenience init(image: UIImage) {
        self.init(frame: CGRect.zero)
        self.image = image
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
        
        let flexibleDimensions: UIView.AutoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.scrollView.autoresizingMask = flexibleDimensions
        
        self.containerView.backgroundColor = UIColor.lightGray
        self.scrollView.backgroundColor = UIColor.clear
        self.backgroundColor = UIColor.clear
        
        self.addSubview(self.visualEffectView)
        self.addSubview(self.scrollView)
        self.scrollView.addSubview(self.containerView)
        self.containerView.addSubview(self.imageView)
        
        self.visualEffectView.effect = UIBlurEffect(style: .regular)

        self.scrollView.delegate = self
        self.scrollView.panGestureRecognizer.allowedTouchTypes = [UITouch.TouchType.direct.rawValue as NSNumber]
        self.scrollView.pinchGestureRecognizer?.allowedTouchTypes = [UITouch.TouchType.direct.rawValue as NSNumber]
        self.imageView.isUserInteractionEnabled = true

        self.imageView.contentMode = .scaleAspectFit
        
        let v = UIView(frame: CGRect(x: 60, y: 60, width: 100, height: 100))
        v.backgroundColor = UIColor.red
        self.containerView.addSubview(v)
        self.containerView.frame = CGRect(x: 0, y: 0, width: 1000, height: 1000)
        
        self.updateSubviews()
    }

    private func updateSubviews() {
        let rect = CGRect(origin: CGPoint.zero, size: self.frame.size)
        self.visualEffectView.frame = rect
        self.scrollView.frame = rect
        
        self.scrollView.zoomScale = fitZoomScale
        self.scrollView.minimumZoomScale = minimumZoomScale
        self.scrollView.maximumZoomScale = maximumZoomScale
        
        if let image = self.image {
            self.containerView.frame = CGRect(origin: CGPoint.zero, size: image.size + self.baseMargin * 2)
            self.imageView.frame.origin = CGPoint(x: self.baseMargin, y: self.baseMargin)
        }

        self.centering()
        
        print("us - \(self.containerView.frame) \(self.scrollView.frame)")
    }
    
    func centering() {
        let heightInset = max((self.scrollView.frame.height - self.containerView.frame.height) / 2, 0)
        let widthInset = max((self.scrollView.frame.width - self.containerView.frame.width) / 2, 0)
        let contentInset = UIEdgeInsets(top: heightInset, left: widthInset, bottom: heightInset, right: widthInset)
        self.scrollView.contentInset = contentInset
        print("centering \(print("ct - \(self.containerView.frame) \(self.scrollView.frame)"))")
    }

}

extension PhotoView: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.containerView
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        centering()
    }
    
    func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
        print("scale \(scale)\n  \(view!.frame) \(self.containerView.frame) \(self.imageView.frame)")
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        
    }
}


