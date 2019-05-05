import UIKit

class SemiModalPresentationController: UIPresentationController {
	
    private(set) var tapGestureRecognizer: UITapGestureRecognizer?
    private var overlay = UIView()
    
    //호출 된 뷰의 frame을 결정
    override var frameOfPresentedViewInContainerView: CGRect {
        var frame = containerView!.frame
        frame.origin.y = frame.height - self.modalViewHeight
        frame.size.height = self.modalViewHeight
        return frame
    }
    
    var dismissesOnTappingOutside: Bool = true {
        didSet {
            self.tapGestureRecognizer?.isEnabled = self.dismissesOnTappingOutside
        }
    }
    
    private var modalViewHeight: CGFloat = 0
    
    var backdropViewController: UIViewController {
        return self.presentingViewController
    }
    
    var frontViewController: UIViewController {
        return self.presentedViewController
    }
    
    //모달 뷰의 높이를 설정
    func setModalViewHeight(_ newHeight: CGFloat, animated: Bool) {
        guard let presentedView = self.presentedView else {return}
        
        self.modalViewHeight = newHeight
        
        let frame = self.frameOfPresentedViewInContainerView
        
        if animated == false {
            presentedView.frame = frame
            return
        }
        
        UIView.animateWithSystemMotion({
            presentedView.frame = frame
            presentedView.layoutIfNeeded()
        }, completion: nil)
    }
    
    private func setupOverlay(toContainerView: UIView) {
        self.tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapOnOverlay(_:)))
        self.tapGestureRecognizer!.isEnabled = self.dismissesOnTappingOutside
        
        self.overlay.frame = toContainerView.bounds
        self.overlay.backgroundColor = UIColor.black
        self.overlay.alpha = 0.0
        self.overlay.gestureRecognizers = [self.tapGestureRecognizer!]
        
        toContainerView.insertSubview(self.overlay, at: 0)
    }
    
    //표시 직전
    override func presentationTransitionWillBegin() {
        guard let containerView = self.containerView else {return}
        
        setupOverlay(toContainerView: containerView)
        
        self.frontViewController.transitionCoordinator?.animate(
            alongsideTransition: { [weak self] (context) in
                self?.overlay.alpha = 0.35
            }, completion: nil)
    }
    
    //은폐 직전
    override func dismissalTransitionWillBegin() {
        self.frontViewController.transitionCoordinator?.animate(
            alongsideTransition: { [weak self] (context) in
                self?.overlay.alpha = 0.0
            }, completion: nil)
    }
    
    override func dismissalTransitionDidEnd(_ completed: Bool) {
        if completed {
            self.overlay.removeFromSuperview()
        }
    }
    
    //뷰의 레이아웃 직전
    override func containerViewWillLayoutSubviews() {
        if let containerView = containerView {
            self.overlay.frame = containerView.bounds
        }
        
        self.presentedView?.frame = self.frameOfPresentedViewInContainerView
    }
    
    //배경 투명 부분의 탭에서 닫기
    @objc private func tapOnOverlay(_ gesture: UITapGestureRecognizer) {
        self.frontViewController.dismiss(animated: true, completion: nil)
    }
    
    //배경 뷰의 스케일과 차이를 적용하는 아핀 행렬을 반환
    static func backdropTransform(withScale scale: CGFloat, translates: CGPoint) -> CGAffineTransform {
        return CGAffineTransform(scaleX: scale, y: scale).translatedBy(x: translates.x, y: translates.y)
    }
    
    //전경보기 표시 전환을 그리기
    func performPresentingTransition(withFrontMargin frontMargin: CGFloat,
                                     backdropMargins: CGPoint,
                                     backdropScale: CGFloat,
                                     backdropCornerRadius: CGFloat,
                                     animated: Bool,
                                     additionalAnimations parallelAnimations: (() -> Swift.Void)?) {
        //모달 뷰의 높이를 설정
        setModalViewHeight(self.frontViewController.view.frame.size.height - frontMargin, animated: false)
        
        //배경 뷰의 축소와 차이
        let t = SemiModalPresentationController.backdropTransform(withScale: backdropScale, translates: backdropMargins)
        
        if animated {
            UIView.animateWithSystemMotion({
                self.backdropViewController.view.transform = t
                self.backdropViewController.view.layer.cornerRadius = backdropCornerRadius
                self.frontViewController.setNeedsStatusBarAppearanceUpdate()
                parallelAnimations?()
            }, completion: nil)
        }
        else {
            self.backdropViewController.view.transform = t
            self.backdropViewController.view.layer.cornerRadius = backdropCornerRadius
            self.frontViewController.setNeedsStatusBarAppearanceUpdate()
        }
    }
    
    //전경보기 닫기 전환을 그리기
    func performDismissingTransition(withCustomTransfrom customTransfrom: CGAffineTransform?,
                                     backdropCornerRadius: CGFloat,
                                     animated: Bool,
                                     additionalAnimations parallelAnimations: (() -> Swift.Void)?) {
        var t = CGAffineTransform.identity
        if let customTransfrom = customTransfrom {
            t = customTransfrom
        }
        
        if animated {
            UIView.animateWithSystemMotion({
                self.backdropViewController.view.transform = t
                self.backdropViewController.view.layer.cornerRadius = backdropCornerRadius
                //self.frontViewController.setNeedsStatusBarAppearanceUpdate()
                parallelAnimations?()
            }, completion: nil)
        }
        else {
            self.backdropViewController.view.transform = t
            self.backdropViewController.view.layer.cornerRadius = backdropCornerRadius
            //self.frontViewController.setNeedsStatusBarAppearanceUpdate()
        }
    }
    
    //스크롤 비율에 따라 배경 뷰의 스케일 차이를 동적 변화
    func updateBackdropTransform(withScrollRate scrollRate: CGFloat,
                                 backdropScale: CGFloat,
                                 backdropScaleLimit: CGFloat,
                                 backdropMargins: CGPoint) {
        let scale = max(min(backdropScale - scrollRate, backdropScaleLimit), backdropScale)
        let t = SemiModalPresentationController.backdropTransform(withScale: scale, translates: backdropMargins)
        self.backdropViewController.view.transform = t
    }
	
}
