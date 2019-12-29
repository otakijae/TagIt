import UIKit
import Photos

class ZoomedPhotoViewController: UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var hashtagTextView: HashtagTextView!
    
    @IBOutlet weak var imageViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageViewLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageViewTrailingConstraint: NSLayoutConstraint!
    
    //PageViewController에서 사용
    var photoIndex: Int!
    var selectedImage: UIImage?
    var imageSize = CGSize(width: 0, height: 0)
    
    var isBarHidden: Bool = false
    var initialTouchPoint: CGPoint = CGPoint(x: 0, y: 0)

    @IBOutlet weak var tagTextView: UITextView!
    
    override func viewDidLoad() {
        self.scrollView.delegate = self
        self.hashtagTextView.delegate = self
			
        imageTagSettings()
        imageZoomSettings()
        gestureSettings()
			
				clearNavigationBar()
				clearToolbar()
				imageViewDisplaySettings(isHidden: false)
		}
	
		func imageViewDisplaySettings(isHidden: Bool) {
				navigationController?.setNavigationBarHidden(isHidden, animated: true)
				navigationController?.setToolbarHidden(isHidden, animated: true)
				self.hashtagTextView.isHidden = isHidden
				isBarHidden = !isHidden
		}
    
    func imageTagSettings() {
			if PhotographManager.sharedInstance.isSearchedPhotoType {
				PhotographManager.sharedInstance.requestSearchedImageData(with: PhotographManager.sharedInstance.searchedAssetList[photoIndex]) { photograph in
					self.configureTagTextView(photograph: photograph)
				}
			} else {
				PhotographManager.sharedInstance.requestImageData(selectedIndexPath: photoIndex) { photograph in
					self.configureTagTextView(photograph: photograph)
				}
			}
		}
	
		func configureTagTextView(photograph: Photograph?) {
			var tagString: String = ""
			
			if let photo = photograph {
				for tag in photo.listToArray(objectList: photo.tagList) {
					tagString.append("● " + tag + "\n")
				}
				
				self.hashtagTextView.text = tagString
				self.hashtagTextView.resolveHashTags()
				self.hashtagTextView.font = UIFont.systemFont(ofSize: 17.0)
				self.hashtagTextView.tintColor = UIColor(hexFromString: photo.colorId)
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
				imageViewDisplaySettings(isHidden: isBarHidden)
    }
    
    @objc func handleDoubleTapGesture(_ recognizer: UITapGestureRecognizer) {
        if scrollView.zoomScale > scrollView.minimumZoomScale {
            scrollView.zoom(to: zoomRectForScale(scale: scrollView.minimumZoomScale, center: recognizer.location(in: recognizer.view)), animated: true)
        } else {
            scrollView.zoom(to: zoomRectForScale(scale: scrollView.maximumZoomScale, center: recognizer.location(in: recognizer.view)), animated: true)
        }
    }
    
    @objc func handleSwipeDownGesture(_ recognizer: UISwipeGestureRecognizer) {
				imageViewDisplaySettings(isHidden: false)
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
			
				imageViewDisplaySettings(isHidden: true)
        
        return zoomRect
    }
	
}

extension ZoomedPhotoViewController: UITextViewDelegate {
    
	@available(iOS 10.0, *)
	func textView(_ textView: UITextView, shouldInteractWith url: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        
        performSegue(withIdentifier: "SemiModalTransitionSegue", sender: nil)
        
        return false
    }
    
    //태그 추가 SemiModal 창에서 다시 이미지로 돌아오는 unwind
    @IBAction func prepareUnwind(segue: UIStoryboardSegue) { }
	
}

extension ZoomedPhotoViewController: UIScrollViewDelegate {
	
		func scrollViewWillBeginZooming(_ scrollView: UIScrollView, with view: UIView?) {
				imageViewDisplaySettings(isHidden: true)
		}
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
//        print("viewForZooming")
//        print(scrollView.size)
//        print(imageView.size)
        return imageView
    }
	
}
