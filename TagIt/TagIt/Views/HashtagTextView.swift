import UIKit

class HashtagTextView: UITextView {
    
    var hashtagArr:[String]?
    
    func resolveHashTags() {
        self.isEditable = false
        self.isSelectable = true
        let nsText: NSString = self.text as NSString
        let attrString = NSMutableAttributedString(string: nsText as String)
        hashtagArr = self.text.getHashtags()
        
        if hashtagArr?.count != 0 {
            var index = 0
            for var word in hashtagArr! {
                word = "● " + word
                if word.hasPrefix("● ") {
                    let matchRange: NSRange = nsText.range(of: word as String)
                    attrString.addAttribute(NSAttributedString.Key.link, value: "\(index):", range: matchRange)
                    index += 1
                }
            }
        }
        self.attributedText = attrString
    }
	
}
