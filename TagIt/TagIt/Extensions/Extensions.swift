import Foundation
import Photos
import PhotosUI

enum PHPhotoLibraryAuthorizationError: Error {
    case error(PHAuthorizationStatus)
}

extension PHPhotoLibrary {
	
    @discardableResult class func syncRequestAuthorization() throws -> PHAuthorizationStatus {
        let status = PHPhotoLibrary.authorizationStatus()
        switch status {
        case .authorized:
            return status
        case .denied, .restricted:
            throw PHPhotoLibraryAuthorizationError.error(status)
        case .notDetermined:
            break
        }
        
        let semaphore = DispatchSemaphore(value: 0)
        
        PHPhotoLibrary.requestAuthorization{ _ in
            semaphore.signal()
        }
        
        semaphore.wait()
        
        let newStatus = PHPhotoLibrary.authorizationStatus()
        
        switch newStatus {
        case .authorized:
            return status
        case .denied, .restricted, .notDetermined:
            throw PHPhotoLibraryAuthorizationError.error(status)
        }
    }
	
}

struct DeviceInfo {
	
    struct Orientation {
        static var isLandscape: Bool {
            get {
                return UIDevice.current.orientation.isValidInterfaceOrientation ? UIDevice.current.orientation.isLandscape : UIApplication.shared.statusBarOrientation.isLandscape
            }
        }
        static var isPortrait: Bool {
            get {
                return UIDevice.current.orientation.isValidInterfaceOrientation ? UIDevice.current.orientation.isPortrait : UIApplication.shared.statusBarOrientation.isPortrait
            }
        }
    }
	
}
