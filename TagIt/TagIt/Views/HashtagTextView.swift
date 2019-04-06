//
//  HashtagTextView.swift
//  TagIt
//
//  Created by 신재혁 on 26/02/2019.
//  Copyright © 2019 ninetyfivejae. All rights reserved.
//

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

//#추가된 태그 ●

extension String {
    func getHashtags() -> [String]? {
			
        let hashtagDetector = try? NSRegularExpression(pattern: "● (\\w+)", options: NSRegularExpression.Options.caseInsensitive)
			
        let results = hashtagDetector?.matches(in: self, options: NSRegularExpression.MatchingOptions.withoutAnchoringBounds, range: NSMakeRange(0, self.utf16.count)).map { $0 }
        
        return results?.map({
            (self as NSString).substring(with: $0.range(at: 1))
        })
    }
}
