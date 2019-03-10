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
	
	var selectedPhotograph: Photograph?
	
	static let sharedInstance = PhotographManager()

	init() {
		if self.fetchResult == nil {
			let allPhotosOptions = PHFetchOptions()
			allPhotosOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
			self.fetchResult = PHAsset.fetchAssets(with: allPhotosOptions)
		}
	}
	
//	open func requestImage(for asset: PHAsset, targetSize: CGSize, contentMode: PHImageContentMode, options: PHImageRequestOptions?, resultHandler: @escaping (UIImage?, [AnyHashable : Any]?) -> Void) -> PHImageRequestID

	func requestThumnailImage(targetSize: CGSize, options: PHImageRequestOptions?, selectedIndexPath: Int, cell: PhotoItemCell, resultHandler: @escaping (UIImage?) -> Void) {
		let asset = fetchResult.object(at: selectedIndexPath)
		cell.representedAssetIdentifier = asset.localIdentifier
	
		self.imageCachingManager.requestImage(for: asset, targetSize: targetSize, contentMode: .aspectFill, options: options, resultHandler: { image, info in
			if cell.representedAssetIdentifier == asset.localIdentifier {
				resultHandler(image)
			}
		})
	}
	
	func requestOriginalImage(options: PHImageRequestOptions?, selectedIndexPath: Int, resultHandler: @escaping (UIImage?) -> Void) {
		
		let asset = fetchResult.object(at: selectedIndexPath)
		
		self.imageCachingManager.requestImage(for: asset, targetSize: PHImageManagerMaximumSize, contentMode: .aspectFit, options: options, resultHandler: { image, info in
			resultHandler(image)
		})
		
		self.requestImageData(selectedIndexPath: selectedIndexPath) { photograph in
			self.selectedPhotograph = photograph
		}
	}

	func requestImageData(selectedIndexPath: Int, resultHandler: @escaping (Photograph?) -> Void) {
		
		let asset: PHAsset = self.fetchResult.object(at: selectedIndexPath)

		PHImageManager.default().requestImageData(for: asset, options: PHImageRequestOptions(), resultHandler: { (imagedata, dataUTI, orientation, info) in
			if let info = info {
				if info.keys.contains(NSString(string: "PHImageFileURLKey")) {
					if let path = info[NSString(string: "PHImageFileURLKey")] as? NSURL {
						if let result = RealmManager.sharedInstance.getObjects(type: Photograph.self)?.filter("name = %@", path.lastPathComponent).first {
							resultHandler(result)
						} else {
							print("태그 등록하지 않은 사진")
							let unTaggedPhotograph = Photograph()
							unTaggedPhotograph.name = ""
							unTaggedPhotograph.localIdentifier = ""
							unTaggedPhotograph.colorId = "555555"
							resultHandler(unTaggedPhotograph)
						}
					}
				}
			}
		})
	}
}
