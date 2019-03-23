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

				print(self.selectedPhotoIndex?.item)
			
        self.dataSource = self
				self.delegate = self
			
        if let viewController = viewZoomedPhotoViewController(selectedPhotoIndex?.row ?? 0) {
            let viewControllers = [viewController]
            setViewControllers(viewControllers, direction: .forward, animated: false, completion: nil)
        }
			
			//test 값 임의로 추가하는 코드
//			let photograph: Photograph = Photograph(name: "IMG_0033.JPG", localIdentifier: "69676321-F746-4F2C-9489-07522BA9EBC5/L0/001", colorId: "FDA293", tagArray: ["신발", "패션"])
//			RealmManager.sharedInstance.saveObjects(object: photograph)
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
					
					PhotographManager.sharedInstance.requestOriginalImage(options: requestOptions, selectedIndexPath: index) { image in
						zoomedPhotoViewController.selectedImage = image
						zoomedPhotoViewController.photoIndex = index
					}
					
            return zoomedPhotoViewController
        }
        return nil
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if let taggingViewController = segue.destination as? TaggingViewController {
//            print(self.selectedPhotoIndex?.row)
//            taggingViewController.fetchResult = self.fetchResult
//            taggingViewController.selectedIndex = self.selectedPhotoIndex?.row
//            print("TEST TEST")
//        }
        if segue.identifier == "SemiModalTransitionSegue" {
					guard let index = self.selectedPhotoIndex?.item else {
						return
					}
					PhotographManager.sharedInstance.requestImageData(selectedIndexPath: index) { photograph in
						print(photograph)
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
					print(self.selectedPhotoIndex?.item)
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
        
        if let viewController = viewController as? ZoomedPhotoViewController, let index = viewController.photoIndex, (index + 1) < PhotographManager.sharedInstance.fetchResult.count {
            return viewZoomedPhotoViewController(index + 1)
        }
        
        return nil
    }
}
