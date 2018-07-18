//
//  Photo.swift
//  PhotoPrivateGallery
//
//  Created by park sang pyo on 2018. 6. 30..
//  Copyright © 2018년 park sang pyo. All rights reserved.
//

import Foundation
import UIKit
import CoreImage

extension CIImage {
    var aspectRatio: CGFloat {
        let imageWidth: CGFloat = self.extent.size.width
        let imageHeight: CGFloat = self.extent.size.height
        let aspectRatio = imageHeight / imageWidth
        return aspectRatio
    }
    
    func scaleTo(_ scale: CGFloat) -> CIImage
    {
        let parameters = [kCIInputScaleKey: scale, kCIInputAspectRatioKey: aspectRatio]
        let scaledImage = self.applyingFilter("CILanczosScaleTransform", parameters: parameters)
        return scaledImage
    }
}

extension CGImage {
    var aspectRatio: CGFloat {
        let imageWidth: CGFloat = CGFloat(self.width)
        let imageHeight: CGFloat = CGFloat(self.height)
        let aspectRatio =  imageHeight / imageWidth
        return aspectRatio
    }
    
    func scaleTo(_ scale: CGFloat) -> CGImage? {
        let ciImage = CIImage(cgImage: self)
        let scaledCIImage = ciImage.scaleTo(scale)
        let context = CIContext()
        let rect = scaledCIImage.extent
        let scaledCGImage = context.createCGImage(scaledCIImage, from: rect)
        return scaledCGImage
    }
}

struct Photo {
    let originalImage: CGImage
    let photoPathURL: URL
    
    var aspectRatio: CGFloat {
        return originalImage.aspectRatio
    }

    var uiImage: UIImage {
        return UIImage(cgImage: self.originalImage)
    }
    var size: CGSize {
        return CGSize(width: originalImage.width, height: originalImage.height)
    }
    
    func height(forWidth: CGFloat) -> CGFloat {
        let aspectRatio = self.originalImage.aspectRatio
        // aspectRatio = width / height
        // aspectRatio * height = width
        // height = width / aspectRatio
        let height = forWidth * aspectRatio
        return height
    }
    
    func scaledCGImage(to scale: CGFloat) -> CGImage {
        return self.originalImage.scaleTo(scale)!
    }
    
    init?(photoPathURL: URL) {
        guard let imageSource = CGImageSourceCreateWithURL(photoPathURL as CFURL, nil) else {
            return nil
        }
        guard let cgImage = CGImageSourceCreateImageAtIndex(imageSource, 0, nil) else {
            return nil
        }
        self.originalImage = cgImage
        self.photoPathURL = photoPathURL
    }
}

extension Photo: Equatable {
    static func == (lhs: Photo, rhs: Photo) -> Bool {
        return lhs.photoPathURL == rhs.photoPathURL
    }
}
