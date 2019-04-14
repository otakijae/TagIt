//
//  PhotoItemCell.swift
//  TagIt
//
//  Created by 신재혁 on 15/02/2019.
//  Copyright © 2019 ninetyfivejae. All rights reserved.
//

import UIKit

class PhotoItemCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var taggedLabel: UILabel!
    
    var representedAssetIdentifier: String!
    
    var thumbnailImage: UIImage! {
        didSet {
            imageView.image = thumbnailImage
        }
    }
	
	override var isSelected: Bool {
		didSet {
			imageView.layer.borderColor = UIColor.pastelLightpurple.cgColor
			imageView.layer.borderWidth = isSelected ? 10 : 0
		}
	}
    
    override func prepareForReuse() {
        super.prepareForReuse()
				isSelected = false
        imageView.image = nil
    }
}
