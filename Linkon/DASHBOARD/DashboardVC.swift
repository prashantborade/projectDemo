////
////  DashboardVC.swift
////  Linkon
////
////  Created by Avion on 8/17/18.
////  Copyright © 2018 Avion. All rights reserved.
////
//
//import UIKit
//import SlideMenuControllerSwift
//
//
//enum DashBoardMenu: Int {
//    
//    case SIGNIN = 0
//    case SIGNUP
// 
//}
//protocol DashBoardMenuProtocol : class {
//    func changeViewController(_ menu: DashBoardMenu)
//}
//
//class DashboardVC: UIViewController,UITableViewDelegate,UITableViewDataSource {
//    
//    @IBOutlet weak var appLogo: UIImageView!
//    
//    var MenuTitle = [String]()
//    var MenuTitleImage = [String]()
//    var signIn: UIViewController!
//    var signUp: UIViewController!
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        self.appLogo.makeCircle()
//        MenuTitle = ["SIGNIN","SIGNUP"]
//        MenuTitleImage = ["profile","profile"]
//        
//        let signIn = self.storyboard?.instantiateViewController(withIdentifier: "SignInVC") as! SignInVC
//        self.signIn = UINavigationController(rootViewController: signIn)
//        
//        let signUp = self.storyboard?.instantiateViewController(withIdentifier: "SignUpVC") as! SignUpVC
//        self.signUp = UINavigationController(rootViewController: signUp)
//
//
//    }
//    
//    func numberOfSections(in tableView: UITableView) -> Int {
//        
//        return 1
//    }
//    // UITableview Datasource
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        
//        return MenuTitle.count
//    }
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        
//        let cell = tableView.dequeueReusableCell(withIdentifier: "DashboardCell", for: indexPath) as! DashboardCell
//        cell.lblTitle.text = MenuTitle[indexPath.row]
//        cell.lblTitle.textColor = UIColor.white
//        let imageName = MenuTitleImage[indexPath.row]
//        cell.imageView?.image = UIImage(named: imageName)
//        
//        return cell
//    }
//    
//    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        print("tapped",indexPath.row)
//        if let menu = DashBoardMenu(rawValue: indexPath.row) {
//            self.changeViewController(menu)
//        }
//        
//    }
//    
//    
//    func changeViewController(_ menu: DashBoardMenu) {
//        
//        switch menu {
//            
//        case .SIGNIN:
//            
//            self.slideMenuController()?.changeMainViewController(self.signIn, close: true)
//            
//        case .SIGNUP:
//            
//            self.slideMenuController()?.changeMainViewController(self.signUp, close: true)
//      
//    
//        }
//    }
//
//   
//
//   
//
//}
