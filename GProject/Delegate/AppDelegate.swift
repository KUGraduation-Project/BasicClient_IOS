//
//  AppDelegate.swift
//  GProject
//
//  Created by 서정 on 2021/07/11.
//

import UIKit
import CoreData

import RxKakaoSDKCommon
import IQKeyboardManagerSwift

@main
class AppDelegate: UIResponder, UIApplicationDelegate {


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        RxKakaoSDKCommon.initSDK(appKey: "1b0c47ff5a86ac6ba28be58895f5f89d")
        
        IQKeyboardManager.shared.enable = true
        
        
        UserDefaults.standard.register(defaults: ["cacheImage" : [String: Data]()])
        
//        DispatchQueue.global(qos: .background).async {
//            var cache = (UserDefaults.standard.dictionary(forKey: "cacheImage") as? [String:Data]) ?? [String :Data]()
//            
//            
//            VirtualObject.availableObjects.forEach { model  in
//                print("making cache thumbnail image")
//                if cache.filter({ $0.key == model.modelName }).count == 0, let image = ARQLThumbnailGenerator().thumbnail(for: model.referenceURL, size: CGSize(width: 100, height: 100)) {
//                    cache[model.modelName] = image.jpegData(compressionQuality: 0.5)!
//                }
//            }
//            print("making cache thumbnail image has finished")
//            UserDefaults.standard.setValue(cache, forKey: "cacheImage")
//        }
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "GProject")
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

