//
//  Extensions.swift
//  TagIt
//
//  Created by 신재혁 on 22/02/2019.
//  Copyright © 2019 ninetyfivejae. All rights reserved.
//

import Foundation
import Photos

enum PHPhotoLibraryAuthorizationError: Error {
    case error(PHAuthorizationStatus)
}

extension PHPhotoLibrary {
    @discardableResult class func syncRequestAuthorization() throws -> PHAuthorizationStatus {
        let status = PHPhotoLibrary.authorizationStatus()
        switch status {
        case .authorized:
            return status
        case .denied, .restricted:
            throw PHPhotoLibraryAuthorizationError.error(status)
        case .notDetermined:
            break
        }
        
        let semaphore = DispatchSemaphore(value: 0)
        
        PHPhotoLibrary.requestAuthorization{ _ in
            semaphore.signal()
        }
        
        semaphore.wait()
        
        let newStatus = PHPhotoLibrary.authorizationStatus()
        
        switch newStatus {
        case .authorized:
            return status
        case .denied, .restricted, .notDetermined:
            throw PHPhotoLibraryAuthorizationError.error(status)
        }
    }
}

extension UICollectionView {
    func indexPathsForElements(in rect: CGRect) -> [IndexPath] {
        let allLayoutAttributes = collectionViewLayout.layoutAttributesForElements(in: rect)!
        return allLayoutAttributes.map { $0.indexPath }
    }
}

extension UIColor {
    convenience init(hexFromString:String, alpha:CGFloat = 1.0) {
        var cString:String = hexFromString.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        var rgbValue:UInt32 = 10066329 //color #999999 if string has wrong format
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.count) == 6) {
            Scanner(string: cString).scanHexInt32(&rgbValue)
        }
        
        self.init(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: alpha
        )
    }
    
    func toHexString() -> String {
        var r:CGFloat = 0
        var g:CGFloat = 0
        var b:CGFloat = 0
        var a:CGFloat = 0
        
        getRed(&r, green: &g, blue: &b, alpha: &a)
        
        let rgb:Int = (Int)(r*255)<<16 | (Int)(g*255)<<8 | (Int)(b*255)<<0
        
        return String(format:"#%06x", rgb)
    }
}

extension UIColor {
	
	static var pastelRed: UIColor {
		return UIColor(hexFromString: "FF4F79", alpha: 1.0)
	}
	
	static var pastelApricot: UIColor {
		return UIColor(hexFromString: "FDA293", alpha: 1.0)
	}
	
	static var pastelYellow: UIColor {
		return UIColor(hexFromString: "FDDA93", alpha: 1.0)
	}
	
	static var pastelGreen: UIColor {
		return UIColor(hexFromString: "A4BDA7", alpha: 1.0)
	}
	
	static var pastelSkyblue: UIColor {
		return UIColor(hexFromString: "7DB9CA", alpha: 1.0)
	}
	
	static var pastelBlue: UIColor {
		return UIColor(hexFromString: "0278C6", alpha: 1.0)
	}
	
	static var pastelLightpurple: UIColor {
		return UIColor(hexFromString: "D5C9DB", alpha: 1.0)
	}
	
	static var pastelPurple: UIColor {
		return UIColor(hexFromString: "662E93", alpha: 1.0)
	}
	
	static var pastelDarkGray: UIColor {
		return UIColor(hexFromString: "555555", alpha: 1.0)
	}
	
	class var silver: UIColor {
		return UIColor(red: 207/255, green: 208/255, blue: 218/255, alpha: 1.0)
	}
	
	static var black30: UIColor {
		return UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.3)
	}
	
	class var periwinkle: UIColor {
		return UIColor(red: 118/255, green: 123/255, blue: 254/255, alpha: 1.0)
	}
	
	class var defaultKeyboardBackground: UIColor {
		return UIColor(red: 204/255, green: 208/255, blue: 215/255, alpha: 1.0)
	}
	
	static var lavenderBlue: UIColor {
		return UIColor(red: 166/255, green: 155/255, blue: 245/255, alpha: 1.0)
	}
	
	static var softBlue: UIColor {
		return UIColor(red: 103/255, green: 159/255, blue: 233/255, alpha: 1.0)
	}
	
	static var darkBlueGrey70: UIColor {
		return UIColor(red: 37/255, green: 49/255, blue: 92/255, alpha: 0.7)
	}
	
	static var darkBlueGreyTwo70: UIColor {
		return UIColor(red: 45/255, green: 28/255, blue: 68/255, alpha: 0.7)
	}
	
	static var tableViewBackgroundColor: UIColor {
		return UIColor(red: 249/255, green: 251/255, blue: 255/255, alpha: 1.0)
	}
	
	static var haloColor: UIColor {
		return UIColor(red: 1, green: 1, blue: 1, alpha: 0.5)
	}
	
	static var cellGrayColor: UIColor {
		return UIColor(red: 235/255, green:239/255, blue:250/255, alpha: 1)
	}
	
	static var labelGrayColor: UIColor {
		return UIColor(red: 138/255, green: 151/255, blue: 162/255, alpha: 1)
	}
	
	static var amethyst: UIColor {
		return UIColor(red: 136/255, green: 102/255, blue: 193/255, alpha: 1.0)
	}
	
	static var duskyPurple: UIColor {
		return UIColor(red: 141/255, green: 93/255, blue: 133/255, alpha: 1.0)
	}
	
	static var burntUmber: UIColor {
		return UIColor(red: 152/255, green: 75/255, blue: 19/255, alpha: 1.0)
	}
	
	static var disabledGrayColor: UIColor {
		return UIColor(red: 188/255, green: 191/255, blue: 208/255, alpha: 1)
	}
	
	static var titleGray: UIColor {
		return UIColor(red: 61/255, green: 73/255, blue: 83/255, alpha: 1)
	}
	
	static var buttonTitleGrayColor: UIColor {
		return UIColor(red: 86/255, green: 98/255, blue: 108/255, alpha: 1)
	}
	
	static var labelLightGrayColor: UIColor {
		return UIColor(red: 163/255, green: 174/255, blue: 184/255, alpha: 1)
	}
	
	static var disabledTitleGray: UIColor {
		return UIColor(red: 134/255, green: 143/255, blue: 163/255, alpha: 1)
	}
	
	static var whiteGray: UIColor {
		return UIColor(red: 229/255, green: 229/255, blue: 229/255, alpha: 1)
	}
	
	static var veryLightBlueTwo: UIColor {
		return UIColor(red: 248/255, green: 250/255, blue: 255/255, alpha: 1)
	}
}

extension UILabel {
	
	func makeSubStringColored(subString: String, color: UIColor) {
		self.attributedText = (self.text ?? "").colored(range: ((self.text ?? "") as NSString).range(of: subString), color: color)
	}
	
	func makeSubStringColored(range: (location: Int, length: Int), color: UIColor) {
		self.attributedText = (self.text ?? "").colored(range: NSRange(location: range.location, length: range.length), color: color)
	}
	
}

extension UITextView {
	
	func makeSubStringColored(subString: String, color: UIColor) {
		self.attributedText = (self.text ?? "").colored(range: ((self.text ?? "") as NSString).range(of: subString), color: color)
	}
	
	func makeSubStringColored(range: (location: Int, length: Int), color: UIColor) {
		self.attributedText = (self.text ?? "").colored(range: NSRange(location: range.location, length: range.length), color: color)
	}
	
}

extension UITextField {
	
	func makeSubStringColored(subString: String, color: UIColor) {
		self.attributedText = (self.text ?? "").colored(range: ((self.text ?? "") as NSString).range(of: subString), color: color)
	}
	
	func makeSubStringColored(range: (location: Int, length: Int), color: UIColor) {
		self.attributedText = (self.text ?? "").colored(range: NSRange(location: range.location, length: range.length), color: color)
	}
	
}

extension String {
	
	func makeRange(from: Int, to: Int) -> Range<String.Index>? {
		if from > to { return nil }
		if self.characters.count < to { return nil }
		return self.index(self.startIndex, offsetBy: from)..<self.index(self.startIndex, offsetBy: to)
	}
	
	var date: Date? {
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "yyyy-MM-dd"
		return dateFormatter.date(from: String(self.characters.prefix(10)))
	}
	
	var localized: String {
		return NSLocalizedString(self, comment: "")
	}
	
	func colored(range: NSRange, color: UIColor) -> NSAttributedString {
		let attributedString = NSMutableAttributedString(string: self)
		let attribute = [NSAttributedString.Key.foregroundColor: color, NSAttributedString.Key.backgroundColor: .clear]
		attributedString.addAttributes(attribute, range: range)
		return attributedString
	}
	
	func underLined(substring: String? = nil, color: UIColor) -> NSAttributedString{
		let attributedString = NSMutableAttributedString(string: self)
		let attribute: [NSAttributedString.Key: Any] = [
			.foregroundColor : color,
			.backgroundColor : UIColor.clear,
			.underlineStyle : NSUnderlineStyle.single
		]
		attributedString.addAttributes(attribute, range: (self as NSString).range(of: substring ?? self))
		return attributedString
	}
	
}

struct DeviceInfo {
	
    struct Orientation {
        static var isLandscape: Bool {
            get {
                return UIDevice.current.orientation.isValidInterfaceOrientation ? UIDevice.current.orientation.isLandscape : UIApplication.shared.statusBarOrientation.isLandscape
            }
        }
        
        static var isPortrait: Bool {
            get {
                return UIDevice.current.orientation.isValidInterfaceOrientation ? UIDevice.current.orientation.isPortrait : UIApplication.shared.statusBarOrientation.isPortrait
            }
        }
    }
	
}
