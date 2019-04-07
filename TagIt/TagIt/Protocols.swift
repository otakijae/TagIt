//
//  Protocols.swift
//  TagIt
//
//  Created by 신재혁 on 25/02/2019.
//  Copyright © 2019 ninetyfivejae. All rights reserved.
//

import UIKit

protocol UpdateColorDelegate: class {
    func updateColor(selectedColor: UIColor)
}

protocol TaggingDelegate: class {
    func putTagsOnPhoto(with tagList: [String])
}
