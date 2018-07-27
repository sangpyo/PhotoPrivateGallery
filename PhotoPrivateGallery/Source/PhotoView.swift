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
    
    var marginRatio: CGFloat = 0.1 {
        willSet {
            if newValue > 0.3 {
                self.marginRatio = 0.2
            } else if newValue < 0.0 {
                self.marginRatio = 0.0
            }
        }
        didSet {
            
        }
    }
    
    var properImageViewSize: CGSize? {
        guard let image = self.imageView.image else {
            return nil
        }
        guard image.size != CGSize.zero else {
            return nil
        }
        guard self.frame.size != CGSize.zero else {
            return nil
        }
        var width = self.frame.width
        var height = width * image.aspectRatio
        
        if height > self.frame.height {
            height = self.frame.height
            width = height / image.aspectRatio
        }
        return CGSize(width: width * (1 - marginRatio), height: height * (1 - marginRatio))
    }
    
    var minimumZoomScale: CGFloat? {
        guard let image = self.imageView.image else {
            return nil
        }
        guard image.size != CGSize.zero else {
            return nil
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
    
    var maximumZoomScale: CGFloat? {
        guard let image = self.imageView.image else {
            return nil
        }
        guard let minimumZoomScale = self.minimumZoomScale else {
            return nil
        }
        guard self.scrollView.frame.size != CGSize.zero else {
            return nil
        }
        
        var zoomScale: CGFloat = minimumZoomScale * 2.0
        if image.size.width < self.frame.width && image.size.height < self.frame.height {
            zoomScale = minimumZoomScale * 2.0
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
    
    var fitZoomScale: CGFloat? {
        guard let image = self.image else {
            return nil
        }
        guard image.size != CGSize.zero else {
            return nil
        }
        
        var zoomScale: CGFloat = 1.0
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
        }
    }
    
    override func layoutSubviews() {
        self.updateSubviews()
    }
    
    var image: UIImage? {
        set {
            self.imageView.image = newValue
            if let properImageViewSize = self.properImageViewSize {
                self.imageView.frame.size = properImageViewSize
                self.scrollView.contentSize = properImageViewSize
            }
            updateSubviews()
        }
        get {
            return self.imageView.image
        }
    }
    
    convenience init(image: UIImage) {
        self.init(frame: CGRect.zero)
        self.setup()
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
        
        self.scrollView.backgroundColor = UIColor.clear
        self.backgroundColor = UIColor.clear
        
        self.addSubview(self.visualEffectView)
        self.addSubview(self.scrollView)
        self.scrollView.addSubview(self.imageView)
        
        self.visualEffectView.effect = UIBlurEffect(style: .regular)

        self.scrollView.delegate = self
        self.scrollView.panGestureRecognizer.allowedTouchTypes = [UITouch.TouchType.direct.rawValue as NSNumber]
        self.scrollView.pinchGestureRecognizer?.allowedTouchTypes = [UITouch.TouchType.direct.rawValue as NSNumber]
        self.imageView.isUserInteractionEnabled = true

        self.imageView.contentMode = .scaleAspectFit
    }

    private func updateSubviews() {
        guard self.frame.size != CGSize.zero else {
            return
        }
        
        let rect = CGRect(origin: CGPoint.zero, size: self.frame.size)
        self.visualEffectView.frame = rect
        self.scrollView.frame = rect
        
        self.scrollView.zoomScale = 1.0 //fitZoomScale
        self.scrollView.minimumZoomScale = 1.0 //minimumZoomScale
        self.scrollView.maximumZoomScale = 2.0 //maximumZoomScale
        self.centering()
    }
    
    func centering() {
    
        let heightInset = max((self.scrollView.frame.height - self.imageView.frame.height) / 2, 0)
        let widthInset = max((self.scrollView.frame.width - self.imageView.frame.width) / 2, 0)
        let contentInset = UIEdgeInsets(top: heightInset, left: widthInset, bottom: 0, right: 0)
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
        
    }
    
    func scrollViewDidChangeAdjustedContentInset(_ scrollView: UIScrollView) {
        print("\(scrollView)")
    }
}


