//
//  AppDelegate.swift
//  Linkon
//
//  Created by Avion on 7/10/18.
//  Copyright © 2018 Avion. All rights reserved.
//

import UIKit
import CoreData
import SlideMenuControllerSwift
import IQKeyboardManager
import GoogleSignIn
import FBSDKLoginKit
import FacebookCore
import GoogleMaps
import GooglePlaces



@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate{
  
    var window: UIWindow?
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch
        IQKeyboardManager.shared().isEnabled = true
        UIApplication.shared.statusBarStyle = .default
        //for Google Map
    
         setUpGoogleMaps()
//        GMSServices.provideAPIKey("AIzaSyC6un27g4VHQPBQH-E89OiwTmFO8kOVX_U")
//        GMSPlacesClient.provideAPIKey("AIzaSyC6un27g4VHQPBQH-E89OiwTmFO8kOVX_U")
        
        // for Google Sign
        // Initialize sign-in
        GIDSignIn.sharedInstance().clientID = "71373218813-kj9ce64ppbsheubt6ad6qt61e8nipubu.apps.googleusercontent.com"
        
//        if UserDefaults.standard.bool(forKey: "HomeVC"){
//            gotoMainController()
//        }else{
//            gotSigInController()
//        }
        
         gotoMainController()
        
        return true
    }
    
    func setUpGoogleMaps() {
        let googleMapsApiKey = "AIzaSyBMUm-KXWAU0iQoirUzhdLQxszuH0s8eNE"
        GMSServices.provideAPIKey(googleMapsApiKey)
        GMSPlacesClient.provideAPIKey("AIzaSyBMUm-KXWAU0iQoirUzhdLQxszuH0s8eNE")
    }
    func gotoMainController(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let ProfileVC = storyboard.instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
        let leftViewController = storyboard.instantiateViewController(withIdentifier: "MenuControllers") as! MenuControllers
        let nvc: UINavigationController = UINavigationController(rootViewController: ProfileVC)
        
        leftViewController.vendorProfileVC = nvc
  
        let slideMenuController = SlideMenuController(mainViewController: nvc, leftMenuViewController: leftViewController)
        self.window?.rootViewController = slideMenuController
        self.window?.makeKeyAndVisible()
    }
    
    func gotoFavouritesVC(){
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
    
        let FavouritesVC = storyboard.instantiateViewController(withIdentifier: "FavouritesVC") as! FavouritesVC
        let leftViewController = storyboard.instantiateViewController(withIdentifier: "MenuControllers") as! MenuControllers
        let nvc: UINavigationController = UINavigationController(rootViewController: FavouritesVC)
        
        leftViewController.homeVC = nvc
        
        let slideMenuController = SlideMenuController(mainViewController: nvc, leftMenuViewController: leftViewController)
        self.window?.rootViewController = slideMenuController
        self.window?.makeKeyAndVisible()
    }
    func gotoNotificationVC(){
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)

        let NotificationsVC = storyboard.instantiateViewController(withIdentifier: "NotificationsVC") as! NotificationsVC
        let leftViewController = storyboard.instantiateViewController(withIdentifier: "MenuControllers") as! MenuControllers
        let nvc: UINavigationController = UINavigationController(rootViewController: NotificationsVC)
        
        leftViewController.homeVC = nvc
        
        let slideMenuController = SlideMenuController(mainViewController: nvc, leftMenuViewController: leftViewController)
        self.window?.rootViewController = slideMenuController
        self.window?.makeKeyAndVisible()
    }
    func gotoAllCategoryListingVC(){
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let NotificationsVC = storyboard.instantiateViewController(withIdentifier: "AllCategoryListingVC") as! AllCategoryListingVC
        let leftViewController = storyboard.instantiateViewController(withIdentifier: "MenuControllers") as! MenuControllers
        let nvc: UINavigationController = UINavigationController(rootViewController: NotificationsVC)
        
        leftViewController.homeVC = nvc
        
        let slideMenuController = SlideMenuController(mainViewController: nvc, leftMenuViewController: leftViewController)
        self.window?.rootViewController = slideMenuController
        self.window?.makeKeyAndVisible()
    }
    func gotSigInController()
    {
//        let mainStoryboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
//        let objController = mainStoryboard.instantiateViewController(withIdentifier: "SignInVC") as? SignInVC
//        let navController = UINavigationController(rootViewController: objController!)
//        navController.navigationBar.isHidden = true
//        self.window?.rootViewController = navController
//        self.window?.makeKeyAndVisible()
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let ProfileVC = storyboard.instantiateViewController(withIdentifier: "SignInVC") as! SignInVC
        let leftViewController = storyboard.instantiateViewController(withIdentifier: "MenuControllers") as! MenuControllers
        let nvc: UINavigationController = UINavigationController(rootViewController: ProfileVC)
    
        leftViewController.vendorProfileVC = nvc
        
        let slideMenuController = SlideMenuController(mainViewController: nvc, leftMenuViewController: leftViewController)
        self.window?.rootViewController = slideMenuController
        self.window?.makeKeyAndVisible()
    }
    
//    func gotoDashboardController(){
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//
//        let ProfileVC = storyboard.instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
//        let leftViewController = storyboard.instantiateViewController(withIdentifier: "DashboardVC") as! DashboardVC
//        let nvc: UINavigationController = UINavigationController(rootViewController: ProfileVC)
//
//        leftViewController.signIn = nvc
//
//        let slideMenuController = SlideMenuController(mainViewController: nvc, leftMenuViewController: leftViewController)
//        self.window?.rootViewController = slideMenuController
//        self.window?.makeKeyAndVisible()
//    }
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        if  UserDefaults.standard.string(forKey: "isLoginFrom") == "Facebook"
        {
            return SDKApplicationDelegate.shared.application(application,
                                                             open: url,
                                                             sourceApplication: sourceApplication,
                                                             annotation: annotation)
            
        }else if  UserDefaults.standard.string(forKey: "isLoginFrom") == "Google"
        {
            var options: [String: AnyObject] = [UIApplicationOpenURLOptionsKey.sourceApplication.rawValue: sourceApplication as AnyObject,
                                                UIApplicationOpenURLOptionsKey.annotation.rawValue: annotation as AnyObject]
            return GIDSignIn.sharedInstance().handle(url as URL!,
                                                     sourceApplication: sourceApplication,
                                                     annotation: annotation)
            
        }
        
        return true
        
    }
    
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        
        if  UserDefaults.standard.string(forKey: "isLoginFrom") == "Google"
        {
            return  GIDSignIn.sharedInstance().handle(url, sourceApplication:options[UIApplicationOpenURLOptionsKey.sourceApplication] as? String, annotation: [:])
        }
       
        return true
    }
    func applicationProtectedDataDidBecomeAvailable(_ application: UIApplication)
    {
        FBSDKAppEvents.activateApp()
    }
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
     
        GIDSignIn.sharedInstance().signOut()
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
        // Saves changes in the application's managed object context before the application terminates.
       self.saveContext()
    }

    // MARK: - Core Data stack

        var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "Linkon")
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


