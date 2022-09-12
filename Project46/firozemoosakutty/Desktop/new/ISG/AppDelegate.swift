//
//  AppDelegate.swift
//  tvOsSampleApp
//
//  Created by Firoze Moosakutty on 23/07/19.
//  Copyright © 2019 Firoze Moosakutty. All rights reserved.
//

import UIKit
import CoreData
import Alamofire
import AVFoundation
import AVKit
import AdSupport
import SwiftyStoreKit
import AppTrackingTransparency

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    let webViewClass : AnyObject.Type = NSClassFromString("UIWebView")!
     


    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
//        loadTabbar()
        let webViewClass: AnyObject.Type = NSClassFromString("UIWebView")!
        let webViewObject: NSObject.Type = webViewClass as! NSObject.Type
        let webView: AnyObject = webViewObject.init()
        let userAgent = webView.stringByEvaluatingJavaScript(from: "navigator.userAgent")
        print(userAgent!)
        let identifier = UIDevice.current.identifierForVendor?.uuidString

        
        UserDefaults.standard.set(userAgent, forKey: "userAgent")
        UserDefaults.standard.set(identifier, forKey: "UDID")
        UserDefaults.standard.set(UIDevice.modelName, forKey: "deviceModel")
        let currentDate = Int(Date().timeIntervalSince1970)
        let session_id = String(currentDate) + identifier!
        UserDefaults.standard.set(session_id, forKey: "session_id")
        UserDefaults.standard.set(UIDevice.modelName, forKey: "deviceModel")
        NSLog("UDID is : %@", identifier! as String)
        NSLog("useragent is : %@", userAgent! as String)
        NSLog("session_id is : %@", session_id as String)
       
        
        if #available(tvOS 14, *) {
            if !UserDefaults.standard.bool(forKey: "requestTrackingAuthorization") {
              UserDefaults.standard.setValue(true, forKey: "requestTrackingAuthorization")
              self.requestPermission()
            }
        }else{
            UserDefaults.standard.set(identifierForAdvertising(), forKey: "Idfa")
        }
        SwiftyStoreKit.completeTransactions(atomically: true) { purchases in
            for purchase in purchases {
                switch purchase.transaction.transactionState {
                case .purchased, .restored:
                    if purchase.needsFinishTransaction {
                        // Deliver content from server, then:
                        SwiftyStoreKit.finishTransaction(purchase.transaction)
                    }
                // Unlock content
                case .failed, .purchasing, .deferred:
                    break // do nothing
                }
            }
        }

        getIPAddressandlocation()
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(.playback, mode: .moviePlayback)
        }
        catch {
            print("Setting category to AVAudioSessionCategoryPlayback failed.")
        }
        // Override point for customization after application launch.
        return true
    }
    func requestPermission() {
        
        if #available(tvOS 14, *) {
            ATTrackingManager.requestTrackingAuthorization { status in
                switch status {
                case .authorized:
                    // Tracking authorization dialog was shown
                    // and we are authorized
                    print("Authorized")
                    
                    // Now that we are authorized we can get the IDFA
                    print(ASIdentifierManager.shared().advertisingIdentifier.uuidString)
                    UserDefaults.standard.set(ASIdentifierManager.shared().advertisingIdentifier.uuidString, forKey: "Idfa")

                case .denied:
                    // Tracking authorization dialog was
                    // shown and permission is denied
                    print("Denied")
                    print("idebtifier idfa",ASIdentifierManager.shared().advertisingIdentifier.uuidString)
                    UserDefaults.standard.set(ASIdentifierManager.shared().advertisingIdentifier.uuidString, forKey: "Idfa")
                case .notDetermined:
                    // Tracking authorization dialog has not been shown
                    print("Not Determined")
                    print("idebtifier idfa",ASIdentifierManager.shared().advertisingIdentifier.uuidString)
                    UserDefaults.standard.set(ASIdentifierManager.shared().advertisingIdentifier.uuidString, forKey: "Idfa")
                case .restricted:
                    print("Restricted")
                    print("idebtifier idfa",ASIdentifierManager.shared().advertisingIdentifier.uuidString)
                    UserDefaults.standard.set(ASIdentifierManager.shared().advertisingIdentifier.uuidString, forKey: "Idfa")
                @unknown default:
                    print("Unknown")
                    print("idebtifier idfa",ASIdentifierManager.shared().advertisingIdentifier.uuidString)
                    UserDefaults.standard.set(ASIdentifierManager.shared().advertisingIdentifier.uuidString, forKey: "Idfa")
                }
            }
        }
        
    }
    func identifierForAdvertising() -> String? {
        // Check whether advertising tracking is enabled
        guard ASIdentifierManager.shared().isAdvertisingTrackingEnabled else {
            return nil
        }

        // Get and return IDFA
        return ASIdentifierManager.shared().advertisingIdentifier.uuidString
    }
    func getIPAddressandlocation()  {
        ApiCommonClass.getIpandlocation { (responseDictionary: Dictionary) in
                if responseDictionary["error"] != nil {
                   UserDefaults.standard.set("103.71.169.219", forKey: "IPAddress")
                   UserDefaults.standard.set("IN", forKey: "countryCode")
                } else{
                  DispatchQueue.main.async {
                   
                  }
                }
              }
        
    }
    
    func loadTabbar(){
        
        let tabbarController = HomeTabBarViewController()
        tabbarController.tabBar.backgroundImage = UIImage(named: "")        // Create Tab one
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let tabOne =  storyboard.instantiateViewController(withIdentifier: "home") as! HomeViewController
        //let tabOne = HomeViewController()
        let tabOneBarItem = UITabBarItem(title: "Home", image: UIImage(named: "HomeTabBarOne"), selectedImage: UIImage(named: "HomeTabBarOne"))
        tabOne.tabBarItem = tabOneBarItem
        let nav1 = UINavigationController(rootViewController: tabOne)
        UITabBar.appearance().tintColor = UIColor().colorFromHexString("58AA28")
        
        // Create Tab two
        
        let tabTwo = storyboard.instantiateViewController(withIdentifier: "videoDetail") as! VideoDetailsViewController
        let tabBarItem2 = UITabBarItem(title: "Search", image: UIImage(named: "TVExcelSearchImage"), selectedImage: UIImage(named: "TVExcelSearchImage"))
        tabTwo.tabBarItem = tabBarItem2
        let nav2 = UINavigationController(rootViewController: tabTwo)
        
//        // Create Tab two
//        let tabThree = storyboard.instantiateViewController(withIdentifier: "allCategories") as! AllCategoryViewController
//        let tabBarItem3 = UITabBarItem(title: "Popular", image: UIImage(named: "icons8-cinema-24"), selectedImage: UIImage(named: "icons8-cinema-24"))
//        tabThree.tabBarItem = tabBarItem3
//        tabThree.fromTab = "true"
//        if UserDefaults.standard.string(forKey:"categoryId") != nil{
//            tabThree.categoryId = UserDefaults.standard.string(forKey:"categoryId")!
//        }else{
//            tabThree.categoryId = "3"
//        }
//        let nav3 = UINavigationController(rootViewController: tabThree)
//        // Create Tab two
//        let tabFour = storyboard.instantiateViewController(withIdentifier: "liveTab") as!  LiveTabViewController
//        let tabBarItem4 = UITabBarItem(title: "Live", image: UIImage(named: "icons8-play-button-circled-24"), selectedImage: UIImage(named: "icons8-play-button-circled-24"))
//        tabFour.tabBarItem = tabBarItem4
//        let nav4 = UINavigationController(rootViewController: tabFour)
        tabbarController.viewControllers = [nav1,nav2]
        
        //window?.rootViewController = UINavigationController(rootViewController: tabbarController)
        window?.rootViewController = tabbarController
        window?.makeKeyAndVisible()
//
       // UITabBar.appearance().backgroundImage = UIImage()
             //   UITabBar.appearance().barTintColor = UIColor.clear
 

//        var image = self.image(with: UIImage(named: "ZKFje"), scaledTo: CGSize(width: tabbarController.tabBar.frame.size.height + 1, height: tabbarController.tabBar.frame.size.height + 1))
//        var edgeInsets = UIEdgeInsets()
//        edgeInsets.left = (image?.size.width ?? 0.0) / 2
//        edgeInsets.top = 0.0
//        edgeInsets.right = (image?.size.width ?? 0.0) / 2 //this will be the constant portion in your image
//        edgeInsets.bottom = 0.0
//        image = image?.resizableImage(withCapInsets: edgeInsets)
//
//        UITabBar.appearance().backgroundImage = image
    }
    func image(with image: UIImage?, scaledTo newSize: CGSize) -> UIImage? {
        //UIGraphicsBeginImageContext(newSize);
        // In next line, pass 0.0 to use the current device's pixel scaling factor (and thus account for Retina resolution).
        // Pass 1.0 to force exact pixel size.
        UIGraphicsBeginImageContextWithOptions(newSize, _: false, _: 0.0)
        image?.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
    func applicationWillResignActive(_ application: UIApplication) {
        print("applicationWillResignActive")

        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        print("applicationDidEnterBackground")
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        
        DispatchQueue.global(qos: .background).async {
          print("NotificationApi.app_backGround_Event")

            //make your API call here
          NotificationApi.app_backGround_Event()
        }
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        print("applicationWillEnterForeground")

        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        print("applicationDidBecomeActive")

        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        print("applicationWillTerminate")
        NotificationApi.app_terminate_Event()

        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "tvOsSampleApp")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
 
}

