

//  MenuControllers.swift
//  Linkon
//
//  Created by Avion on 7/10/18.
//  Copyright © 2018 Avion. All rights reserved.
//

import UIKit
import SlideMenuControllerSwift

enum DashBoardMenu: Int {
    
    case SIGNIN = 0
    case HOME
    case LANGUAGE
    case MY_PLANS
//    case CATEGORIES
//    case FAVOURITES
//    case NOTIFICATIONS
    case HOW_LINKON_WORKS
    case ADVERTISE_WITH_US
    case SETTING
    case ABOUT_US
    case CONTACT_US
    
}

//Normal User

protocol NormalUserMenuProtocol : class {
    func changeViewController(_ menu: NormalUserMenu)
}

enum NormalUserMenu: Int {
    
    case HOME = 0
    //case PROFILE
   // case MANAGE_PROFILE
    case UPDATE_ACCOUNT
    case LANGUAGE
    case MY_PLANS
    case HOW_LINKON_WORKS
    //case MANAGE_MEDIA
    case SHARE
    case ADVERTISE_WITH_US
    case SETTING
    case ABOUT_US
    case CONTACT_US
    case LOGOUT
    
}

// Service Provider

//Normal User

protocol VendorUserMenuProtocol : class {
    func changeViewController(_ menu: VendorUserMenu)
}

enum VendorUserMenu: Int {
    
    case HOME = 0
    //case PROFILE
    case MANAGE_PROFILE
    case UPDATE_ACCOUNT
    case LANGUAGE
    case MY_PLANS
    case HOW_LINKON_WORKS
    case MANAGE_MEDIA
    case SHARE
    case ADVERTISE_WITH_US
    case SETTING
    case ABOUT_US
    case CONTACT_US
    case LOGOUT
//    case CATEGORIES
//    case FAVOURITES
//    case NOTIFICATIONS
    
   //
    
    
}

protocol DashBoardMenuProtocol : class {
    func changeViewController(_ menu: DashBoardMenu)
}

class MenuControllers: UIViewController,UITableViewDelegate,UITableViewDataSource{
    @IBOutlet weak var menuTableView: UITableView!
    @IBOutlet weak var imageProfile: UIImageView!
    
    @IBOutlet weak var lblUserProfileName: UILabel!
    
    var MenuTitle = [String]()
    var MenuTitleImage = [String]()
    
    var VendorMenuTitle = [String]()
    var VendorMenuImage = [String]()
    
    var DashboardTitle = [String]()
    var DashboardTitleImage = [String]()
    
    var signin :UIViewController!
    var signup :UIViewController!
    var homeVC: UIViewController!
    var vendorProfileVC: UIViewController!
    var EditVendorProfile: UIViewController!
    var updateProfile:UIViewController!
    var addGallery:UIViewController!
    var languageVC: UIViewController!
    var categoriesVC: UIViewController!
    var myPlansVC: UIViewController!
    var favouritesVC: UIViewController!
    var NotificationsVC: UIViewController!
    var HowLinkonWorksVC: UIViewController!
    var ShareVC: UIViewController!
    var AdvertiseWithUSVC: UIViewController!
    var SettingVC: UIViewController!
    var AboutUSVC:UIViewController!
    var ContactUSVC:UIViewController!
    var updateAccount: UIViewController!
    var logoutScreen: UIViewController!
    
    var user_type: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.imageProfile.makeCircle()
        
      
        
        if UserDefaults.standard.bool(forKey: "HomeVC")
        {
            
            let userData = UserDefaults.standard.object(forKey: "customerDataSignUp") as![String : AnyObject]
            user_type = (userData["user_type"] as? String)!
            
            if ( user_type == "service_provider") {
                
                lblUserProfileName.text =  UserDefaults.standard.object(forKey: "UserName") as? String
                
                VendorMenuTitle = ["HOME","MANAGE PROFILE","UPDATE ACCOUNT","LANGUAGE","MY PLANS","HOW LINKON WORKS","MANAGE MEDIA","SHARE","ADVERTISE WITH US","SETTING","ABOUT US","CONTACT US","LOGOUT"]
                
                VendorMenuImage = ["profile","profile","profile","lang","profile","plans","how","profile","ad","setting","setting","setting","logout"]
                
                let home = self.storyboard?.instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
                self.homeVC = UINavigationController(rootViewController: home)
                
//                let vendorProfile = self.storyboard?.instantiateViewController(withIdentifier: "VendorProfileVC") as! VendorProfileVC
//                    vendorProfile.isFromMenu = true
//                self.vendorProfileVC = UINavigationController(rootViewController: vendorProfile)
//
                let EditVendorProfile = self.storyboard?.instantiateViewController(withIdentifier: "EditVendorProfileVC") as! EditVendorProfileVC
                self.EditVendorProfile = UINavigationController(rootViewController: EditVendorProfile)
                
                let updateAccount = self.storyboard?.instantiateViewController(withIdentifier: "UpdateAccountVC") as! UpdateAccountVC
                self.updateAccount = UINavigationController(rootViewController: updateAccount)
                
                let Language = self.storyboard?.instantiateViewController(withIdentifier: "LanguageVC")as! LanguageVC
                self.languageVC = UINavigationController(rootViewController: Language)
                
                let myPlans = self.storyboard?.instantiateViewController(withIdentifier: "MyPlansVC")as! MyPlansVC
                self.myPlansVC = UINavigationController(rootViewController: myPlans)
                
                
                let addGallery = self.storyboard?.instantiateViewController(withIdentifier: "AddGalleryVC") as! AddGalleryVC
                
                self.addGallery = UINavigationController(rootViewController: addGallery)
                
             
                let shareVC = self.storyboard?.instantiateViewController(withIdentifier: "ShareVC") as! ShareVC
                self.ShareVC = UINavigationController(rootViewController: shareVC)
                
//                let categories = self.storyboard?.instantiateViewController(withIdentifier: "CategoriesVC")as! CategoriesVC
//
//                self.categoriesVC = UINavigationController(rootViewController: categories)
//
//                let favourites = self.storyboard?.instantiateViewController(withIdentifier: "FavouritesVC")as! FavouritesVC
//                self.favouritesVC = UINavigationController(rootViewController: favourites)
//
//                let notifications = self.storyboard?.instantiateViewController(withIdentifier: "NotificationsVC")as! NotificationsVC
//                self.NotificationsVC = UINavigationController(rootViewController: notifications)
                
                let howLinkonWorks = self.storyboard?.instantiateViewController(withIdentifier: "HowLinkonWorksVC")as! HowLinkonWorksVC
                self.HowLinkonWorksVC = UINavigationController(rootViewController: howLinkonWorks)
                
                let advertiseWithUS = self.storyboard?.instantiateViewController(withIdentifier: "AdvertiseWithUSVC")as! AdvertiseWithUSVC
                self.AdvertiseWithUSVC = UINavigationController(rootViewController: advertiseWithUS)
                
                let setting = self.storyboard?.instantiateViewController(withIdentifier: "SettingVC")as! SettingVC
                self.SettingVC = UINavigationController(rootViewController: setting)
                
                let aboutUS = self.storyboard?.instantiateViewController(withIdentifier: "AboutUSVC")as! AboutUSVC
                self.AboutUSVC = UINavigationController(rootViewController: aboutUS)
                
                let contactUS = self.storyboard?.instantiateViewController(withIdentifier: "ContactUSVC")as! ContactUSVC
                self.ContactUSVC = UINavigationController(rootViewController: contactUS)
                
                let logOut = self.storyboard?.instantiateViewController(withIdentifier: "SignInVC")as! SignInVC
                self.logoutScreen = UINavigationController(rootViewController: logOut)
                
            }
            else
            {
               
                lblUserProfileName.text =  UserDefaults.standard.object(forKey: "UserName") as? String
                
                MenuTitle = ["HOME","UPDATE ACCOUNT","LANGUAGE","MY PLANS","HOW LINKON WORKS","SHARE","ADVERTISE WITH US","SETTING","ABOUT US","CONTACT US","LOGOUT"]
                
                MenuTitleImage = ["profile","profile","lang","profile","plans","how","ad","setting","setting","setting","logout"]
                
                let home = self.storyboard?.instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
                self.homeVC = UINavigationController(rootViewController: home)
                
//                let vendorProfile = self.storyboard?.instantiateViewController(withIdentifier: "VendorProfileVC") as! VendorProfileVC
//                vendorProfile.isFromMenu = true
//                self.vendorProfileVC = UINavigationController(rootViewController: vendorProfile)
//
                //                let EditVendorProfile = self.storyboard?.instantiateViewController(withIdentifier: "EditVendorProfileVC") as! EditVendorProfileVC
                //                self.EditVendorProfile = UINavigationController(rootViewController: EditVendorProfile)
                
                let updateAccount = self.storyboard?.instantiateViewController(withIdentifier: "UpdateAccountVC") as! UpdateAccountVC
                self.updateAccount = UINavigationController(rootViewController: updateAccount)
                
                let Language = self.storyboard?.instantiateViewController(withIdentifier: "LanguageVC")as! LanguageVC
                self.languageVC = UINavigationController(rootViewController: Language)
                
                let myPlans = self.storyboard?.instantiateViewController(withIdentifier: "MyPlansVC")as! MyPlansVC
                self.myPlansVC = UINavigationController(rootViewController: myPlans)
                
                
//                let addGallery = self.storyboard?.instantiateViewController(withIdentifier: "AddGalleryVC") as! AddGalleryVC
//                self.addGallery = UINavigationController(rootViewController: addGallery)
                
                
                let shareVC = self.storyboard?.instantiateViewController(withIdentifier: "ShareVC") as! ShareVC
                self.ShareVC = UINavigationController(rootViewController: shareVC)
                
                //                let categories = self.storyboard?.instantiateViewController(withIdentifier: "CategoriesVC")as! CategoriesVC
                //
                //                self.categoriesVC = UINavigationController(rootViewController: categories)
                //
                //                let favourites = self.storyboard?.instantiateViewController(withIdentifier: "FavouritesVC")as! FavouritesVC
                //                self.favouritesVC = UINavigationController(rootViewController: favourites)
                //
                //                let notifications = self.storyboard?.instantiateViewController(withIdentifier: "NotificationsVC")as! NotificationsVC
                //                self.NotificationsVC = UINavigationController(rootViewController: notifications)
                
                let howLinkonWorks = self.storyboard?.instantiateViewController(withIdentifier: "HowLinkonWorksVC")as! HowLinkonWorksVC
                self.HowLinkonWorksVC = UINavigationController(rootViewController: howLinkonWorks)
                
                let advertiseWithUS = self.storyboard?.instantiateViewController(withIdentifier: "AdvertiseWithUSVC")as! AdvertiseWithUSVC
                self.AdvertiseWithUSVC = UINavigationController(rootViewController: advertiseWithUS)
                
                let setting = self.storyboard?.instantiateViewController(withIdentifier: "SettingVC")as! SettingVC
                self.SettingVC = UINavigationController(rootViewController: setting)
                
                let aboutUS = self.storyboard?.instantiateViewController(withIdentifier: "AboutUSVC")as! AboutUSVC
                self.AboutUSVC = UINavigationController(rootViewController: aboutUS)
                
                let contactUS = self.storyboard?.instantiateViewController(withIdentifier: "ContactUSVC")as! ContactUSVC
                self.ContactUSVC = UINavigationController(rootViewController: contactUS)
                
                
                let logOut = self.storyboard?.instantiateViewController(withIdentifier: "SignInVC")as! SignInVC
                self.logoutScreen = UINavigationController(rootViewController: logOut)
            }
            
            
            
        }
        else
        {
          //  ["SIGNIN","HOME","LANGUAGE","MY PLANS","CATEGORIES","FAVOURITES","NOTIFICATIONS","HOW LINKON WORKS","ADVERTISE WITH US","SETTING"]
            
            DashboardTitle = ["SIGNIN","HOME","LANGUAGE","MY PLANS","HOW LINKON WORKS","ADVERTISE WITH US","SETTING","ABOUT US","CONTACT US",]
            DashboardTitleImage = ["cate","fev","lang","plans","how","ad","setting","setting","setting"]
            
            
           // ["cate","fev","lang","plans","cate","fev","noti","how","ad","setting"]
            
            let signin = self.storyboard?.instantiateViewController(withIdentifier: "SignInVC") as! SignInVC
            self.signin = UINavigationController(rootViewController: signin)
            
            let home = self.storyboard?.instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
            self.homeVC = UINavigationController(rootViewController: home)
            
            let Language = self.storyboard?.instantiateViewController(withIdentifier: "LanguageVC")as! LanguageVC
            self.languageVC = UINavigationController(rootViewController: Language)
            
            let myPlans = self.storyboard?.instantiateViewController(withIdentifier: "MyPlansVC")as! MyPlansVC
            self.myPlansVC = UINavigationController(rootViewController: myPlans)
            
//            let categories = self.storyboard?.instantiateViewController(withIdentifier: "CategoriesVC")as! CategoriesVC
//
//            self.categoriesVC = UINavigationController(rootViewController: categories)
//
//            let favourites = self.storyboard?.instantiateViewController(withIdentifier: "FavouritesVC")as! FavouritesVC
//            self.favouritesVC = UINavigationController(rootViewController: favourites)
//
//            let notifications = self.storyboard?.instantiateViewController(withIdentifier: "NotificationsVC")as! NotificationsVC
//            self.NotificationsVC = UINavigationController(rootViewController: notifications)
            
            let howLinkonWorks = self.storyboard?.instantiateViewController(withIdentifier: "HowLinkonWorksVC")as! HowLinkonWorksVC
            self.HowLinkonWorksVC = UINavigationController(rootViewController: howLinkonWorks)
            
            let advertiseWithUS = self.storyboard?.instantiateViewController(withIdentifier: "AdvertiseWithUSVC")as! AdvertiseWithUSVC
            self.AdvertiseWithUSVC = UINavigationController(rootViewController: advertiseWithUS)
            
            let setting = self.storyboard?.instantiateViewController(withIdentifier: "SettingVC")as! SettingVC
            self.SettingVC = UINavigationController(rootViewController: setting)
            
            let aboutUS = self.storyboard?.instantiateViewController(withIdentifier: "AboutUSVC")as! AboutUSVC
            self.AboutUSVC = UINavigationController(rootViewController: aboutUS)
            
            let contactUS = self.storyboard?.instantiateViewController(withIdentifier: "ContactUSVC")as! ContactUSVC
            self.ContactUSVC = UINavigationController(rootViewController: contactUS)
            
            
        }
     
    }
    @IBAction func btnSideMenuCloseClicked(_ sender: Any) {
        
        self.slideMenuController()?.closeLeft()
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    // UITableview Datasource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if UserDefaults.standard.bool(forKey: "HomeVC")
        {
            if ( user_type == "service_provider") {
                
                return VendorMenuTitle.count
            }
            else
            {
                 return MenuTitle.count
            }
            
           
        }
        else
        {
            return DashboardTitle.count
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if UserDefaults.standard.bool(forKey: "HomeVC")
        {
            
            if( user_type == "service_provider") {
            
                let cell = tableView.dequeueReusableCell(withIdentifier: "MenuCell", for: indexPath) as! MenuCell
                cell.lblTitle.text = VendorMenuTitle[indexPath.row]
                cell.lblTitle.textColor = UIColor.white
                let imageName = VendorMenuImage[indexPath.row]
                cell.imageView?.image = UIImage(named: imageName)
                
                return cell
            }
            else
            {
                let cell = tableView.dequeueReusableCell(withIdentifier: "MenuCell", for: indexPath) as! MenuCell
                cell.lblTitle.text = MenuTitle[indexPath.row]
                cell.lblTitle.textColor = UIColor.white
                let imageName = MenuTitleImage[indexPath.row]
                cell.imageView?.image = UIImage(named: imageName)
                
                return cell
            }
            
         
        }
        else{
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "MenuCell", for: indexPath) as! MenuCell
            cell.lblTitle.text = DashboardTitle[indexPath.row]
            cell.lblTitle.textColor = UIColor.white
            let imageName = DashboardTitleImage[indexPath.row]
            cell.imageView?.image = UIImage(named: imageName)
            
            return cell
        }
        
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("tapped",indexPath.row)
        
        if UserDefaults.standard.bool(forKey: "HomeVC")
        {
            
             if( user_type == "service_provider") {
                
                if let menu = VendorUserMenu(rawValue: indexPath.row) {
                    self.changeViewController(menu)
                }
             }
            else
             {
                
                if let menu = NormalUserMenu(rawValue: indexPath.row) {
                    self.changeViewController(menu)
                }
             }
            
           
        }
        else
        {
            if let menu = DashBoardMenu(rawValue: indexPath.row) {
                self.changeViewController(menu)
            }
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        
     return 100
    }
    
    func changeViewController(_ menu: DashBoardMenu) {
    
        switch menu {
            
        case .SIGNIN:
            
            self.slideMenuController()?.changeMainViewController(self.signin, close: true)
            
        case .HOME :
            self.slideMenuController()?.changeMainViewController(self.homeVC, close: true)
     
        case .LANGUAGE:
            self.slideMenuController()?.changeMainViewController(self.languageVC, close: true)
            
        
//        case .CATEGORIES:
//            self.slideMenuController()?.changeMainViewController(self.categoriesVC, close: true)
//
//        case .FAVOURITES:
//            self.slideMenuController()?.changeMainViewController(self.favouritesVC, close: true)
//
//        case .NOTIFICATIONS:
//            self.slideMenuController()?.changeMainViewController(self.NotificationsVC, close: true)
            
        case .MY_PLANS:
            self.slideMenuController()?.changeMainViewController(self.myPlansVC, close: true)
            
        case .HOW_LINKON_WORKS:
            self.slideMenuController()?.changeMainViewController(self.HowLinkonWorksVC, close: true)
            
        case .ADVERTISE_WITH_US:
            self.slideMenuController()?.changeMainViewController(self.AdvertiseWithUSVC, close: true)
            
        case .SETTING:
            self.slideMenuController()?.changeMainViewController(self.SettingVC, close: true)
            
        case .ABOUT_US:
            self.slideMenuController()?.changeMainViewController(self.AboutUSVC, close: true)
            
        case .CONTACT_US:
            self.slideMenuController()?.changeMainViewController(self.ContactUSVC, close: true)
            
            
            
        }
    }
    func changeViewController(_ menu: NormalUserMenu) {
        switch menu {
            
        case .HOME :
            self.slideMenuController()?.changeMainViewController(self.homeVC, close: true)
            
            //        case .PROFILE:
            //            self.slideMenuController()?.changeMainViewController(self.vendorProfileVC, close: true)
            
//        case .MANAGE_PROFILE:
//            self.slideMenuController()?.changeMainViewController(self.vendorProfileVC, close: true)
            
        case .UPDATE_ACCOUNT:
            self.slideMenuController()?.changeMainViewController(self.updateAccount, close: true)
            
        case .LANGUAGE:
            self.slideMenuController()?.changeMainViewController(self.languageVC, close: true)
            
        case .MY_PLANS:
            self.slideMenuController()?.changeMainViewController(self.myPlansVC, close: true)
            
        case .HOW_LINKON_WORKS:
            self.slideMenuController()?.changeMainViewController(self.HowLinkonWorksVC, close: true)
            
//        case .MANAGE_MEDIA:
//            self.slideMenuController()?.changeMainViewController(self.addGallery, close: true)
            
        case .SHARE:
            self.slideMenuController()?.changeMainViewController(self.ShareVC, close: true)
            
        case .ADVERTISE_WITH_US:
            self.slideMenuController()?.changeMainViewController(self.AdvertiseWithUSVC, close: true)
    
        case .SETTING:
            self.slideMenuController()?.changeMainViewController(self.SettingVC, close: true)
            
        case .ABOUT_US:
            self.slideMenuController()?.changeMainViewController(self.AboutUSVC, close: true)
            
        case .CONTACT_US:
            self.slideMenuController()?.changeMainViewController(self.ContactUSVC, close: true)
            
            //        case .CATEGORIES:
            //            self.slideMenuController()?.changeMainViewController(self.categoriesVC, close: true)
            //
            //        case .FAVOURITES:
            //            self.slideMenuController()?.changeMainViewController(self.favouritesVC, close: true)
            //
            //        case .NOTIFICATIONS:
            //            self.slideMenuController()?.changeMainViewController(self.NotificationsVC, close: true)
            
            //        case .SETTING:
            //            self.slideMenuController()?.changeMainViewController(self.SettingVC, close: true)
            
        case .LOGOUT:
            popupAlert(title: "Logout", message: "Do you want to logout app ?", actionTitles: ["Yes","No"], actions: [{ (action1) in
                // GIDSignIn.sharedInstance().signOut()
                UserDefaults.standard.set(false, forKey: "HomeVC")
                self.slideMenuController()?.changeMainViewController(self.logoutScreen, close: true)
                
                let objAppDelegate = (UIApplication.shared.delegate as? AppDelegate)
                objAppDelegate?.gotoMainController()
                },{(action2) in
                    
                }])
        
        }
    }
    
    // Vendor
    
    func changeViewController(_ menu: VendorUserMenu) {
        
        switch menu {
            
        case .HOME :
            self.slideMenuController()?.changeMainViewController(self.homeVC, close: true)
            
//        case .PROFILE:
//            self.slideMenuController()?.changeMainViewController(self.vendorProfileVC, close: true)
            
        case .MANAGE_PROFILE:
            self.slideMenuController()?.changeMainViewController(self.EditVendorProfile, close: true)
            
        case .UPDATE_ACCOUNT:
            self.slideMenuController()?.changeMainViewController(self.updateAccount, close: true)
            
        case .LANGUAGE:
            self.slideMenuController()?.changeMainViewController(self.languageVC, close: true)
            
        case .MY_PLANS:
            self.slideMenuController()?.changeMainViewController(self.myPlansVC, close: true)
            
        case .HOW_LINKON_WORKS:
            self.slideMenuController()?.changeMainViewController(self.HowLinkonWorksVC, close: true)
            
        case .MANAGE_MEDIA:
            self.slideMenuController()?.changeMainViewController(self.addGallery, close: true)
        
        case .SHARE:
             self.slideMenuController()?.changeMainViewController(self.ShareVC, close: true)
      
        case .ADVERTISE_WITH_US:
            self.slideMenuController()?.changeMainViewController(self.AdvertiseWithUSVC, close: true)
            
        case .SETTING:
            self.slideMenuController()?.changeMainViewController(self.SettingVC, close: true)
            
        case .ABOUT_US:
            self.slideMenuController()?.changeMainViewController(self.AboutUSVC, close: true)

        case .CONTACT_US:
            self.slideMenuController()?.changeMainViewController(self.ContactUSVC, close: true)
            
//        case .NOTIFICATIONS:
//            self.slideMenuController()?.changeMainViewController(self.NotificationsVC, close: true)
            
        case .LOGOUT:
            popupAlert(title: "Logout", message: "Do you want to logout app ?", actionTitles: ["Yes","No"], actions: [{ (action1) in
                // GIDSignIn.sharedInstance().signOut()
                UserDefaults.standard.set(false, forKey: "HomeVC")
                self.slideMenuController()?.changeMainViewController(self.logoutScreen, close: true)
                
                let objAppDelegate = (UIApplication.shared.delegate as? AppDelegate)
                objAppDelegate?.gotoMainController()
                },{(action2) in
                    
                }])
            
        }
    }
    
    
}
