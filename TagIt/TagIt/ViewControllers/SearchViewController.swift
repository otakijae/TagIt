//
//  SearchViewController.swift
//  TagIt
//
//  Created by 신재혁 on 24/02/2019.
//  Copyright © 2019 ninetyfivejae. All rights reserved.
//

import UIKit
import Photos

class SearchViewController: UIViewController {

	@IBOutlet weak var collectionView: UICollectionView!
	@IBOutlet weak var collectionViewFlowLayout: UICollectionViewFlowLayout!
	@IBOutlet weak var searchTextField: UITextField!
	
	var thumbnailSize: CGSize!
	var previousPreheatRect = CGRect.zero
	var requestOptions = PHImageRequestOptions()
	var cellSize: CGSize!
	
	var searchedAssetList: [PHAsset] = []
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		self.collectionView.delegate = self
		self.collectionView.dataSource = self
		self.searchTextField.delegate = self
		
		initialSettings()
		prepareUsingPhotos()
	
		//텍스트필드에 포커스
		self.searchTextField.becomeFirstResponder()
	}
	
	func initialSettings() {
		self.cellSize = self.collectionViewFlowLayout.itemSize
		self.thumbnailSize = CGSize(width: cellSize.width, height: cellSize.height)
	}
	
	func prepareUsingPhotos() {
		self.resetCachedAssets()
		PHPhotoLibrary.shared().register(self)
	}
	
	deinit {
		PHPhotoLibrary.shared().unregisterChangeObserver(self)
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
	}
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		self.updateCachedAssets()
	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == "PageViewControllerSegue" {
			guard let pageViewController = segue.destination as? PageViewController else {
				fatalError("unexpected view controller for segue")
			}
			
			let indexPath = self.collectionView.indexPath(for: sender as! UICollectionViewCell)!
			pageViewController.selectedPhotoIndex = indexPath
		}
	}
		
	@IBAction func doneButtonTapped(_ sender: Any) {
		self.view.endEditing(true)

		self.dismiss(animated: true, completion: nil)
	}
	
}

extension SearchViewController: UITextFieldDelegate {
	
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		
		PhotographManager.sharedInstance.requestSearchedAssetList(by: self.searchTextField.text!, targetSize: self.thumbnailSize, options: nil) { searchedAssetList in
			self.searchedAssetList = searchedAssetList
			self.searchTextField.resignFirstResponder()
			self.collectionView.reloadData()
		}
		
		return true
	}
	
	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		super.touchesBegan(touches, with: event)
		
		self.view.endEditing(true)
	}
	
}

// MARK: UICollectionView

extension SearchViewController: UICollectionViewDelegate, UICollectionViewDataSource {
	
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		
//		guard let result = RealmManager.sharedInstance.getObjects(type: Photograph.self) else { return 0 }
//		let filteredArray = Array(result).filter({Array($0.tagList).map({$0}).contains(self.searchTextField.text)})
//
//		return filteredArray.count
		
		return self.searchedAssetList.count
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		
		guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: PhotoItemCell.self), for: indexPath) as? PhotoItemCell else {
			fatalError("unexpected cell in collection view")
		}
		
		PhotographManager.sharedInstance.requestSearchedThumnailImage(with: self.searchedAssetList[indexPath.item], targetSize: self.thumbnailSize, options: nil, cell: cell) { image in
			cell.thumbnailImage = image
		}
		
		return cell
	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		
		let width = self.collectionView.frame.width
		
		if DeviceInfo.Orientation.isPortrait {
			return CGSize(width: width/4 - 1, height: width/4 - 1)
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

// MARK: UIScrollView

extension SearchViewController: UICollectionViewDelegateFlowLayout {
	
	func scrollViewDidScroll(_ scrollView: UIScrollView) {
		updateCachedAssets()
		
		if getScrollViewSpeed(scrollView) > 10.0 {
			self.thumbnailSize = CGSize(width: cellSize.width * 0.5, height: cellSize.height * 0.5)
		}
	}
	
	func scrollViewDidScrollToTop(_ scrollView: UIScrollView) {
		reloadPhotosWithOriginalSize()
	}
	
	func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
		perform(#selector(self.actionOnFinishedScrolling), with: nil, afterDelay: Double(velocity.x))
	}
	
	func getScrollViewSpeed(_ scrollView: UIScrollView) -> Float {
		let lastOffset: CGPoint? = CGPoint()
		let lastOffsetCapture: TimeInterval? = 0
		let currentOffset = scrollView.contentOffset
		let currentTime = NSDate().timeIntervalSinceReferenceDate
		let timeDiff = currentTime - lastOffsetCapture!
		let captureInterval = 0.1
		
		if timeDiff > captureInterval {
			let distance = currentOffset.y - lastOffset!.y     // calc distance
			let scrollSpeedNotAbs = (distance * 10) / 1000     // pixels per ms*10
			let scrollSpeed = fabsf(Float(scrollSpeedNotAbs))  // absolute value
			
			return scrollSpeed
		} else {
			return 0
		}
	}
	
	@objc func actionOnFinishedScrolling() {
		reloadPhotosWithOriginalSize()
	}
	
	func reloadPhotosWithOriginalSize() {
		thumbnailSize = CGSize(width: cellSize.width, height: cellSize.height)
		collectionView.reloadData()
	}
}

// MARK: Asset Caching

extension SearchViewController {
	
	fileprivate func resetCachedAssets() {
		PhotographManager.sharedInstance.imageCachingManager.stopCachingImagesForAllAssets()
		previousPreheatRect = .zero
	}
	
	fileprivate func updateCachedAssets() {
		guard isViewLoaded && view.window != nil else { return }
		
		let visibleRect = CGRect(origin: collectionView!.contentOffset, size: collectionView!.bounds.size)
		let preheatRect = visibleRect.insetBy(dx: 0, dy: -0.5 * visibleRect.height)
		
		let delta = abs(preheatRect.midY - previousPreheatRect.midY)
		guard delta > view.bounds.height / 3 else { return }
		
		let (addedRects, removedRects) = differencesBetweenRects(previousPreheatRect, preheatRect)
		let addedAssets = addedRects
			.flatMap { rect in collectionView!.indexPathsForElements(in: rect) }
			.map { indexPath in PhotographManager.sharedInstance.fetchResult.object(at: indexPath.item) }
		let removedAssets = removedRects
			.flatMap { rect in collectionView!.indexPathsForElements(in: rect) }
			.map { indexPath in PhotographManager.sharedInstance.fetchResult.object(at: indexPath.item) }
		
		PhotographManager.sharedInstance.imageCachingManager.startCachingImages(for: addedAssets, targetSize: thumbnailSize, contentMode: .aspectFill, options: nil)
		PhotographManager.sharedInstance.imageCachingManager.stopCachingImages(for: removedAssets, targetSize: thumbnailSize, contentMode: .aspectFill, options: nil)
		
		previousPreheatRect = preheatRect
	}
	
	fileprivate func differencesBetweenRects(_ old: CGRect, _ new: CGRect) -> (added: [CGRect], removed: [CGRect]) {
		if old.intersects(new) {
			var added = [CGRect]()
			if new.maxY > old.maxY {
				added += [CGRect(x: new.origin.x, y: old.maxY, width: new.width, height: new.maxY - old.maxY)]
			}
			if old.minY > new.minY {
				added += [CGRect(x: new.origin.x, y: new.minY, width: new.width, height: old.minY - new.minY)]
			}
			
			var removed = [CGRect]()
			if new.maxY < old.maxY {
				removed += [CGRect(x: new.origin.x, y: new.maxY, width: new.width, height: old.maxY - new.maxY)]
			}
			if old.minY < new.minY {
				removed += [CGRect(x: new.origin.x, y: old.minY, width: new.width, height: new.minY - old.minY)]
			}
			
			return (added, removed)
		} else {
			return ([new], [old])
		}
	}
}

// MARK: PHPhotoLibraryChangeObserver

extension SearchViewController: PHPhotoLibraryChangeObserver {
	func photoLibraryDidChange(_ changeInstance: PHChange) {
		
		guard let changes = changeInstance.changeDetails(for: PhotographManager.sharedInstance.fetchResult) else { return }
		
		DispatchQueue.main.sync {
			PhotographManager.sharedInstance.fetchResult = changes.fetchResultAfterChanges
			if changes.hasIncrementalChanges {
				guard let collectionView = self.collectionView else { fatalError() }
				collectionView.performBatchUpdates({
					if let removed = changes.removedIndexes, removed.count > 0 {
						collectionView.deleteItems(at: removed.map({ IndexPath(item: $0, section: 0) }))
					}
					if let inserted = changes.insertedIndexes, inserted.count > 0 {
						collectionView.insertItems(at: inserted.map({ IndexPath(item: $0, section: 0) }))
					}
					if let changed = changes.changedIndexes, changed.count > 0 {
						collectionView.reloadItems(at: changed.map({ IndexPath(item: $0, section: 0) }))
					}
					changes.enumerateMoves { fromIndex, toIndex in
						collectionView.moveItem(at: IndexPath(item: fromIndex, section: 0), to: IndexPath(item: toIndex, section: 0))
					}
				})
			} else {
				collectionView!.reloadData()
			}
			resetCachedAssets()
		}
	}
}
