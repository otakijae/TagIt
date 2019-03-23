//
//  ZoomedPhotoViewController.swift
//  TagIt
//
//  Created by 신재혁 on 16/02/2019.
//  Copyright © 2019 ninetyfivejae. All rights reserved.
//

import UIKit
import Photos

class ZoomedPhotoViewController: UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var textView: HashtagTextView!
    
    @IBOutlet weak var imageViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageViewLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageViewTrailingConstraint: NSLayoutConstraint!
    
    //PageViewController에서 사용
    var photoIndex: Int!
    var selectedImage: UIImage?
    var imageSize = CGSize(width: 0, height: 0)
    
    var isBarVisible: Bool = true
    var initialTouchPoint: CGPoint = CGPoint(x: 0, y: 0)
    
    //for test
    var selectedPhoto: Photograph?

    @IBOutlet weak var tagTextView: UITextView!
    
    override func viewDidLoad() {
        
//        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
//        self.navigationController?.navigationBar.shadowImage = UIImage()
//        self.navigationController?.navigationBar.isTranslucent = true
        
        self.scrollView.delegate = self
        self.textView.delegate = self
        
        imageTagSettings()
        imageZoomSettings()
        gestureSettings()
    }
    
    func imageTagSettings() {
			var tagString: String = ""
			
			PhotographManager.sharedInstance.requestImageData(selectedIndexPath: photoIndex) { photograph in
				if let photo = photograph {
					for tag in photo.listToArray(objectList: photo.tagList) {
						tagString.append("●" + tag + "\n")
					}
					
					self.textView.text = tagString
					self.textView.resolveHashTags()
					self.textView.font = UIFont.systemFont(ofSize: 17.0)
					self.textView.textColor = UIColor(hexFromString: PhotographManager.sharedInstance.selectedPhotograph!.colorId!)
				}
			}
    }
	
    func imageZoomSettings() {
        if let image = self.selectedImage {
            self.imageView.image = image
            
            //let maxScale = image.size.width / scrollView.frame.size.width
            self.scrollView.minimumZoomScale = 1.0
            //scrollView.maximumZoomScale = maxScale
            self.scrollView.maximumZoomScale = 4.0
            self.scrollView.contentSize = CGSize(width: image.size.width, height: image.size.width)
        }
    }
    
    func gestureSettings() {
        let singleTapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture(_:)))
        singleTapGesture.cancelsTouchesInView = false
        singleTapGesture.numberOfTapsRequired = 1
        singleTapGesture.numberOfTouchesRequired = 1
        self.scrollView.addGestureRecognizer(singleTapGesture)
        
        let doubleTapGesture = UITapGestureRecognizer(target: self, action: #selector(handleDoubleTapGesture(_:)))
        doubleTapGesture.numberOfTapsRequired = 2
        doubleTapGesture.numberOfTouchesRequired = 1
        self.scrollView.addGestureRecognizer(doubleTapGesture)
        singleTapGesture.require(toFail: doubleTapGesture)
        
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeDownGesture(_:)))
        swipeDown.direction = .down
        self.scrollView.addGestureRecognizer(swipeDown)
    }
    
    @objc func handleTapGesture(_ recognizer: UITapGestureRecognizer) {
        if isBarVisible {
            navigationController?.isNavigationBarHidden = true
            navigationController?.isToolbarHidden = true
            isBarVisible = false
        } else {
            navigationController?.isNavigationBarHidden = false
            navigationController?.isToolbarHidden = false
            isBarVisible = true
        }
    }
    
    @objc func handleDoubleTapGesture(_ recognizer: UITapGestureRecognizer) {
        if scrollView.zoomScale > scrollView.minimumZoomScale {
            navigationController?.isNavigationBarHidden = true
            navigationController?.isToolbarHidden = true
            scrollView.zoom(to: zoomRectForScale(scale: scrollView.minimumZoomScale, center: recognizer.location(in: recognizer.view)), animated: true)
        } else {
            navigationController?.isNavigationBarHidden = true
            navigationController?.isToolbarHidden = true
            scrollView.zoom(to: zoomRectForScale(scale: scrollView.maximumZoomScale, center: recognizer.location(in: recognizer.view)), animated: true)
        }
    }
    
    @objc func handleSwipeDownGesture(_ recognizer: UISwipeGestureRecognizer) {
        navigationController?.isNavigationBarHidden = false
        navigationController?.isToolbarHidden = false
        let transition = CATransition()
        transition.duration = 0.4
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        transition.type = CATransitionType.reveal
        transition.subtype = CATransitionSubtype.fromBottom
        self.navigationController?.view.layer.add(transition, forKey: nil)
        _ = self.navigationController?.popToRootViewController(animated: false)
    }
    
    func zoomRectForScale(scale: CGFloat, center: CGPoint) -> CGRect {
        var zoomRect = CGRect.zero
        zoomRect.size.height = imageView.frame.size.height / scale
        zoomRect.size.width  = imageView.frame.size.width  / scale
        let newCenter = imageView.convert(center, from: scrollView)
        zoomRect.origin.x = newCenter.x - (zoomRect.size.width / 2.0)
        zoomRect.origin.y = newCenter.y - (zoomRect.size.height / 2.0)
        
        return zoomRect
    }
}

extension ZoomedPhotoViewController: UITextViewDelegate {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let taggingViewController = segue.destination as? TaggingViewController {
//            taggingViewController.selectedPhoto = self.selectedPhoto
//            taggingViewController.fetchResult = self.fetchResult
        }
    }
    
    func textView(_ textView: UITextView, shouldInteractWith url: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        
        performSegue(withIdentifier: "SemiModalTransitionSegue", sender: nil)
        
        return false
    }
    
    //태그 추가 SemiModal 창에서 다시 이미지로 돌아오는 unwind
    @IBAction func prepareUnwind(segue: UIStoryboardSegue) { }
}

extension ZoomedPhotoViewController: UIScrollViewDelegate {
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
//        print("viewForZooming")
//        print(scrollView.size)
//        print(imageView.size)
        return imageView
    }
}
