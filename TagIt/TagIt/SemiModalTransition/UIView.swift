import UIKit

extension UIView {
    
    @IBInspectable var borderColor: UIColor? {
        get {
            if let color = layer.borderColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        set {
            layer.borderColor = newValue?.cgColor
        }
    }
    
    @IBInspectable var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            clipsToBounds = newValue > 0.0
        }
    }
    
    
    var origin: CGPoint {
        get {
            return frame.origin
        }
        set {
            var r = frame
            r.origin = newValue
            frame = r
        }
    }
    
    var x: CGFloat {
        get {
            return frame.origin.x
        }
        set {
            var r = frame
            r.origin.x = newValue
            frame = r
        }
    }
    
    var y: CGFloat {
        get {
            return frame.origin.y
        }
        set {
            var r = frame
            r.origin.y = newValue
            frame = r
        }
    }
    
    var size: CGSize {
        get {
            return frame.size
        }
        set {
            var r = frame
            r.size = newValue
            frame = r
        }
    }
    
    var width: CGFloat {
        get {
            return frame.size.width
        }
        set {
            var r = frame
            r.size.width = newValue
            frame = r
        }
    }
    
    var height: CGFloat {
        get {
            return self.frame.size.height
        }
        set {
            var r = frame
            r.size.height = newValue
            frame = r
        }
    }
    
    var viewController: UIViewController? {
        var responder: UIResponder? = self
        while let next = responder?.next {
            if next is UIViewController {
                return next as? UIViewController
            }
            
            responder = next
        }
        
        return nil
    }
    
    class func initWithSize(_ size: CGSize) -> UIView {
        return UIView(frame: CGRect(x: 0, y: 0, width: size.width, height: size.height))
    }
    
    class func animateWithSystemMotion(_ animations: (() -> Void)?, completion: ((Bool) -> Void)?) {
        UIView.perform(.delete,
                       on: [],
                       options: [.beginFromCurrentState, .allowUserInteraction],
                       animations: animations,
                       completion: completion)
    }
    
}
