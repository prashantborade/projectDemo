//
//  CategoryListingVC.swift
//  Linkon
//
//  Created by Avion on 9/7/18.
//  Copyright © 2018 Avion. All rights reserved.
//

import UIKit
import Alamofire
import SVProgressHUD
import SDWebImage

class CategoryListingVC: UIViewController,UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var categoryListTableView: UITableView!
    var categoryList = [NSDictionary]()
    var categoryID:String!
    override func viewDidLoad() {
        super.viewDidLoad()

        getWebserviceData()
//        categoryListTableView.estimatedRowHeight = 68.0
//        categoryListTableView.rowHeight = UITableViewAutomaticDimension
        // Do any additional setup after loading the view.
        
        
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
        
        let userCellID = "CategoryListCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: userCellID, for: indexPath) as! CategoryListCell
        
   
        let obj = self.categoryList[indexPath.row]
        //configure cell
        cell.lblTitle.text = (obj.value(forKey: "shop_title") as? String)!
        cell.lblLocation.text = obj.value(forKey: "shop_location") as? String
       // cell.lblContactNo.text = obj.value(forKey: "shop_contact") as? String
        cell.lblDicription.text = obj.value(forKey: "shop_description") as? String
        cell.lblReviewCount.text = obj.value(forKey: "review") as? String
        let imgURL = (obj.value(forKey: "shop_logo") as? String)!
        cell.imgView?.sd_setImage(with: URL(string: imgURL), placeholderImage: UIImage(named: ""))
        let value = obj.value(forKey: "rating") as? Double
       // cell.RatingView.rating = value!
        print(cell.lblTitle.text)
        cell.cardView.setCardLayoutEffect()
     
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 180.0
    }
    // get WebServiceData
    func getWebserviceData()
    {
        
        if ApiManagerClass.sharedInstance.isConnectedToInternet() == true {
            
            SVProgressHUD.show()
            SVProgressHUD.setDefaultMaskType(.clear)
            var url = webConstant.baseUrl
            url.append(webConstant.categorylisting)
            
            let params:Dictionary  = ["categoryId":categoryID!]
            
             Alamofire.request(url, method: .post, parameters: params)
                .responseJSON {
                    response in
                    switch response.result {
                    case .success:
                     
                        if let JSON = response.result.value {
                            print("JSON register: \(JSON)")
                            let jsonResult: NSDictionary = response.result.value as! NSDictionary
                            if jsonResult["status"] as! NSNumber == 1
                            {
                                
                                self.categoryList = jsonResult["category_data"] as! Array
                                self.categoryListTableView.reloadData()
                                
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
                        
                        DispatchQueue.main.async {SVProgressHUD.dismiss()}
                        
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
