//
//  TaggingViewCell.swift
//  TagIt
//
//  Created by 신재혁 on 25/02/2019.
//  Copyright © 2019 ninetyfivejae. All rights reserved.
//

import UIKit

class TaggingViewCell: UITableViewCell {
    @IBOutlet weak var colorTagView: UIView!
    @IBOutlet weak var tagLabel: UILabel!
    @IBOutlet weak var removeButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.colorTagView.layer.cornerRadius = self.colorTagView.frame.size.width / 2;
        self.colorTagView.clipsToBounds = true;
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}