//
//  SelectedViewController.swift
//  TagIt
//
//  Created by 신재혁 on 11/02/2019.
//  Copyright © 2019 ninetyfivejae. All rights reserved.
//

import UIKit

class SelectedPhotoViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    let layout = UICollectionViewFlowLayout()
    
    var imgArray = [UIImage]()
    var passedContentOffset = IndexPath()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.black
        
        //        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        //        layout.minimumInteritemSpacing = 0
        //        layout.minimumLineSpacing = 0
        //        layout.scrollDirection = .horizontal
        //
        //        self.collectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
        //        self.collectionView.delegate = self
        //        self.collectionView.dataSource = self
        //        self.collectionView.register(ImagePreviewViewCell.self, forCellWithReuseIdentifier: "ImagePreviewViewCell")
        //        self.collectionView.isPagingEnabled = true
        //        self.collectionView.scrollToItem(at: passedContentOffset, at: .left, animated: true)
        
        //        self.collectionView.autoresizingMask = UIView.AutoresizingMask(rawValue:
        //            UIView.AutoresizingMask.RawValue(UInt8(UIView.AutoresizingMask.flexibleWidth.rawValue) |
        //            UInt8(UIView.AutoresizingMask.flexibleHeight.rawValue)))
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imgArray.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SelectedPhotoItemCell", for: indexPath) as! SelectedPhotoItemCell
        cell.imageView.image = imgArray[indexPath.row]
        
        return cell
    }
    
    //    override func viewWillLayoutSubviews() {
    //        super.viewWillLayoutSubviews()
    //
    //        guard let flowLayout = self.collectionView.collectionViewLayout as? UICollectionViewFlowLayout else { return }
    //        flowLayout.itemSize = self.collectionView.frame.size
    //        flowLayout.invalidateLayout()
    //        self.collectionView.collectionViewLayout.invalidateLayout()
    //    }
    //
    //    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
    //        super.viewWillTransition(to: size, with: coordinator)
    //
    //        let offset = self.collectionView.contentOffset
    //        let width = self.collectionView.bounds.size.width
    //
    //        let index = round(offset.x / width)
    //        let newOffset = CGPoint(x: index * size.width, y: offset.y)
    //
    //        self.collectionView.setContentOffset(newOffset, animated: false)
    //        coordinator.animate(alongsideTransition: { (context) in
    //            self.collectionView.reloadData()
    //            self.collectionView.setContentOffset(newOffset, animated: false)
    //        }, completion: nil)
    //    }

}
