//
//  PageViewController.swift
//  TagIt
//
//  Created by 신재혁 on 16/02/2019.
//  Copyright © 2019 ninetyfivejae. All rights reserved.
//

import UIKit
import Photos

class PageViewController: UIPageViewController {
    
    var fetchResult: PHFetchResult<PHAsset>!
    var assetCollection: PHAssetCollection!

    var photos = ["photo1", "photo2", "photo3", "photo4", "photo5"]
    var currentIndex: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource = self
        
        // 1
        if let viewController = viewZoomedPhotoViewController(currentIndex ?? 0) {
            let viewControllers = [viewController]
            // 2
            setViewControllers(viewControllers, direction: .forward, animated: false, completion: nil)
        }
    }
    
    func viewZoomedPhotoViewController(_ index: Int) -> ZoomedPhotoViewController? {
        if let storyboard = storyboard,
            let page = storyboard.instantiateViewController(withIdentifier: "ZoomedPhotoViewController") as? ZoomedPhotoViewController {
            page.photoName = photos[index]
            page.photoIndex = index
            return page
        }
        return nil
    }
}

//MARK: implementation of UIPageViewControllerDataSource
extension PageViewController: UIPageViewControllerDataSource {
    // 1
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        if let viewController = viewController as? ZoomedPhotoViewController, let index = viewController.photoIndex, index > 0 {
            return viewZoomedPhotoViewController(index - 1)
        }
        
        return nil
    }
    
    // 2
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        if let viewController = viewController as? ZoomedPhotoViewController, let index = viewController.photoIndex, (index + 1) < photos.count {
            return viewZoomedPhotoViewController(index + 1)
        }
        
        return nil
    }
    
    // MARK: UIPageControl
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return photos.count
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        return currentIndex ?? 0
    }
}
