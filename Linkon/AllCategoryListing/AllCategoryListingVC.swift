//
//  AllCategoryListingVC.swift
//  
//
//  Created by Avion on 9/11/18.
//

import UIKit
import SwiftyJSON
import Alamofire
import SVProgressHUD
import SDWebImage


class AllCategoryListingVC: UIViewController,UITableViewDelegate,UITabBarDelegate, UITableViewDataSource,UIPopoverPresentationControllerDelegate {

    
    var jsonData : JSON = JSON.null
    
    @IBOutlet weak var categoriesTableView: UITableView!
 
    @IBOutlet weak var tabBarAllCategories: UITabBar!
    var categoryList = NSMutableArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if UserDefaults.standard.bool(forKey: "HomeVC")
        {
           
            getCategoryListCall()
            self.categoriesTableView.isHidden = false
        }
        else
        {
            showMessage()
            self.categoriesTableView.isHidden = true
        }
        
        
        
        setNavigationBarItem()
        title = "Categories"
        // set home tab Bar
        tabBarAllCategories.selectedItem = tabBarAllCategories.items![1] as UITabBarItem
        
        // Do any additional setup after loading the view.
    }
    func showMessage()
    {
        let lblMessage =  UILabel(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 200))
        lblMessage.center = self.view.center
        lblMessage.text = "Sorry!!! Your not sign in."
        lblMessage.textAlignment = .center
        lblMessage.numberOfLines = 0
        lblMessage.textColor = UIColor.red
        self.view.addSubview(lblMessage)
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    // UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.categoryList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        let userCellID = "AllCategoryCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: userCellID, for: indexPath) as! AllCategoryCell
        
        //configure cell
        let obj:NSDictionary = self.categoryList[indexPath.row] as! NSDictionary
    
        cell.categoryTitle.text = obj.value(forKey: CategoryDataKeys.categoryName.rawValue) as? String
        let imgURL = obj.value(forKey: CategoryDataKeys.categoryThumbImage.rawValue) as? String

        if (imgURL == nil || (imgURL?.isEmpty)!)
        {
            cell.imgView.image = UIImage(named: "NoImage")
        }
        else {
            cell.imgView.sd_setImage(with: URL(string: imgURL!), placeholderImage: UIImage(named: ""))

        }

        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 60.0
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let obj:NSDictionary = self.categoryList[indexPath.row] as! NSDictionary
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let categororyListingVC = storyboard.instantiateViewController(withIdentifier: "CategoryListingVC") as! CategoryListingVC
        categororyListingVC.categoryID = (obj.value(forKey: CategoryDataKeys.categoryId.rawValue) as? String)!
        self.navigationController?.pushViewController(categororyListingVC, animated: true)
    }
    
    @IBAction func btnShowPopupClicked(_ sender: UIButton) {
        
        let controller = storyboard?.instantiateViewController(withIdentifier: "AddPopOverVC") as! AddPopOverVC
        controller.preferredContentSize = CGSize(width: 300, height: 250)
        showPopup(controller, sourceView: sender)
        
    }
    private func showPopup(_ controller: UIViewController, sourceView: UIView) {
        let presentationController = AlwaysPresentAsPopover.configurePresentation(forController: controller)
        presentationController.sourceView = sourceView
        presentationController.sourceRect = sourceView.bounds
        presentationController.permittedArrowDirections = [.down, .up]
        self.present(controller, animated: true)
    }
    //MARK: UITabBarDelegate Method
    
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        
        if (item.tag == 0){
            
            let objAppDelegate = (UIApplication.shared.delegate as? AppDelegate)
            objAppDelegate?.gotoMainController()
        }
        else if (item.tag == 1)
        {
            let objAppDelegate = (UIApplication.shared.delegate as? AppDelegate)
            objAppDelegate?.gotoAllCategoryListingVC()
        }
        else if (item.tag == 2)
        {
            
        }
        else if (item.tag == 3)
        {
            let objAppDelegate = (UIApplication.shared.delegate as? AppDelegate)
            objAppDelegate?.gotoFavouritesVC()
        }
        else if (item.tag == 4)
        {
            let objAppDelegate = (UIApplication.shared.delegate as? AppDelegate)
            objAppDelegate?.gotoNotificationVC()
            
        }
        
    }
    
    
//    //MARK:- WebService call
//    func CallcategoryList(){
//        var url = webConstant.baseUrl
//        url.append(webConstant.Homepage)
//
//        requestGETURL(url, params: nil, success: { (jsonResult) in
//
//            print("Successful response",jsonResult)
//
//            if (jsonResult["status"].boolValue) {
//
//            self.categoryList = jsonResult["category_data"] as! [[String : AnyObject]]
//
//
//             DispatchQueue.main.async(execute: {() -> Void in self.categoriesTableView.reloadData() })
//
//            }
//            else
//            {
//
//            }
//
//
//        }) { (error) in
//            print(error)
//        }
//    }
//
    
    // get WebServiceData
    func getCategoryListCall()
    {
        
        if ApiManagerClass.sharedInstance.isConnectedToInternet() == true {
            SVProgressHUD.show()
            SVProgressHUD.setDefaultMaskType(.clear)
            
            var url = webConstant.baseUrl
            url.append(webConstant.Homepage)
            
            Alamofire.request(url, method: .get)
                .responseJSON {
                    response in
                    switch response.result {
                    case .success:
                        print(response)
                    
                        if let JSON = response.result.value {
                            print("JSON register: \(JSON)")
                            let jsonResult: NSDictionary = response.result.value as! NSDictionary
                            if jsonResult["status"] as! NSNumber == 1
                            {
                                
                                let categoryData:NSDictionary = jsonResult["category_data"] as!NSDictionary
                                self.categoryList.removeAllObjects()
                                
                                for str in categoryData {
                                    
                                    self.categoryList.add(str.value)
                                }
                                
                                 DispatchQueue.main.async(execute: {() -> Void in self.categoriesTableView.reloadData() })
                                 DispatchQueue.main.async {SVProgressHUD.dismiss()}
                            }else
                            {
                                DispatchQueue.main.async {SVProgressHUD.dismiss()}
                                
                                let message:String = jsonResult["msg"] as! String
                                ApiManagerClass.sharedInstance.showMessage(title: NSLocalizedString("Linkon", comment: ""), msg: message, on: self)
                            }
                        }
                        else
                        {
                            ApiManagerClass.sharedInstance.showMessage(title: NSLocalizedString("Linkon", comment: ""), msg: NSLocalizedString("somethingwrong", comment: ""), on: self)
                        }
                        break
                    case .failure(let error):
                        print(error)
                        
                       DispatchQueue.main.async {SVProgressHUD.dismiss()}
                        
                        ApiManagerClass.sharedInstance.showMessage(title: NSLocalizedString("Linkon", comment: ""), msg: NSLocalizedString("ServerError", comment: ""), on: self)
                    }
            }
            
        }else{
            
            ApiManagerClass.sharedInstance.showMessage(title: NSLocalizedString("Linkon", comment: ""), msg: NSLocalizedString("internercheck", comment: ""), on: self)
            
        }
        
    }
    
    
    
    
  
}
