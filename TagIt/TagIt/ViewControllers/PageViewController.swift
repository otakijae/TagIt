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

    var selectedPhotoIndex: IndexPath?
	
    override func viewDidLoad() {
        super.viewDidLoad()
			
        self.dataSource = self
				self.delegate = self
			
        if let viewController = viewZoomedPhotoViewController(selectedPhotoIndex?.row ?? 0) {
            let viewControllers = [viewController]
            setViewControllers(viewControllers, direction: .forward, animated: false, completion: nil)
        }
    }
    
    var targetSize: CGSize {
        let scale = UIScreen.main.scale
        return CGSize(width: view.bounds.width * scale, height: view.bounds.height * scale)
    }
    
    func viewZoomedPhotoViewController(_ index: Int) -> ZoomedPhotoViewController? {
						
        if let storyboard = storyboard,
            let zoomedPhotoViewController = storyboard.instantiateViewController(withIdentifier: "ZoomedPhotoViewController") as? ZoomedPhotoViewController {
					
            let requestOptions = PHImageRequestOptions()
            requestOptions.isSynchronous = true
            requestOptions.deliveryMode = .highQualityFormat
            requestOptions.isNetworkAccessAllowed = true
            requestOptions.resizeMode = .exact
					
						if PhotographManager.sharedInstance.isSearchedPhotoType {
							PhotographManager.sharedInstance.requestSearchedOriginalImage(options: requestOptions, selectedIndexPath: index) { image in
								zoomedPhotoViewController.selectedImage = image
								zoomedPhotoViewController.photoIndex = index
							}
						} else {
							PhotographManager.sharedInstance.requestOriginalImage(options: requestOptions, selectedIndexPath: index) { image in
								zoomedPhotoViewController.selectedImage = image
								zoomedPhotoViewController.photoIndex = index
							}
						}
					
            return zoomedPhotoViewController
        }
        return nil
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
			
        if segue.identifier == "SemiModalTransitionSegue" {
					guard let index = self.selectedPhotoIndex?.item else {
						return
					}
        }
    }
    
    @IBAction func addTagButtonTapped(_ sender: Any) {
        performSegue(withIdentifier: "SemiModalTransitionSegue", sender: nil)
    }
}

extension PHAsset {
    var originalFilename: String? {
        return PHAssetResource.assetResources(for: self).first?.originalFilename
    }
}

//MARK: UIPageViewControllerDataSource, UIPageViewControllerDelegate

extension PageViewController: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
	
		func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
			if (completed && finished) {
				if let currentVC = pageViewController.viewControllers?.last as? ZoomedPhotoViewController {
					self.selectedPhotoIndex?.item = currentVC.photoIndex
				}
			}
		}
	
    //Before
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        if let viewController = viewController as? ZoomedPhotoViewController, let index = viewController.photoIndex, index > 0 {
						return viewZoomedPhotoViewController(index - 1)
        }
        
        return nil
    }
    
    //After
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
			
				if PhotographManager.sharedInstance.isSearchedPhotoType {
					if let viewController = viewController as? ZoomedPhotoViewController, let index = viewController.photoIndex, (index + 1) < PhotographManager.sharedInstance.searchedAssetList.count {
						return viewZoomedPhotoViewController(index + 1)
					}
				} else {
					if let viewController = viewController as? ZoomedPhotoViewController, let index = viewController.photoIndex, (index + 1) < PhotographManager.sharedInstance.fetchResult.count {
						return viewZoomedPhotoViewController(index + 1)
					}
				}
        
        return nil
    }
}
