//
//  ColorPickerViewController.swift
//  TagIt
//
//  Created by 신재혁 on 25/02/2019.
//  Copyright © 2019 ninetyfivejae. All rights reserved.
//

import UIKit

class ColorPickerViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var collectionViewFlowLayout: UICollectionViewFlowLayout!
    
    @IBOutlet weak var collectionViewHeightConstraint: NSLayoutConstraint!
    
    var selectedTagIndex: IndexPath?
    weak var updateColorDelegate: UpdateColorDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        
        collectionViewHeightConstraint.constant = self.view.height
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 9
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        guard let cell = self.collectionView.cellForItem(at: indexPath) else {
            return
        }
        self.updateColorDelegate?.updateColor(selectedColor: cell.backgroundColor!)
        self.navigationController?.popViewController(animated: true)
			print("Color Picker View ###")
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ColorPickerCell", for: indexPath) as UICollectionViewCell
        
        switch indexPath.row {
        case 0:
            cell.backgroundColor = UIColor(hexFromString: "FF4F79", alpha: 1.0)
        case 1:
            cell.backgroundColor = UIColor(hexFromString: "FDA293", alpha: 1.0)
        case 2:
            cell.backgroundColor = UIColor(hexFromString: "FDDA93", alpha: 1.0)
        case 3:
            cell.backgroundColor = UIColor(hexFromString: "A4BDA7", alpha: 1.0)
        case 4:
            cell.backgroundColor = UIColor(hexFromString: "7DB9CA", alpha: 1.0)
        case 5:
            cell.backgroundColor = UIColor(hexFromString: "0278C6", alpha: 1.0)
        case 6:
            cell.backgroundColor = UIColor(hexFromString: "D5C9DB", alpha: 1.0)
        case 7:
            cell.backgroundColor = UIColor(hexFromString: "662E93", alpha: 1.0)
        case 8:
            cell.backgroundColor = UIColor(hexFromString: "555555", alpha: 1.0)
        default:
            cell.backgroundColor = UIColor(hexFromString: "555555", alpha: 1.0)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = self.collectionView.frame.width
        
        if DeviceInfo.Orientation.isPortrait {
            return CGSize(width: width/3 - 1, height: width/3 - 1)
        } else {
            return CGSize(width: width/6 - 1, height: width/6 - 1)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1.0
    }
}
