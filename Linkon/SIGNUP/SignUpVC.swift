
//  SignUpVC.swift
//  Linkon
//
//  Created by Avion on 7/10/18.
//  Copyright © 2018 Avion. All rights reserved.



import UIKit
import SVProgressHUD
import Alamofire
import SwiftyJSON

class SignUpVC: UIViewController,UITextFieldDelegate {

    var serviceType: UITextField!
    @IBOutlet weak var txtFirstName: TextField!
    @IBOutlet weak var txtLastName: TextField!
    @IBOutlet weak var txtEmailAddress: TextField!
    @IBOutlet weak var txtTypeOfService: TextField!
    @IBOutlet weak var txtPassword: TextField!
    @IBOutlet weak var txtConfirmPassword: TextField!
    @IBOutlet weak var btnMenu: UIButton!
    @IBOutlet weak var tblViewMenu: UITableView!
    
    @IBOutlet weak var txtTypeOfservicesContraintHeight: NSLayoutConstraint!
    
    @IBOutlet weak var btnMenuContraintHeight: NSLayoutConstraint!
    var userType = ""
    var serviceList = [NSDictionary]()
    var termsAndConditions:Bool = false
    
    @IBOutlet weak var segmentUserAndServiceProvider: UISegmentedControl!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.serviceType = UITextField()
        self.serviceType.delegate = self
        self.serviceType.delegate = self
        serviceList = (UserDefaults.standard.object(forKey: "serviceTypes") as! NSArray) as! [NSDictionary]
    
        
        self.setNavigationBarItem()
        self.tblViewMenu.isHidden = true
        self.tblViewMenu.setCardLayoutEffect()
        
        self.txtTypeOfService.isHidden = true
        self.btnMenu.isHidden = true
        self.btnMenuContraintHeight.constant = 0
        self.txtTypeOfservicesContraintHeight.constant = 0
    
        
        // retrieving a value for a key
        if let data = UserDefaults.standard.data(forKey:"User"),
            let Userobj = NSKeyedUnarchiver.unarchiveObject(with: data) as? CurrentUser{
            
            print(Userobj.email)
            print(Userobj.password)
            print("current obj")
        } else {
            print("There is an issue")
        }
        
       //make segment Rounded
        segmentUserAndServiceProvider.selectedSegmentIndex = 0
        segmentUserAndServiceProvider.layer.cornerRadius = 15.0
        segmentUserAndServiceProvider.layer.borderColor = UIColor.lightGray.cgColor
        segmentUserAndServiceProvider.layer.borderWidth = 1.0
        segmentUserAndServiceProvider.layer.masksToBounds = true
        userType = "normal_user"
        
        //segmentUserAndServiceProvider.setTitleTextAttributes([NSAttributedStringKey.foregroundColor: UIColor.white], for: .selected)
    }
    @IBAction func UserTypeAction(_ sender: Any) {
        
        if(segmentUserAndServiceProvider.selectedSegmentIndex == 0)
        {
            userType = "normal_user"
            self.txtTypeOfService.isHidden = true
            self.btnMenu.isHidden = true
            self.btnMenuContraintHeight.constant = 0
            self.txtTypeOfservicesContraintHeight.constant = 0
            txtFirstName.text = ""
            txtLastName.text = ""
            txtEmailAddress.text = ""
            txtTypeOfService.text = ""
            txtPassword.text = ""
            txtConfirmPassword.text = ""
            
        
        }
        else
        {
          
            userType = "service_provider"
            self.txtTypeOfService.isHidden = false
            self.btnMenu.isHidden = false
            self.btnMenuContraintHeight.constant = 40
            self.txtTypeOfservicesContraintHeight.constant = 40
            txtFirstName.text = ""
            txtLastName.text = ""
            txtEmailAddress.text = ""
            txtTypeOfService.text = ""
            txtPassword.text = ""
            txtConfirmPassword.text = ""
            
        }
    }
    
    @IBAction func btnMenuClicked(_ sender: Any) {
        
        
        if tblViewMenu.isHidden
        {
            animate(toogle: true)
        }
        else
        {
            animate(toogle: false)
        }
    }
    func animate(toogle:Bool)
    {
        if toogle
        {
            UIView.animate(withDuration: 0.3) {
                self.tblViewMenu.isHidden = false
            }
            
        }
        else
        {
            UIView.animate(withDuration: 0.3) {
                self.tblViewMenu.isHidden = true
            }
        }
    }
    
     @IBAction func CreatAnAccountClicked(_ sender: Any) {
    
        if (userType == "normal_user") {
            if (txtFirstName.text?.isEmpty)!{
                popupAlert(title: webConstant.Title, message: webConstant.EmptyFirstName, actionTitles: ["Ok"], actions: [{ (action1) in
                    },{(action2) in
                        
                    }])
                
            }else if (txtLastName.text?.isEmpty)!{
                popupAlert(title: webConstant.Title, message: webConstant.EmptyLastName, actionTitles: ["Ok"], actions: [{ (action1) in
                    },{(action2) in
                        
                    }])
                
            }else if (txtEmailAddress.text?.isEmpty)!{
                popupAlert(title: webConstant.Title, message: webConstant.EmptyEmail, actionTitles: ["Ok"], actions: [{ (action1) in
                    },{(action2) in
                        
                    }])
            }else if !isValidEmail(testStr: txtEmailAddress.text!){
                popupAlert(title: webConstant.Title, message: webConstant.CorrectEmail, actionTitles: ["Ok"], actions: [{ (action1) in
                    },{(action2) in
                        
                    }])
        
            }else if (txtPassword.text?.isEmpty)!{
                popupAlert(title: webConstant.Title, message: webConstant.EmptyPassword, actionTitles: ["Ok"], actions: [{ (action1) in
                    },{(action2) in
                        
                    }])
            }else if (txtPassword.text?.rangeOfCharacter(from: NSCharacterSet.whitespaces) != nil){
                popupAlert(title: webConstant.Title, message: webConstant.PasswordDoNotSpace, actionTitles: ["Ok"], actions: [{(action1) in
                    
                    }])
            }
            else if (txtConfirmPassword.text?.isEmpty)!{
                popupAlert(title: webConstant.Title, message: webConstant.EmptyConfirmPassword, actionTitles: ["Ok"], actions: [{ (action1) in
                    },{(action2) in
                        
                    }])
            }else if (txtConfirmPassword.text?.rangeOfCharacter(from: NSCharacterSet.whitespaces) != nil){
                popupAlert(title: webConstant.Title, message: webConstant.PasswordDoNotSpace, actionTitles: ["Ok"], actions: [{(action1) in
                    
                    }])
            }
            else if !(txtPassword.text == txtConfirmPassword.text ) {
                popupAlert(title: webConstant.Title, message: webConstant.ConfirmPasswordNotMatch, actionTitles: ["Ok"], actions: [{ (action1) in
                    },{(action2) in
                        
                    }])
            }
            else{
                
                let params:Dictionary  = ["firstname":txtFirstName.text! as Any,
                                          "lastname":txtLastName.text! as Any,
                                          "email":txtEmailAddress.text! as Any,
                                          "password":txtPassword.text! as Any,
                                          "usertype":userType as Any
                    
                ]
               // getWebserviceData(params: params)
                newCustomer(params: params)
                
            }
        }
        else
        {
            if (txtFirstName.text?.isEmpty)!{
                popupAlert(title: webConstant.Title, message: webConstant.EmptyFirstName, actionTitles: ["Ok"], actions: [{ (action1) in
                    },{(action2) in
                        
                    }])
               
            }else if (txtLastName.text?.isEmpty)!{
                popupAlert(title: webConstant.Title, message: webConstant.EmptyLastName, actionTitles: ["Ok"], actions: [{ (action1) in
                    },{(action2) in
                        
                    }])
                
            }else if (txtEmailAddress.text?.isEmpty)!{
                popupAlert(title: webConstant.Title, message: webConstant.EmptyEmail, actionTitles: ["Ok"], actions: [{ (action1) in
                    },{(action2) in
                        
                    }])
            }else if !isValidEmail(testStr: txtEmailAddress.text!){
                popupAlert(title: webConstant.Title, message: webConstant.CorrectEmail, actionTitles: ["Ok"], actions: [{ (action1) in
                    },{(action2) in
                        
                    }])
                
            }else if (serviceType.text?.isEmpty)!{
                popupAlert(title: webConstant.Title, message: webConstant.EmptyTypeOfService, actionTitles: ["Ok"], actions: [{ (action1) in
                    },{(action2) in
                        
                    }])
                
            }else if (txtPassword.text?.isEmpty)!{
                popupAlert(title: webConstant.Title, message: webConstant.EmptyPassword, actionTitles: ["Ok"], actions: [{ (action1) in
                    },{(action2) in
                        
                    }])
            }else if (txtPassword.text?.rangeOfCharacter(from: NSCharacterSet.whitespaces) != nil){
                popupAlert(title: webConstant.Title, message: webConstant.PasswordDoNotSpace, actionTitles: ["Ok"], actions: [{(action1) in
                    
                    }])
            }
            else if (txtConfirmPassword.text?.isEmpty)!{
                popupAlert(title: webConstant.Title, message: webConstant.EmptyConfirmPassword, actionTitles: ["Ok"], actions: [{ (action1) in
                    },{(action2) in
                        
                    }])
            }else if (txtConfirmPassword.text?.rangeOfCharacter(from: NSCharacterSet.whitespaces) != nil){
                popupAlert(title: webConstant.Title, message: webConstant.PasswordDoNotSpace, actionTitles: ["Ok"], actions: [{(action1) in
                    
                    }])
            }
            else if !(txtPassword.text == txtConfirmPassword.text ) {
                popupAlert(title: webConstant.Title, message: webConstant.ConfirmPasswordNotMatch, actionTitles: ["Ok"], actions: [{ (action1) in
                    },{(action2) in
                        
                    }])
            }
            else{
                
                
                let params:Dictionary  = ["firstname":txtFirstName.text! as Any,
                                          "lastname":txtLastName.text! as Any,
                                          "email":txtEmailAddress.text! as Any,
                                          "password":txtPassword.text! as Any,
                                          "servicetype":serviceType.text as Any,
                                          "usertype":userType as Any
                    
                ]
                newCustomer(params: params)
                
            }
        }
        
        
    }
    
    @IBAction func GotoBackClicked(_ sender: Any) {
        
    self.navigationController?.popViewController(animated: true)
        
    }
    
    @IBAction func SignInClicked(_ sender: Any) {

       self.navigationController?.popViewController(animated: true)
    }
    
    //MARK: Call Webservice
    func newCustomer(params:Dictionary<String, Any>){
        var url = webConstant.baseUrl
        url.append(webConstant.sign_up)
        
            requestPOSTURL(url, params: params as [String : AnyObject], success: { (data) in
            print(data)
            let status = data["status"].boolValue
            let message = data["msg"].stringValue
            if !status{
                
                self.popupAlert(title: webConstant.Title, message:message, actionTitles: ["Ok"], actions:[{ (action1) in
                    
                    }])
            }else{
                
               let customerDataSignUp = data["customer_data"].dictionaryObject!
                print(customerDataSignUp)
               let firstName = data["customer_data"]["firstname"].stringValue
                print(firstName)
               let lastName = data["customer_data"]["firstname"].stringValue
                print(lastName)
               let customerID = data["customer_data"]["customer_id"].stringValue
                print(customerID)
               let email = data["customer_data"]["email"].stringValue
                print(email)
               let user_type = data["customer_data"]["user_type"].stringValue
                print(user_type)
               let plan = data["customer_data"]["plan"].stringValue
                print(plan)

                UserDefaults.standard.set(customerDataSignUp, forKey: "customerDataSignUp")
     
                self.popupAlert(title: webConstant.Title, message: message, actionTitles: ["ok"], actions: [{ (action1) in
                    // GIDSignIn.sharedInstance().signOut()
                    UserDefaults.standard.set(true, forKey: "HomeVC")
                    let objAppDelegate = (UIApplication.shared.delegate as? AppDelegate)
                    objAppDelegate?.gotoMainController()

                    },{(action2) in

                    }])
                
            }
        }) { (error) in
            print(error)
        }
    }
    
    
//    // get WebServiceData
//    func getWebserviceData( params:Dictionary<String, Any>)
//    {
//
//        if ApiManagerClass.sharedInstance.isConnectedToInternet() == true {
//            SVProgressHUD.show()
//            SVProgressHUD.setDefaultMaskType(.clear)
//            var url = webConstant.baseUrl
//            url.append(webConstant.sign_up)
//
//            Alamofire.request(url, method: .post, parameters: params)
//                .responseJSON {
//                    response in
//                    switch response.result {
//                    case .success:
//                        print(response)
//                        SVProgressHUD.dismiss()
//                        if let JSON = response.result.value {
//                            print("JSON register: \(JSON)")
//                            let jsonResult: NSDictionary = response.result.value as! NSDictionary
//                            if jsonResult["status"] as! NSNumber == 1
//                            {
//
//                                let message:String = jsonResult["msg"] as! String
//                                let customerDataSignUp: NSDictionary = jsonResult["customer_data"] as!NSDictionary
//                                UserDefaults.standard.set(customerDataSignUp, forKey: "customerDataSignUp")
//
//                                self.popupAlert(title: webConstant.Title, message: message, actionTitles: ["ok"], actions: [{ (action1) in
//                                    // GIDSignIn.sharedInstance().signOut()
//                                    UserDefaults.standard.set(true, forKey: "HomeVC")
//                                    let objAppDelegate = (UIApplication.shared.delegate as? AppDelegate)
//                                    objAppDelegate?.gotoMainController()
//
//                                    },{(action2) in
//
//                                    }])
//
//                            }else
//                            {
//                                SVProgressHUD.dismiss()
//                                let message:String = jsonResult["msg"] as! String
//                                ApiManagerClass.sharedInstance.showMessage(title: NSLocalizedString(webConstant.Title, comment: ""), msg: message, on: self)
//                            }
//                        }
//                        else
//                        {
//                            ApiManagerClass.sharedInstance.showMessage(title: NSLocalizedString(webConstant.Title, comment: ""), msg: NSLocalizedString("somethingwrong", comment: ""), on: self)
//                        }
//                        break
//                    case .failure(let error):
//                        print(error)
//                        SVProgressHUD.dismiss()
//                        ApiManagerClass.sharedInstance.showMessage(title: NSLocalizedString(webConstant.Title, comment: ""), msg: NSLocalizedString("ServerError", comment: ""), on: self)
//                    }
//            }
//        }else{
//
//            ApiManagerClass.sharedInstance.showMessage(title: NSLocalizedString(webConstant.Title, comment: ""), msg: NSLocalizedString("internercheck", comment: ""), on: self)
//
//        }
//
//    }
  
    
}

extension SignUpVC: UITableViewDelegate,UITableViewDataSource {
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.serviceList.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
    
         let obj = self.serviceList[indexPath.row]
        
          cell.textLabel!.text = obj.value(forKey: "name") as? String
          cell.textLabel?.textAlignment = .center

        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        let obj = self.serviceList[indexPath.row]
        txtTypeOfService.text! = (obj.value(forKey: "name") as? String)!
        serviceType.text! = (obj.value(forKey: "id") as? String)!
       
        print((obj.value(forKey: "id") as? String)!)
        
        animate(toogle: false)
    }
}
