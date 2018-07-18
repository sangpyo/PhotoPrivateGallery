//
//  PhotoGallery.swift
//  PhotoPrivateGallery
//
//  Created by park sang pyo on 2018. 7. 12..
//  Copyright © 2018년 park sang pyo. All rights reserved.
//

import UIKit

class PhotoGallery: NSObject {
    private var photos = [Photo]()
    let photoGalleryPathURL: URL
    
    init(photoGalleryPathURL: URL) {
        self.photoGalleryPathURL = photoGalleryPathURL
        
        print("\(photoGalleryPathURL)")
    }
    
    init(photoFolderName: String) {
        let path = FileManager.default.urls(for: FileManager.SearchPathDirectory.documentDirectory , in: FileManager.SearchPathDomainMask.userDomainMask).first!
        let photoPathURL = path.appendingPathComponent(photoFolderName)
        self.photoGalleryPathURL = photoPathURL
        
        print("\(photoGalleryPathURL)")
    }
    
    func fetchPhotos() -> Int {
        guard let photoURLs = try? FileManager.default.contentsOfDirectory(at: self.photoGalleryPathURL,
                                                                           includingPropertiesForKeys: nil,
                                                                           options:[]) else {
                                                                            return 0
        }

        var photos = [Photo]()
        for url in photoURLs {
            guard let photo = Photo(photoPathURL: url) else {
                continue
            }
            photos.append(photo)
        }
        self.photos = photos
        
        return self.photos.count
    }

    func photoGallaryViewControllerAt(index: Int, storyboard: UIStoryboard) -> PhotoViewController? {
        guard self.photos.count >= self.photos.startIndex, index < self.photos.endIndex else {
            return nil
        }
        
        let viewController = storyboard.instantiateViewController(withIdentifier: PhotoViewController.storyboardId) as! PhotoViewController
        viewController.photo = self.photos[index]
        return viewController
    }
    
    func indexOfViewController(_ viewController: PhotoViewController) -> Int {
        return self.photos.index(of: viewController.photo) ?? NSNotFound
    }
    
    func photoAt(_ index: Int) -> Photo? {
        return self.photos[index]
    }
}

extension PhotoGallery: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        var index = self.indexOfViewController(viewController as! PhotoViewController)
        if index == NSNotFound {
            return nil
        }
        
        if index == 0 {
            index = self.photos.endIndex - 1
        } else {
            index -= 1
        }
        
        return self.photoGallaryViewControllerAt(index: index, storyboard: viewController.storyboard!)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        var index = self.indexOfViewController(viewController as! PhotoViewController)
        if index == NSNotFound {
            return nil
        }
        
        if index == self.photos.endIndex - 1 {
            index = 0
        } else {
            index += 1
        }
        
        return self.photoGallaryViewControllerAt(index: index, storyboard: viewController.storyboard!)
    }
}

extension PhotoGallery: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {

        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        return self.photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoViewCell.reuseIdentifier, for: indexPath) as! PhotoViewCell
        
        cell.imageView.frame.size = cell.frame.size
        cell.imageView.contentMode = .scaleAspectFill
        cell.imageView.image = self.photos[indexPath.row].uiImage

        return cell
    }
    
    
}
