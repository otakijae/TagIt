import Foundation
import Photos
import PhotosUI

class PhotographManager {
    
	var fetchResult: PHFetchResult<PHAsset>!
	var assetCollection: PHAssetCollection!
	let imageCachingManager = PHCachingImageManager()
	var thumbnailSize: CGSize!
	var previousPreheatRect = CGRect.zero
	var requestOptions = PHImageRequestOptions()
	
	var selectedPhotograph: Photograph?
	var searchedAssetList: [PHAsset] = []
	var isSearchedPhotoType: Bool = false
	
	static let sharedInstance = PhotographManager()

	init() {
		if self.fetchResult == nil {
			let allPhotosOptions = PHFetchOptions()
			allPhotosOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
			self.fetchResult = PHAsset.fetchAssets(with: allPhotosOptions)
		}
	}
	
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
	}

	func requestImageData(selectedIndexPath: Int, resultHandler: @escaping (Photograph?) -> Void) {
		let asset: PHAsset = self.fetchResult.object(at: selectedIndexPath)

		PHImageManager.default().requestImageData(for: asset, options: PHImageRequestOptions(), resultHandler: { (imagedata, dataUTI, orientation, info) in
			if let info = info {
				if info.keys.contains(NSString(string: "PHImageFileURLKey")) {
					if let path = info[NSString(string: "PHImageFileURLKey")] as? NSURL {
						if let result = RealmManager.sharedInstance.getObjects(type: Photograph.self)?.filter("name = %@", path.lastPathComponent!).first {
							self.selectedPhotograph = result
							resultHandler(result)
						} else {
							let unTaggedPhotograph = Photograph()
							unTaggedPhotograph.name = path.lastPathComponent
							unTaggedPhotograph.localIdentifier = asset.localIdentifier
							unTaggedPhotograph.colorId = "555555"
							
							self.selectedPhotograph = unTaggedPhotograph
							guard let photo: Photograph = self.selectedPhotograph else { return }
							RealmManager.sharedInstance.saveObject(object: photo)
							resultHandler(unTaggedPhotograph)
						}
					}
				}
			}
		})
	}
	
	func requestSearchedImageData(with asset: PHAsset, resultHandler: @escaping (Photograph?) -> Void) {
		
		PHImageManager.default().requestImageData(for: asset, options: PHImageRequestOptions(), resultHandler: { (imagedata, dataUTI, orientation, info) in
			if let info = info {
				if info.keys.contains(NSString(string: "PHImageFileURLKey")) {
					if let path = info[NSString(string: "PHImageFileURLKey")] as? NSURL {
						if let result = RealmManager.sharedInstance.getObjects(type: Photograph.self)?.filter("name = %@", path.lastPathComponent!).first {
							self.selectedPhotograph = result
							resultHandler(result)
						} else {
							let unTaggedPhotograph = Photograph()
							unTaggedPhotograph.name = path.lastPathComponent
							unTaggedPhotograph.localIdentifier = asset.localIdentifier
							unTaggedPhotograph.colorId = "555555"
							
							self.selectedPhotograph = unTaggedPhotograph
							guard let photo: Photograph = self.selectedPhotograph else { return }
							RealmManager.sharedInstance.saveObject(object: photo)
							resultHandler(unTaggedPhotograph)
						}
					}
				}
			}
		})
	}
	
	func requestImageName(asset: PHAsset, resultHandler: @escaping (String?) -> Void) {
		PHImageManager.default().requestImageData(for: asset, options: PHImageRequestOptions(), resultHandler: { (imagedata, dataUTI, orientation, info) in
			if let info = info {
				if info.keys.contains(NSString(string: "PHImageFileURLKey")) {
					if let path = info[NSString(string: "PHImageFileURLKey")] as? NSURL {
						resultHandler(path.lastPathComponent)
					}
				}
			}
		})
	}
	
	func requestImageDate(selectedIndexPath: Int) -> String? {
		let asset: PHAsset = self.fetchResult.object(at: selectedIndexPath)
		
		guard let creationDate = asset.creationDate else { return nil }

		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "yyyy-MM-dd"
		let dateString: String = dateFormatter.string(from: creationDate)

		let date = dateFormatter.date(from: String(dateString.prefix(10)))
		dateFormatter.dateFormat = "yyyy년 M월 d일"
		if let date = date {
			return dateFormatter.string(from: date)
		}
		return ""		
	}
	
	func requestSearchedAssetList(by tag: String, targetSize: CGSize, options: PHImageRequestOptions?, resultHandler: @escaping ([PHAsset]) -> Void) {
		
		self.searchedAssetList = []
		
		guard let result = RealmManager.sharedInstance.getObjects(type: Photograph.self) else { return }
		let filteredArray = Array(result).filter({Array($0.tagList).map({$0}).contains(tag)})
		
		for index in 0..<fetchResult.count {
			let asset = fetchResult.object(at: index)
			self.requestImageName(asset: asset) { imageName in
				filteredArray.forEach {
					if $0.name == imageName {
						self.searchedAssetList.append(asset)
						if self.searchedAssetList.count == filteredArray.count {
							resultHandler(self.searchedAssetList)
						}
					}
				}
			}
		}
	}
	
	func requestSearchedThumnailImage(with asset: PHAsset, targetSize: CGSize, options: PHImageRequestOptions?, cell: PhotoItemCell, resultHandler: @escaping (UIImage?) -> Void) {
		
		cell.representedAssetIdentifier = asset.localIdentifier
		
		self.imageCachingManager.requestImage(for: asset, targetSize: targetSize, contentMode: .aspectFill, options: options, resultHandler: { image, info in
			if cell.representedAssetIdentifier == asset.localIdentifier {
				resultHandler(image)
			}
		})
	}
	
	func requestSearchedOriginalImage(options: PHImageRequestOptions?, selectedIndexPath: Int, resultHandler: @escaping (UIImage?) -> Void) {
		let asset = self.searchedAssetList[selectedIndexPath]
		
		self.imageCachingManager.requestImage(for: asset, targetSize: PHImageManagerMaximumSize, contentMode: .aspectFit, options: options, resultHandler: { image, info in
			resultHandler(image)
		})
	}
	
}
