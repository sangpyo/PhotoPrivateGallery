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
        guard let image = self.imageView.image else {
            return 0.5
        }
        
        var zoomScale: CGFloat = 0.5
        if image.size.width < self.frame.width && image.size.height < self.frame.height {
            zoomScale = 1.0
        } else {
            zoomScale = self.scrollView.frame.size.width / image.size.width

            let hScaled = image.size.height * zoomScale
            if hScaled > self.scrollView.frame.size.height {
                zoomScale = self.scrollView.frame.size.height / image.size.height
            }
        }
        
        return zoomScale
    }
    
    var maximumZoomScale: CGFloat {
        guard let image = self.imageView.image else {
            return 2.0
        }
        
        var zoomScale: CGFloat = minimumZoomScale * 2.0
        if image.size.width < self.frame.width && image.size.height < self.frame.height {
            zoomScale = fitZoomScale * 2.0
        } else {
            let wScale = image.size.width / self.scrollView.frame.width
            let hScale = image.size.height / self.scrollView.frame.height
            
            zoomScale = max(wScale, hScale)
            if zoomScale < 2.0 {
                zoomScale = 2.0
            }
        }

        return zoomScale
    }
    
    var fitZoomScale: CGFloat {
        guard let image = self.image else {
            return 1.0
            
        }
        
        var zoomScale = minimumZoomScale
        if image.size.width < self.frame.width && image.size.height < self.frame.height {
            zoomScale = self.scrollView.frame.size.width / image.size.width
            
            let hScaled = image.size.height * zoomScale
            if hScaled > self.scrollView.frame.size.height {
                zoomScale = self.scrollView.frame.size.height / image.size.height
            }
        }
        
        return zoomScale
    }
    
    override var frame: CGRect {
        didSet {
            self.updateSubviews()
        }
    }
    
    override var center: CGPoint {
        didSet {
            self.updateSubviews()
            self.scrollView.zoomScale = fitZoomScale
            self.scrollView.minimumZoomScale = minimumZoomScale
            self.scrollView.maximumZoomScale = maximumZoomScale
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
                self.containerView.frame.size = image.size
                self.scrollView.zoomScale = fitZoomScale
                self.scrollView.minimumZoomScale = minimumZoomScale
                self.scrollView.maximumZoomScale = maximumZoomScale
                centering()
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
        
        self.containerView.backgroundColor = UIColor.clear
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
        
        self.updateSubviews()
    }

    private func updateSubviews() {
        let rect = CGRect(origin: CGPoint.zero, size: self.frame.size)
        self.visualEffectView.frame = rect
        self.scrollView.frame = rect

        self.centering()
    }
    
    func centering() {
        let heightInset = max((self.scrollView.frame.height - self.containerView.frame.height) / 2, 0)
        let widthInset = max((self.scrollView.frame.width - self.containerView.frame.width) / 2, 0)
        let contentInset = UIEdgeInsets(top: heightInset, left: widthInset, bottom: heightInset, right: widthInset)
        self.scrollView.contentInset = contentInset
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

    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        
    }
}


