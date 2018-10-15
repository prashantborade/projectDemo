//
//  MyPlansVC.swift
//  Linkon
//
//  Created by Avion on 7/10/18.
//  Copyright © 2018 Avion. All rights reserved.
//

import UIKit
import Alamofire
import SVProgressHUD


class MyPlansVC: UIViewController, UITableViewDelegate,UITableViewDataSource,UIPopoverPresentationControllerDelegate{
    
    @IBOutlet weak var dropDown: UIDropDown!
    
    @IBOutlet weak var tableViewPlans: UITableView!
    @IBOutlet weak var segmentPlans: UISegmentedControl!
    
    @IBOutlet weak var maniView: UIView!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var lblPrice: UILabel!
    
    var basicPlan:NSDictionary!
    var plusPlan:NSDictionary!
    var freePlan:NSDictionary!
    var titlePlans:[String] = []
    var titleimages:[String] = []
    var descriptionArray:[String] = []

    var basicOptionPrice:Array<Any>!
    var plusOptionPrice:Array<Any>!
    override func viewDidLoad() {
        super.viewDidLoad()

         self.setNavigationBarItem()
         getWebserviceData()
         self.maniView.setCardLayoutEffect()
        // make rounded
        segmentPlans.selectedSegmentIndex = 0
        segmentPlans.layer.cornerRadius = 20.0
        segmentPlans.layer.borderColor = UIColor.lightGray.cgColor
        segmentPlans.layer.borderWidth = 1.0
        segmentPlans.layer.masksToBounds = true
        
        //self.topView.setCardLayoutEffect()
     
    }
    override func viewWillAppear(_ animated: Bool) {
    
        self.setNavigationBarItem()
        getWebserviceData()
        self.maniView.setCardLayoutEffect()
        // make rounded
        segmentPlans.selectedSegmentIndex = 0
        segmentPlans.layer.cornerRadius = 20.0
        segmentPlans.layer.borderColor = UIColor.lightGray.cgColor
        segmentPlans.layer.borderWidth = 1.0
        segmentPlans.layer.masksToBounds = true
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    @IBAction func segmentControllClicked(_ sender: Any) {
    
        self.titleimages.removeAll()
        self.titlePlans.removeAll()
        self.descriptionArray.removeAll()
        
        
        if(segmentPlans.selectedSegmentIndex == 0)
        {
            
            
            
            if self.basicPlan != nil {
        
            self.descriptionArray = self.basicPlan["description"] as! Array
            self.lblPrice.text = self.basicPlan["price"] as? String
            
            self.basicOptionPrice = self.basicPlan["option_data"] as! Array
            self.dropDown.isHidden = false
            self.dropDown.placeholder = "Select Plans"
            self.dropDown.options = ["Month","Year"]
            self.dropDown.didSelect { (option, index) in
                
                let obj:NSDictionary = (self.basicOptionPrice[index] as? NSDictionary)!
                self.lblPrice.text = "\(String(describing: obj.value(forKey: "price") as! NSNumber))"
            }
                
                
            if let index = self.descriptionArray.index(of: "") {
                self.descriptionArray.remove(at: index)
            }
            for str:String in self.descriptionArray  {
                
                var myStringArr: [String] = []
                myStringArr = str.components(separatedBy: ".")
                
                if myStringArr != nil && !myStringArr.isEmpty
                {
                    
                    self.titlePlans.append(myStringArr[0])
                    self.titleimages.append(myStringArr[1])
                    myStringArr.removeAll()
                }
            }
            
          }
        }
        else if (segmentPlans.selectedSegmentIndex == 1)
        {
            dropDown.isHidden = false
            
            if self.plusPlan != nil {
            
            self.descriptionArray = self.plusPlan["description"] as! Array
            self.lblPrice.text = self.plusPlan["price"] as? String
                
            self.plusOptionPrice = self.plusPlan["option_data"] as! Array
            self.dropDown.isHidden = false
            self.dropDown.placeholder = "Select Plans"
            self.dropDown.options = ["Month","Year"]
            self.dropDown.didSelect { (option, index) in
                    
                let obj:NSDictionary = (self.plusOptionPrice[index] as? NSDictionary)!
                self.lblPrice.text = "\(String(describing: obj.value(forKey: "price") as! NSNumber))"
            }
                
                
                
            if let index = self.descriptionArray.index(of: "") {
                self.descriptionArray.remove(at: index)
            }
            for str:String in self.descriptionArray  {
                
                var myStringArr: [String] = []
                myStringArr = str.components(separatedBy: ".")
                
                if myStringArr != nil && !myStringArr.isEmpty
                {
                    
                    self.titlePlans.append(myStringArr[0])
                    self.titleimages.append(myStringArr[1])
                    myStringArr.removeAll()
                }
              }
          
           }
        }
        else
        {
            dropDown.isHidden = true
            
            if self.freePlan != nil {
            self.descriptionArray = self.freePlan["description"] as! Array
              self.lblPrice.text = self.freePlan["price"] as? String
            if let index = self.descriptionArray.index(of: "") {
                self.descriptionArray.remove(at: index)
            }
            for str:String in self.descriptionArray  {
                
                var myStringArr: [String] = []
                myStringArr = str.components(separatedBy: ".")
                
                if myStringArr != nil && !myStringArr.isEmpty
                {
                    
                    self.titlePlans.append(myStringArr[0])
                    self.titleimages.append(myStringArr[1])
                    myStringArr.removeAll()
                }
            }
        }
     
      }
        self.tableViewPlans.reloadData()
    }
    
    @IBAction func byPlanClicked(_ sender: Any) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let updateProfileVC = storyboard.instantiateViewController(withIdentifier: "CartVC") as! CartVC
        self.navigationController?.pushViewController(updateProfileVC, animated: true)
        
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
    // UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.titlePlans.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        let userCellID = "PlanCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: userCellID, for: indexPath) as! PlanCell
    
        cell.planTitle.text = titlePlans[indexPath.row]
        
        if (titleimages[indexPath.row] == "CHECK")
        {
          cell.imgView.image = UIImage(named: "check")
        }
        else
        {
         cell.imgView.image = UIImage(named: "cross")
        }
        
        
        return cell
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        return 30
    }
    //MARK: Webservice Call
    func getWebserviceData()
    {
        
        if ApiManagerClass.sharedInstance.isConnectedToInternet() == true {
            SVProgressHUD.show()
            SVProgressHUD.setDefaultMaskType(.clear)
            
            var url = webConstant.baseUrl
            url.append(webConstant.plans)
          
            Alamofire.request(url, method: .get, parameters: nil)
                .responseJSON {
                    response in
                    switch response.result {
                    case .success:
                        print(response)
                        SVProgressHUD.dismiss()
                        if let JSON = response.result.value {
                            
                            let jsonResult: NSDictionary = response.result.value as! NSDictionary
                            if jsonResult["status"] as! NSNumber == 1
                            {
                                let product_data: NSDictionary = jsonResult["product_data"] as! NSDictionary
                                self.basicPlan = product_data["basic"] as! NSDictionary
                                self.plusPlan =  product_data["Plus"] as! NSDictionary
                                self.freePlan =  product_data["Free"] as! NSDictionary
                                
                                self.descriptionArray = self.basicPlan["description"] as! Array
                                
                                  self.lblPrice.text = self.basicPlan["price"] as? String
                                if let index = self.descriptionArray.index(of: "") {
                                    self.descriptionArray.remove(at: index)
                                }
                                for str:String in self.descriptionArray  {
                                    
                                    var myStringArr: [String] = []
                                    myStringArr = str.components(separatedBy: ".")
                                    
                                    if myStringArr != nil && !myStringArr.isEmpty
                                    {
                                        
                                        self.titlePlans.append(myStringArr[0])
                                        self.titleimages.append(myStringArr[1])
                                        myStringArr.removeAll()
                                    }
                                }
                                
                                self.basicOptionPrice = self.basicPlan["option_data"] as! Array
                                self.dropDown.isHidden = false
                                self.dropDown.placeholder = "Select Plans"
                                self.dropDown.options = ["Month","Year"]
                                self.dropDown.didSelect { (option, index) in
                                    
                                    
                                    let obj:NSDictionary = (self.basicOptionPrice[index] as? NSDictionary)!
                                    self.lblPrice.text = "\(String(describing: obj.value(forKey: "price") as! NSNumber))"
                                }
                                
                                self.tableViewPlans.reloadData()
                                let message:String = jsonResult["msg"] as! String
                                 ApiManagerClass.sharedInstance.showMessage(title: NSLocalizedString("Linkon", comment: ""), msg: message, on: self)
                                
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
extension UIView {
    func myroundCorners(corners:UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
    }
}
