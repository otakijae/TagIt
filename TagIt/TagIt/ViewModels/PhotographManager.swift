//
//  PhotographManager.swift
//  TagIt
//
//  Created by 신재혁 on 03/03/2019.
//  Copyright © 2019 ninetyfivejae. All rights reserved.
//

import Foundation
import Photos

class PhotographManager {
    
	var fetchResult: PHFetchResult<PHAsset>!
	var assetCollection: PHAssetCollection!
	let imageCachingManager = PHCachingImageManager()
	var thumbnailSize: CGSize!
	var previousPreheatRect = CGRect.zero
	var requestOptions = PHImageRequestOptions()
	
	static let sharedInstance = PhotographManager()

	init() {
		if self.fetchResult == nil {
			let allPhotosOptions = PHFetchOptions()
			allPhotosOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
			self.fetchResult = PHAsset.fetchAssets(with: allPhotosOptions)
		}
	}
	
//	open func requestImage(for asset: PHAsset, targetSize: CGSize, contentMode: PHImageContentMode, options: PHImageRequestOptions?, resultHandler: @escaping (UIImage?, [AnyHashable : Any]?) -> Void) -> PHImageRequestID
	
//    func requestIamge(with asset: PHAsset?, thumbnailSize: CGSize, completion: @escaping (UIImage?) -> Void) {
//        guard let asset = asset else {
//            completion(nil)
//            return
//        }
//        self.representedAssetIdentifier = asset.localIdentifier
//        self.imageManager.requestImage(for: asset, targetSize: thumbnailSize, contentMode: .aspectFill, options: nil, resultHandler: { image, info in
//            // UIKit may have recycled this cell by the handler's activation time.
//            //  print(info?["PHImageResultIsDegradedKey"])
//            // Set the cell's thumbnail image only if it's still showing the same asset.
//            if self.representedAssetIdentifier == asset.localIdentifier {
//                completion(image)
//            }
//        })
//    }

	func requestThumnailImage(targetSize: CGSize, options: PHImageRequestOptions?, selectedIndexPath: Int, cell: PhotoItemCell, resultHandler: @escaping (UIImage?) -> Void) {
		let asset = fetchResult.object(at: selectedIndexPath)
		cell.representedAssetIdentifier = asset.localIdentifier
	
		self.imageCachingManager.requestImage(for: asset, targetSize: targetSize, contentMode: .aspectFill, options: options, resultHandler: { image, info in
			if cell.representedAssetIdentifier == asset.localIdentifier {
				resultHandler(image)
			}
		})
	}
	
	func requestOriginalImage(for asset: PHAsset, targetSize: CGSize, contentMode: PHImageContentMode, options: PHImageRequestOptions?, resultHandler: @escaping (UIImage?) -> Void) {
		
	}
	
	//보류
	//select 해당 사진 파일해서, 데이터 있고 태그가 달려있으면 collectionView에 표시해주기 / 이 부분 때문에 느려져서 prefetching에서 데이터를 가져와야할듯함
	//        self.imageCachingManager.requestImageData(
	//            for: asset, options: self.requestOptions, resultHandler: { (imagedata, dataUTI, orientation, info) in
	//                if let info = info {
	//                    if info.keys.contains(NSString(string: "PHImageFileURLKey")) {
	//                        if let path = info[NSString(string: "PHImageFileURLKey")] as? NSURL {
	//                            RealmManager.sharedInstance.testRealmMananger()
	//                            if path.lastPathComponent == "IMG_1234" {
	//                                print("JACKPOT!!! JACKPOT!!! JACKPOT!!!")
	//                            }
	//                        }
	//                    }
	//                }
	//        })
}
