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
    
//    func imageTagSettings(selectedPhotoIndex: Int) -> Photograph {
//        let asset: PHAsset = self.fetchResult.object(at: selectedPhotoIndex)
//
//        PHImageManager.default().requestImageData(for: asset, options: PHImageRequestOptions(), resultHandler: { (imagedata, dataUTI, orientation, info) in
//            if let info = info {
//                if info.keys.contains(NSString(string: "PHImageFileURLKey")) {
//                    if let path = info[NSString(string: "PHImageFileURLKey")] as? NSURL {
//                        if let result = RealmManager.sharedInstance.getObjects(type: Photograph.self)?.filter("name = %@", path.lastPathComponent).first {
//                            return result
//                        } else {
//                            return Photograph()
//                        }
//                    }
//                }
//            }
//        })
//
//        return Photograph()
//    }
}
