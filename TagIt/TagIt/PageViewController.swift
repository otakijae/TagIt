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
    var selectedPhotoIndex: IndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        dataSource = self
        
        if let viewController = viewZoomedPhotoViewController(selectedPhotoIndex?.row ?? 0) {
            let viewControllers = [viewController]
            setViewControllers(viewControllers, direction: .forward, animated: false, completion: nil)
        }
    }
    
//    var targetSize: CGSize {
//        let scale = UIScreen.main.scale
//        print(view.bounds)
//        return CGSize(width: view.bounds.width * scale, height: view.bounds.height * scale)
//    }
//
//    var targetSizeTest: CGSize {
//        let scale = UIScreen.main.scale
//        return CGSize(width: PHImageManagerMaximumSize.width, height: PHImageManagerMaximumSize.height)
////        return CGSize(width: 1024, height: 768)
//    }
    
    func viewZoomedPhotoViewController(_ index: Int) -> ZoomedPhotoViewController? {
        if let storyboard = storyboard,
            let page = storyboard.instantiateViewController(withIdentifier: "ZoomedPhotoViewController") as? ZoomedPhotoViewController {
            
            let requestOptions = PHImageRequestOptions()
            requestOptions.isSynchronous = true
            requestOptions.deliveryMode = .highQualityFormat
            requestOptions.isNetworkAccessAllowed = true
            requestOptions.resizeMode = .exact
            
            let asset: PHAsset = self.fetchResult.object(at: index)
            PHImageManager.default().requestImage(for: asset, targetSize: PHImageManagerMaximumSize, contentMode: .aspectFit, options: requestOptions, resultHandler: { image, _ in
                guard let image = image else { return }
                page.selectedImage = image
            })
            
            page.photoIndex = index
            
            return page
        }
        return nil
    }
}

//MARK: implementation of UIPageViewControllerDataSource
extension PageViewController: UIPageViewControllerDataSource {
    //Before
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        if let viewController = viewController as? ZoomedPhotoViewController, let index = viewController.photoIndex, index > 0 {
            return viewZoomedPhotoViewController(index - 1)
        }
        
        return nil
    }
    
    //After
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        if let viewController = viewController as? ZoomedPhotoViewController, let index = viewController.photoIndex, (index + 1) < fetchResult.count {
            return viewZoomedPhotoViewController(index + 1)
        }
        
        return nil
    }
    
//    // MARK: UIPageControl
//    func presentationCount(for pageViewController: UIPageViewController) -> Int {
//        return 7
//    }
//
//    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
//        return selectedPhotoIndex?.row ?? 0
//    }
    
}
