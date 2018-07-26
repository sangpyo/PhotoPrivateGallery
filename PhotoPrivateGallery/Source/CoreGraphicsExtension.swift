//
//  CoreGraphicsExtension.swift
//  PhotoPrivateGallery
//
//  Created by park sang pyo on 2018. 7. 26..
//  Copyright © 2018년 park sang pyo. All rights reserved.
//

import Foundation
import CoreImage

func +(left: CGSize, right: CGFloat) -> CGSize {
    return CGSize(width: left.width + right, height: left.height + right)
}

func -(left: CGSize, right: CGFloat) -> CGSize {
    return left + (-1.0 * right)
}
