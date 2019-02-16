//
//  SelectedPhotoViewController.swift
//  TagIt
//
//  Created by 신재혁 on 15/02/2019.
//  Copyright © 2019 ninetyfivejae. All rights reserved.
//

import UIKit
import Photos
import PhotosUI

class SelectedPhotoViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    var asset: PHAsset!
    var assetCollection: PHAssetCollection!
    
    
    //작업 중
    var myCollectionView: UICollectionView!
    var imageManager = PHCachingImageManager()
    var passedContentOffset = IndexPath(row: 0, section: 0)
    var fetchResult: PHFetchResult<PHAsset>!
    
    
    
    @IBOutlet weak var editButton: UIBarButtonItem!
    @IBOutlet weak var progressView: UIProgressView!
    
    @IBOutlet var playButton: UIBarButtonItem!
    @IBOutlet var space: UIBarButtonItem!
    @IBOutlet var trashButton: UIBarButtonItem!
    @IBOutlet var favoriteButton: UIBarButtonItem!
    
    fileprivate var playerLayer: AVPlayerLayer!
    fileprivate var isPlayingHint = false
    
    fileprivate lazy var formatIdentifier = Bundle.main.bundleIdentifier!
    fileprivate let formatVersion = "1.0"
    fileprivate lazy var ciContext = CIContext()
    
    // MARK: UIViewController / Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        PHPhotoLibrary.shared().register(self)
        
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.scrollDirection = .horizontal
        
        myCollectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
        myCollectionView.delegate = self
        myCollectionView.dataSource = self
        myCollectionView.register(SelectedPhotoItemCell.self, forCellWithReuseIdentifier: "SelectedPhotoItemCell")
        myCollectionView.isPagingEnabled = true
        
        self.view.addSubview(myCollectionView)
        
        myCollectionView.autoresizingMask = UIView.AutoresizingMask(rawValue:
            UIView.AutoresizingMask.RawValue(UInt8(UIView.AutoresizingMask.flexibleWidth.rawValue) |
                UInt8(UIView.AutoresizingMask.flexibleHeight.rawValue)))
    }
    
    deinit {
        PHPhotoLibrary.shared().unregisterChangeObserver(self)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return fetchResult.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SelectedPhotoItemCell", for: indexPath) as! SelectedPhotoItemCell
        
        // Prepare the options to pass when fetching the (photo, or video preview) image.
        let options = PHImageRequestOptions()
        options.deliveryMode = .highQualityFormat
        options.isNetworkAccessAllowed = true
        options.progressHandler = { progress, _, _, _ in
            // Handler might not be called on the main queue, so re-dispatch for UI work.
            DispatchQueue.main.sync {
                self.progressView.progress = Float(progress)
            }
        }
        
        PHImageManager.default().requestImage(for: asset, targetSize: targetSize, contentMode: .aspectFit, options: options, resultHandler: { image, _ in
            // Hide the progress view now the request has completed.
            self.progressView.isHidden = true
            
            // If successful, show the image view and display the image.
            guard let image = image else { return }
            
            cell.imgView.image = image
        })
        
        print(indexPath)
        
        return cell
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        guard let flowLayout = myCollectionView.collectionViewLayout as? UICollectionViewFlowLayout else { return }
        flowLayout.itemSize = myCollectionView.frame.size
        flowLayout.invalidateLayout()
        myCollectionView.collectionViewLayout.invalidateLayout()
        
        print("viewWillLayoutSubviews")
        
        myCollectionView.scrollToItem(at: passedContentOffset, at: .left, animated: false)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        let offset = myCollectionView.contentOffset
        let width = myCollectionView.bounds.size.width
        
        let index = round(offset.x / width)
        let newOffset = CGPoint(x: index * size.width, y: offset.y)
        
        myCollectionView.setContentOffset(newOffset, animated: false)
        coordinator.animate(alongsideTransition: { (context) in
            self.myCollectionView.reloadData()
            self.myCollectionView.setContentOffset(newOffset, animated: false)
        }, completion: nil)
        
        print("viewWillTransition")
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Set the appropriate toolbarItems based on the mediaType of the asset.
        if asset.mediaType == .video {
            toolbarItems = [favoriteButton, space, playButton, space, trashButton]
            navigationController?.isToolbarHidden = false
            navigationItem.leftBarButtonItems = [playButton, favoriteButton, trashButton]
        } else {
            #if os(iOS)
            // In iOS, present both stills and Live Photos the same way, because
            // PHLivePhotoView provides the same gesture-based UI as in Photos app.
            toolbarItems = [favoriteButton, space, trashButton]
            navigationController?.isToolbarHidden = false
            #elseif os(tvOS)
            // In tvOS, PHLivePhotoView doesn't do playback gestures,
            // so add a play button for Live Photos.
            if asset.mediaSubtypes.contains(.photoLive) {
                navigationItem.leftBarButtonItems = [favoriteButton, trashButton]
            } else {
                navigationItem.leftBarButtonItems = [livePhotoPlayButton, favoriteButton, trashButton]
            }
            #endif
        }
        
        // Enable editing buttons if the asset can be edited.
        editButton.isEnabled = asset.canPerform(.content)
        favoriteButton.isEnabled = asset.canPerform(.properties)
        favoriteButton.title = asset.isFavorite ? "♥︎" : "♡"
        
        // Enable the trash button if the asset can be deleted.
        if assetCollection != nil {
            trashButton.isEnabled = assetCollection.canPerform(.removeContent)
        } else {
            trashButton.isEnabled = asset.canPerform(.delete)
        }
        
        // Make sure the view layout happens before requesting an image sized to fit the view.
        view.layoutIfNeeded()
        updateImage()
    }
    
    // MARK: UI Actions
    
    @IBAction func editAsset(_ sender: UIBarButtonItem) {
        
    }
    
    @IBAction func play(_ sender: AnyObject) {
        
    }
    
    @IBAction func removeAsset(_ sender: AnyObject) {
        
    }
    
    @IBAction func toggleFavorite(_ sender: UIBarButtonItem) {
        
    }
    
    // MARK: Image display
    
    var targetSize: CGSize {
        let scale = UIScreen.main.scale
        return CGSize(width: view.bounds.width * scale, height: view.bounds.height * scale)
    }
    
    func updateImage() {
        if asset.mediaSubtypes.contains(.photoLive) {
            updateLivePhoto()
        } else {
            updateStaticImage()
        }
    }
    
    func updateLivePhoto() {
        // Prepare the options to pass when fetching the live photo.
        let options = PHLivePhotoRequestOptions()
        options.deliveryMode = .highQualityFormat
        options.isNetworkAccessAllowed = true
        options.progressHandler = { progress, _, _, _ in
            // Handler might not be called on the main queue, so re-dispatch for UI work.
            DispatchQueue.main.sync {
                self.progressView.progress = Float(progress)
            }
        }
        
        // Request the live photo for the asset from the default PHImageManager.
        PHImageManager.default().requestLivePhoto(for: asset, targetSize: targetSize, contentMode: .aspectFit, options: options, resultHandler: { livePhoto, info in
            // Hide the progress view now the request has completed.
            self.progressView.isHidden = true
            
            // If successful, show the live photo view and display the live photo.
            guard let livePhoto = livePhoto else { return }

            if !self.isPlayingHint {
                self.isPlayingHint = true
            }
        })
    }
    
    func updateStaticImage() {
        // Prepare the options to pass when fetching the (photo, or video preview) image.
        let options = PHImageRequestOptions()
        options.deliveryMode = .highQualityFormat
        options.isNetworkAccessAllowed = true
        options.progressHandler = { progress, _, _, _ in
            // Handler might not be called on the main queue, so re-dispatch for UI work.
            DispatchQueue.main.sync {
                self.progressView.progress = Float(progress)
            }
        }
        
        PHImageManager.default().requestImage(for: asset, targetSize: targetSize, contentMode: .aspectFit, options: options, resultHandler: { image, _ in
            // Hide the progress view now the request has completed.
            self.progressView.isHidden = true
            
            // If successful, show the image view and display the image.
            guard let image = image else { return }
        })
    }
    
    // MARK: Asset editing
    
    func revertAsset(sender: UIAlertAction) {
        PHPhotoLibrary.shared().performChanges({
            let request = PHAssetChangeRequest(for: self.asset)
            request.revertAssetContentToOriginal()
        }, completionHandler: { success, error in
            if !success { print("can't revert asset: \(error)") }
        })
    }
}

// MARK: PHPhotoLibraryChangeObserver
extension SelectedPhotoViewController: PHPhotoLibraryChangeObserver {
    func photoLibraryDidChange(_ changeInstance: PHChange) {
        // Call might come on any background queue. Re-dispatch to the main queue to handle it.
        DispatchQueue.main.sync {
            // Check if there are changes to the asset we're displaying.
            guard let details = changeInstance.changeDetails(for: asset) else { return }
            
            // Get the updated asset.
            asset = details.objectAfterChanges as! PHAsset
            
            // If the asset's content changed, update the image and stop any video playback.
            if details.assetContentChanged {
                updateImage()
                
                playerLayer?.removeFromSuperlayer()
                playerLayer = nil
            }
        }
    }
}

// MARK: PHLivePhotoViewDelegate
extension SelectedPhotoViewController: PHLivePhotoViewDelegate {
    func livePhotoView(_ livePhotoView: PHLivePhotoView, willBeginPlaybackWith playbackStyle: PHLivePhotoViewPlaybackStyle) {
        isPlayingHint = (playbackStyle == .hint)
    }
    
    func livePhotoView(_ livePhotoView: PHLivePhotoView, didEndPlaybackWith playbackStyle: PHLivePhotoViewPlaybackStyle) {
        isPlayingHint = (playbackStyle == .hint)
    }
}
