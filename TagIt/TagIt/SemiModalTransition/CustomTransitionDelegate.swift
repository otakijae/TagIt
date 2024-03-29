import UIKit

class TransitioningDelegate: NSObject, UIViewControllerTransitioningDelegate {
    
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {

        let semiModalPresentationController = SemiModalPresentationController(presentedViewController: presented, presenting: presenting)

        semiModalPresentationController.dismissesOnTappingOutside = false
        
        return semiModalPresentationController
    }
	
}

class SemiModalTransitionSegue: UIStoryboardSegue {
    
    private(set) var transitioningDelegatee = TransitioningDelegate()
    
    override func perform() {
        destination.modalPresentationStyle = .custom
        destination.transitioningDelegate = self.transitioningDelegatee
        super.perform()
    }
	
}
