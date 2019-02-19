//
//  ZoomedPhotoViewController.swift
//  TagIt
//
//  Created by 신재혁 on 16/02/2019.
//  Copyright © 2019 ninetyfivejae. All rights reserved.
//

import UIKit

class ZoomedPhotoViewController: UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var imageViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageViewLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageViewTrailingConstraint: NSLayoutConstraint!
    
    var photoIndex: Int!
    
    var selectedImage: UIImage?
    var imageSize = CGSize(width: 0, height: 0)
    
    var isBarVisible: Bool = true
    
    override func viewDidLoad() {
        
        if let image = selectedImage {
            imageView.image = image
            
            let maxScale = image.size.width / scrollView.frame.size.width
            scrollView.minimumZoomScale = 1.0
            scrollView.maximumZoomScale = maxScale
            scrollView.contentSize = CGSize(width: image.size.width, height: image.size.width)
        }
        
        scrollView.delegate = self
        
        let singleTapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture(_:)))
        singleTapGesture.cancelsTouchesInView = false
        singleTapGesture.numberOfTapsRequired = 1
        singleTapGesture.numberOfTouchesRequired = 1
        scrollView.addGestureRecognizer(singleTapGesture)
        
        let doubleTapGesture = UITapGestureRecognizer(target: self, action: #selector(handleDoubleTapGesture(_:)))
        doubleTapGesture.numberOfTapsRequired = 2
        doubleTapGesture.numberOfTouchesRequired = 1
        scrollView.addGestureRecognizer(doubleTapGesture)
        singleTapGesture.require(toFail: doubleTapGesture)
        
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeDownGesture(_:)))
        swipeDown.direction = .down
        scrollView.addGestureRecognizer(swipeDown)
    }
    
    fileprivate func popViewControllerAnimatedFromBottom() {
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
    
    @objc func handleSwipeDownGesture(_ recognizer: UISwipeGestureRecognizer) {
        popViewControllerAnimatedFromBottom()
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

extension ZoomedPhotoViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
}
