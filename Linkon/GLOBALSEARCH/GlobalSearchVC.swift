//
//  GlobalSearchVC.swift
//  Linkon
//
//  Created by Avion on 9/14/18.
//  Copyright © 2018 Avion. All rights reserved.
//

import UIKit

class GlobalSearchVC: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
   
    @IBOutlet weak var serachTableView: UITableView!
    
    var searchText:String!
    var searchArray = [NSDictionary]()
    var cityList = [String]()
    var plan:String = ""
    override func viewDidLoad() {
        super.viewDidLoad()

        globalSearch()
        title = "Search"
        getCityList()
        
    
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    // UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.searchArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        let userCellID = "SearchCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: userCellID, for: indexPath) as! SearchCell
        
        //configure cell
        cell.cardView.setCardLayoutEffect()
      
        let obj = self.searchArray[indexPath.row]
        cell.lblTitle.text = obj.value(forKey: "shop_title") as? String
        cell.lblDicription.text = obj.value(forKey: "shop_description") as? String
        cell.lblReviewCount.text = obj.value(forKey: "review") as? String
        cell.lblLocation.text = obj.value(forKey: "shop_location") as? String
        let imgURL = obj.value(forKey: "shop_logo") as? String
        let ratingValue:Float = 2.0
        cell.RatingView.rating = Double(ratingValue)
        cell.imgView.sd_setImage(with: URL(string: imgURL!), placeholderImage: UIImage(named: "NoImage"))
        cell.imgView.autoresizingMask = [.flexibleWidth, .flexibleHeight, .flexibleBottomMargin, .flexibleRightMargin, .flexibleLeftMargin, .flexibleTopMargin]
        cell.imgView.contentMode = .scaleAspectFill // OR .scaleAspectFill
        cell.imgView.clipsToBounds = true
  
        print(obj)
        return cell
    }
   
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 120.0
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let obj = self.searchArray[indexPath.row]
        if !((obj.value(forKey: "plan") as? String)! == "Free"){
           
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vendorVC = storyboard.instantiateViewController(withIdentifier: "VendorProfileVC") as! VendorProfileVC
            vendorVC.customerID = obj.value(forKey: "categoryData") as? String
            vendorVC.sellerID = obj.value(forKey: "seller_id") as? String
            self.navigationController?.pushViewController(vendorVC, animated: true)
          }
        
    
    }
    //MARK: Call Webservice
    func globalSearch(){
        var url = webConstant.baseUrl
        url.append(webConstant.globalsearch)
        
        let params = ["name":searchText!]
        
        requestPOSTURL(url, params: params as [String : AnyObject], success: { (data) in
            print(data)
            let status = data["status"].boolValue
            if !status{
                let message = data["message"].stringValue
                
                self.popupAlert(title: "Linkon", message:message, actionTitles: ["Ok"], actions:[{ (action1) in
                    
                    }])
            }else{
                
                self.searchArray = data["category_data"].arrayObject! as! [NSDictionary]
                
                print(self.searchArray)
                DispatchQueue.main.async(execute: {() -> Void in self.serachTableView.reloadData() })
            
                 }
        }) { (error) in
            print(error)
        }
    }
    func getCityList(){
        var url = webConstant.baseUrl
        url.append(webConstant.getcity)
        
       // let params = ["name":searchText!]
        
        requestPOSTURL(url, params: nil, success: { (data) in
            print(data)
            let status = data["status"].boolValue
            if !status{
                let message = data["message"].stringValue
                
                self.popupAlert(title: "Linkon", message:message, actionTitles: ["Ok"], actions:[{ (action1) in
                    
                    }])
            }else{
                
                print(data["city_data"].arrayObject! as! [NSDictionary])
                let cityArray = data["city_data"].arrayObject! as! [NSDictionary]
                
                for obj in cityArray {
                    
                    for city in obj {
                        
                        self.cityList.append(city.value as! String)
                       
                    }
                    
                }
               
               
                
            }
        }) { (error) in
            print(error)
        }
    }
    
}
