//
//  AppDelegate.swift
//  TagIt
//
//  Created by 신재혁 on 11/02/2019.
//  Copyright © 2019 ninetyfivejae. All rights reserved.
//

import UIKit
import Photos

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        

        
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    //MARK:- PHOTO LIBRARY ACCESS CHECK
    func photoLibraryAvailabilityCheck() {
        if PHPhotoLibrary.authorizationStatus() == PHAuthorizationStatus.authorized {
            
        } else {
            PHPhotoLibrary.requestAuthorization(requestAuthorizationHandler)
        }
    }
    
    func requestAuthorizationHandler(status: PHAuthorizationStatus) {
        if PHPhotoLibrary.authorizationStatus() == PHAuthorizationStatus.authorized {
            
        } else {
            alertToEncouragePhotoLibraryAccessWhenApplicationStarts()
        }
    }
    
    //MARK:- CAMERA & GALLERY NOT ALLOWING ACCESS - ALERT
    func alertToEncourageCameraAccessWhenApplicationStarts() {
        //Camera not available - Alert
        let internetUnavailableAlertController = UIAlertController (title: "Camera Unavailable", message: "Please check to see if it is disconnected or in use by another application", preferredStyle: .alert)
        
        let settingsAction = UIAlertAction(title: "Settings", style: .destructive) { (_) -> Void in
            let settingsUrl = NSURL(string: UIApplication.openSettingsURLString)
            if let url = settingsUrl {
                DispatchQueue.main.async {
                    UIApplication.shared.open(url as URL, options: [:], completionHandler: nil) //(url as URL)
                }
                
            }
        }
        let cancelAction = UIAlertAction(title: "Okay", style: .default, handler: nil)
        internetUnavailableAlertController .addAction(settingsAction)
        internetUnavailableAlertController .addAction(cancelAction)
        self.window?.rootViewController!.present(internetUnavailableAlertController , animated: true, completion: nil)
    }
    
    func alertToEncouragePhotoLibraryAccessWhenApplicationStarts() {
        //Photo Library not available - Alert
        let cameraUnavailableAlertController = UIAlertController (title: "Photo Library Unavailable", message: "Please check to see if device settings doesn't allow photo library access", preferredStyle: .alert)
        
        let settingsAction = UIAlertAction(title: "Settings", style: .destructive) { (_) -> Void in
            let settingsUrl = NSURL(string: UIApplication.openSettingsURLString)
            if let url = settingsUrl {
                UIApplication.shared.open(url as URL, options: [:], completionHandler: nil)
            }
        }
        let cancelAction = UIAlertAction(title: "Okay", style: .default, handler: nil)
        cameraUnavailableAlertController .addAction(settingsAction)
        cameraUnavailableAlertController .addAction(cancelAction)
        self.window?.rootViewController!.present(cameraUnavailableAlertController , animated: true, completion: nil)
    }

}
