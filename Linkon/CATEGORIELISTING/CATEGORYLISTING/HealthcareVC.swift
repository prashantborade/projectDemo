
//
//  HealthcareVC.swift
//  Linkon
//
//  Created by Avion on 7/26/18.
//  Copyright © 2018 Avion. All rights reserved.
//

import UIKit
import Alamofire
import SVProgressHUD
import SwiftyJSON
import SDWebImage


class HealthcareVC: UIViewController,UITableViewDelegate,UITableViewDataSource {
    var refreshControl = UIRefreshControl()
    
    var jsonResponse:JSON = JSON.null
    var categories:[ProductData] = []
    
    @IBOutlet weak var tableCategory: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        getWebserviceData()
        setNavigationBarItem()
        // add back button
        let backBtn = UIBarButtonItem(image: UIImage(named: "left_arrow"), style: .plain, target: self, action: #selector(self.backBtnAction))
        navigationItem.leftBarButtonItem = backBtn
        self.navigationController?.isNavigationBarHidden = false
        self.title = "Category"
        
        // for refresh controller
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        
        refreshControl.addTarget(self, action: #selector(HealthcareVC.refresh(sender:)), for: UIControlEvents.valueChanged)
        tableCategory.addSubview(refreshControl)
        
        // Do any additional setup after loading the view.
    
    }
  
    @objc func refresh(sender:AnyObject) {
     //   getHabitListCall()
        refreshControl.endRefreshing()
    }
    // UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        let userCellID = "HealthcareCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: userCellID, for: indexPath) as! HealthcareCell
        let  category = self.categories[indexPath.row]
        
        cell.shopName.text = category.shopName
        cell.shopDescription.text = category.description
        cell.imgView.sd_setImage(with: URL(string: category.image), placeholderImage: UIImage(named: ""))
        cell.reviewCount.text = category.review
        cell.rating.rating = category.rating
        
        cell.cardView.setCardLayoutEffect()
        
        //configure cell
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 135.0
    }
    // mark - back button Navigation
    
    @objc func backBtnAction() {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK: Webservice Call
    func getWebserviceData()
    {
        
        if ApiManagerClass.sharedInstance.isConnectedToInternet() == true {
            SVProgressHUD.show()
            SVProgressHUD.setDefaultMaskType(.clear)
            var url = webConstant.baseUrl
            url.append(webConstant.Categorylisting)
           
            
            let params:Dictionary  = ["categoryId":"5" as Any]
            Alamofire.request(url, method: .post, parameters: params)
                .responseJSON {
                    response in
                    switch response.result {
                    case .success(let data):
                        print(response)
                        
                        SVProgressHUD.dismiss()

                       if response.result.value != nil {
                            
                            let jsonResult: NSDictionary = response.result.value as! NSDictionary
                            self.jsonResponse = JSON(data)
                        
                             if (self.jsonResponse["status"]).boolValue
                            {
                                let objArray = self.jsonResponse["product_data"].arrayValue
                                for i in 0..<objArray.count {
                                    
                                    self.categories.append(contentsOf:[ProductData(productJSON:objArray[i])])

                                }
                                print(self.categories.count)
                                
                                DispatchQueue.main.async {
                                    self.tableCategory.reloadData()
                                }
                                print( self.categories)
                                 let message:String = self.jsonResponse["msg"].stringValue
//                
//                                ApiManagerClass.sharedInstance.showMessage(title: NSLocalizedString("Linkon", comment: ""), msg: message, on: self)
                            
                                
                            }else
                            {
                                SVProgressHUD.dismiss()
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
                        SVProgressHUD.dismiss()
                        ApiManagerClass.sharedInstance.showMessage(title: NSLocalizedString("Linkon", comment: ""), msg: NSLocalizedString("ServerError", comment: ""), on: self)
                    }
            }
        }else{
            //
            ApiManagerClass.sharedInstance.showMessage(title: NSLocalizedString("Linkon", comment: ""), msg: NSLocalizedString("internercheck", comment: ""), on: self)
            
        }
        
    }
    

}
