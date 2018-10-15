//
//  SignInVC.swift
//  Linkon
//
//  Created by Avion on 7/10/18.
//  Copyright © 2018 Avion. All rights reserved.
//

import UIKit
import SVProgressHUD
import Alamofire
import SwiftyJSON
import GoogleSignIn
import FacebookLogin
import FacebookCore
import FBSDKLoginKit


class SignInVC: UIViewController,UITextFieldDelegate,GIDSignInUIDelegate,GIDSignInDelegate{
    var userType = ""
    var ischeck: Bool = false
    var isLoginFrom: String = ""
    
    @IBOutlet weak var txtUserName: TextField!
    @IBOutlet weak var txtPassword: TextField!
    
    @IBOutlet weak var btnRememberMeOutlet: UIButton!
    
    @IBOutlet weak var segmentUerType: UISegmentedControl!
    @IBOutlet weak var lblOR: UILabel!
    var tField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setNavigationBarItem()
        title = "Sign In"
    
        lblOR.layer.cornerRadius = lblOR.frame.width/2
        lblOR.layer.masksToBounds = true
      
        //make segment Rounded
        segmentUerType.selectedSegmentIndex = 0
        segmentUerType.layer.cornerRadius = 20.0
        segmentUerType.layer.borderColor = UIColor.lightGray.cgColor
        segmentUerType.layer.borderWidth = 1.0
        segmentUerType.layer.masksToBounds = true
  //    hankenround-Regular

        userType = "normal_user"
        
        // for RememberMe
        if UserDefaults.standard.bool(forKey: "rememberme")
        {
            ischeck = true
            txtUserName.text = UserDefaults.standard.object(forKey: "UserName") as? String
            txtPassword.text = UserDefaults.standard.object(forKey: "Password") as? String
            self.btnRememberMeOutlet.setImage(UIImage(named:"check_selected"), for: UIControlState.normal)
        }
        else
        {
            ischeck = false
            self.btnRememberMeOutlet.setImage(UIImage(named:"check_unselected"), for: UIControlState.normal)
        }
        
   
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func userTypeClicked(_ sender: UISegmentedControl) {
        
        if(segmentUerType.selectedSegmentIndex == 0)
        {
            userType = "normal_user"
            txtUserName.text = ""
            txtPassword.text = ""
        }
        else
        {
            userType = "service_provider"
            txtUserName.text = ""
            txtPassword.text = ""
        }
        
    }
    
    @IBAction func RememberClicked(_ sender: UIButton) {
        
//        sender.isSelected = !sender.isSelected
//
//        if(sender.isSelected == true)
//        {
//            sender.setImage(UIImage(named:"check_selected"), for: .normal)
//            UserDefaults.standard.set(txtUserName.text, forKey: "UserName")
//            UserDefaults.standard.set(txtPassword.text, forKey: "Password")
//            UserDefaults.standard.set(true, forKey: "RememberMe")
//
//        }
//        else
//        {
//          sender.setImage(UIImage(named:"check_unselected"), for: .normal)
//           UserDefaults.standard.removeObject(forKey: "UserName")
//           UserDefaults.standard.removeObject(forKey: "Password")
//          UserDefaults.standard.set(false, forKey: "RememberMe")
//
//        }
        
        if(!ischeck)
        {
            ischeck = true
            print("Check")
            
            UserDefaults.standard.set(true, forKey: "rememberme")
            self.btnRememberMeOutlet.setImage(UIImage(named:"check_selected"), for: UIControlState.normal)
        }else
        {
            print("UnCheck")
            ischeck = false
            UserDefaults.standard.set(false, forKey: "rememberme")
            self.btnRememberMeOutlet.setImage(UIImage(named:"check_unselected"), for: UIControlState.normal)
        }
       
    }
    
    @IBAction func forgotPasswordClicked(_ sender: Any) {
    
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let forgotPwd = storyboard.instantiateViewController(withIdentifier: "ForgotPasswordVC") as! ForgotPasswordVC
        self.navigationController?.pushViewController(forgotPwd, animated: true)
        
    }
    
    
    @IBAction func signInClicked(_ sender: Any) {
        
        guard let firstName = txtUserName.text, !firstName.isEmpty else {
            popupAlert(title: webConstant.Title, message: webConstant.EmptyUserName, actionTitles: ["Ok"], actions: [{ (action1) in
                },{(action2) in
                    
                }])
            return
        }
        
        guard let password = txtPassword.text, !password.isEmpty else {
            popupAlert(title: webConstant.Title, message: webConstant.EmptyPassword, actionTitles: ["Ok"], actions: [{ (action1) in
                },{(action2) in
                    
                }])
            return
        }
        
        guard let parse = txtPassword.text, !(parse.rangeOfCharacter(from: NSCharacterSet.whitespaces) != nil) else {
            popupAlert(title: webConstant.Title, message: webConstant.PasswordDoNotSpace, actionTitles: ["Ok"], actions: [{(action1) in
                
                }])
            return
        }
        
        // for sign In
        getDataSignIn()
        
        
    }
    
    //MARK: Call Webservice
    func getDataSignIn(){
        var url = webConstant.baseUrl
        url.append(webConstant.sign_in)
        
        let params:Dictionary  = ["email":txtUserName.text! as Any,
                                  "password":txtPassword.text! as Any,
                                  "usertype":userType as Any]
        
        requestPOSTURL(url, params: params as [String : AnyObject], success: { (data) in
            print(data)
            let status = data["status"].boolValue
            if !status{
                let message = data["msg"].stringValue
                
                self.popupAlert(title: webConstant.Title, message:message, actionTitles: ["Ok"], actions:[{ (action1) in
                    
                    }])
            }else{
                
                let resultdata = data["customer_data"].dictionaryObject! as NSDictionary
                
                print(resultdata)
                UserDefaults.standard.set(self.txtUserName.text, forKey: "UserName")
                UserDefaults.standard.set(self.txtPassword.text, forKey: "Password")
                UserDefaults.standard.set(resultdata, forKey: "customerDataSignUp")
                UserDefaults.standard.set(true, forKey: "HomeVC")
                
                let objAppDelegate = (UIApplication.shared.delegate as? AppDelegate)
                objAppDelegate?.gotoMainController()
                
            }
        }) { (error) in
            print(error)
        }
    }
    //MARK: Webservice Call
    func getWebserviceData()
    {
        
        if ApiManagerClass.sharedInstance.isConnectedToInternet() == true {
            SVProgressHUD.show()
            SVProgressHUD.setDefaultMaskType(.clear)
            var url = webConstant.baseUrl
            url.append(webConstant.sign_in)
           

            let params:Dictionary  = ["email":txtUserName.text! as Any,
                                      "password":txtPassword.text! as Any,
                                      "usertype":userType as Any]
            
            Alamofire.request(url, method: .post, parameters: params)
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
                                UserDefaults.standard.set(self.txtUserName.text, forKey: "UserName")
                                UserDefaults.standard.set(self.txtPassword.text, forKey: "Password")

                                
                                let resultdata: NSDictionary = jsonResult["customer_data"] as! NSDictionary
                                let message:String = jsonResult["msg"] as! String
                                
                                 UserDefaults.standard.set(resultdata, forKey: "customerDataSignUp")
                                 UserDefaults.standard.set(true, forKey: "HomeVC")
                                
//
//                                self.popupAlert(title: NSLocalizedString("Linkon", comment: ""), message: message, actionTitles: ["OK"], actions: [{ (action1) in
                                
                                    let objAppDelegate = (UIApplication.shared.delegate as? AppDelegate)
                                    objAppDelegate?.gotoMainController()
                                    
                                //    }])
                           
                              
                            }else
                            {
                                SVProgressHUD.dismiss()
                                let message:String = jsonResult["msg"] as! String
                                ApiManagerClass.sharedInstance.showMessage(title: NSLocalizedString(webConstant.Title, comment: ""), msg: message, on: self)
                            }
                        }
                        else
                        {
                            ApiManagerClass.sharedInstance.showMessage(title: NSLocalizedString(webConstant.Title, comment: ""), msg: NSLocalizedString("somethingwrong", comment: ""), on: self)
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
    
    @IBAction func signUpClicked(_ sender: Any) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let SignUp = storyboard.instantiateViewController(withIdentifier: "SignUpVC") as! SignUpVC
        self.navigationController?.pushViewController(SignUp, animated: true)
    }
    @IBAction func facebookLoginClicked(_ sender: Any) {
        
        isLoginFrom = "Facebook"
        UserDefaults.standard.set(isLoginFrom, forKey: "isLoginFrom")
        if ApiManagerClass.sharedInstance.isConnectedToInternet() == true
        {
           //SVProgressHUD.show()
            FBSDKLoginManager().logIn(withReadPermissions: ["email", "public_profile", "user_photos"], from: self as UIViewController, handler: { (result, error) -> Void in
                if error != nil {
                    FBSDKLoginManager().logOut()
                    print("error nahi ahe")
              
                    
                    if (error as NSError?) != nil
                    {
                        SVProgressHUD.dismiss()
                        
                    } else {
                        print("no error")
                        SVProgressHUD.dismiss()
                    }
                }else{
                    if(result?.isCancelled)!{
                        print("cancle")
                        SVProgressHUD.dismiss()
                    }
                    else
                    {
                        self.getInfoFromFb();
                        
                    }
                }
            })
  
        }
        else
        {
           ApiManagerClass.sharedInstance.showMessage(title: NSLocalizedString(webConstant.Title, comment: ""), msg: NSLocalizedString("internercheck", comment: ""), on: self)
            
        }
    }
    
    @IBAction func googleLoginClicked(_ sender: Any) {
        
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().signIn()
        isLoginFrom = "Google"
        UserDefaults.standard.set(isLoginFrom, forKey: "isLoginFrom")
    }
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let error = error {
            print("\(error.localizedDescription)")
        } else {
          
            let userId :String = user.userID
    
            let image :URL = user.profile.imageURL(withDimension: 1)
            // let profilUrl : String = String(image)
            let fullName :String = user.profile.name
            let givenName :String = user.profile.givenName
            let familyName :String = user.profile.familyName
            let email :String = user.profile.email
            let scope:NSArray = user.accessibleScopes! as NSArray
            print("email",email,"userid",userId, "userid",userId ,"fullName",fullName, "givenName",givenName,"familyName",familyName, "image",image,"scope",scope)
            
            
            let objAppDelegate = (UIApplication.shared.delegate as? AppDelegate)
            objAppDelegate?.gotoMainController()
            
          /*  if ApiManagerClass.sharedInstance.isConnectedToInternet() == true {
                SVProgressHUD.show()
                
                var url = webConstant.baseUrl
                url.append(webConstant.sign_up)
                
                let params:Dictionary  = ["firstname":givenName,
                                          "lastname":familyName,
                                          "email":email,
                                          "password":"",
                                          "username":email]
                
                Alamofire.request(url, method: .post, parameters: params)
                    .responseJSON {
                        response in
                        switch response.result {
                        case .success:
                            print(response)
                            SVProgressHUD.dismiss()
                            if let JSON = response.result.value {
                                print("JSON register: \(JSON)")
                                let jsonResult: NSDictionary = response.result.value as! NSDictionary
                                if jsonResult["resp"] as! NSNumber == 1
                                {
                                    let resultdata: NSDictionary = jsonResult["result"] as! NSDictionary
                                    let username =  resultdata["username"] as! String
                                    let userID =  resultdata["user_id"] as! String
                                    let eamilID = resultdata["email"] as! String
                                    UserDefaults.standard.set(userID, forKey: "userID")
                                    UserDefaults.standard.set(username, forKey: "userName")
                                    
                                    if (eamilID.count == 0)
                                    {
                                        //self.gettwittercall()
                                    }
                                    else
                                    {
                                        UserDefaults.standard.set(true, forKey: "mainController")
                                        let objAppDelegate = (UIApplication.shared.delegate as? AppDelegate)
                                        objAppDelegate?.gotoMainController()
                                    }
                                    
                                }else
                                {
                                    SVProgressHUD.dismiss()
                                    let message:String = jsonResult["message"] as! String
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
                
            } */
        }
    }
    
    // Present a view that prompts the user to sign in with Google
    func sign(_ signIn: GIDSignIn!,
              present viewController: UIViewController!) {
        self.present(viewController, animated: true, completion: nil)
    }
    
    // Dismiss the "Sign in with Google" view
    private func signIn(signIn: GIDSignIn!,
                        dismissViewController viewController: UIViewController!) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // For Facebook
    
    // MARK: Getting data from facebook
    func getInfoFromFb()
    {
        let request = GraphRequest(graphPath: "/me",
                                   parameters: ["fields": "id,name,first_name,last_name,gender,email,birthday,picture.type(large)"],
                                   httpMethod: .GET)
        request.start { _, result in
            switch result {
            case .success(let response):
                // print("Graph Request Succeeded: \(response)")
                let res : Dictionary = response.dictionaryValue!
              
                SVProgressHUD.dismiss()
                
                let facebookId :String = (res["id"]as! String)
                var emailId :String = (res["email"]as! String)
                // var emailId :String =  ""
                let first_name :String = (res["first_name"]as! String)
                let last_name :String = (res["last_name"]as! String)
                
//                if(emailId.count == 0)
//                {
//                    func configurationTextField(textField: UITextField!)
//                    {
//                        print("generating the TextField")
//                        textField.placeholder = "Enter an Email id"
//                        self.tField = textField
//                    }
//
//                    func handleCancel(alertView: UIAlertAction!)
//                    {
//                        print("Cancelled !!")
//                    }
//
//                    let alert = UIAlertController(title: "Enter Email address", message: "", preferredStyle: .alert)
//                    alert.addTextField(configurationHandler: configurationTextField)
//                    alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler:handleCancel))
//                    alert.addAction(UIAlertAction(title: "Done", style: .default, handler:{ (UIAlertAction) in
//                        print("Done !!")
//
//                        if(!self.IsvalideEmailAddress(testStr: self.tField.text!))
//                        {
//
//                             ApiManagerClass.sharedInstance.showMessage(title: NSLocalizedString("Linkon", comment: ""), msg: "validEmail", on: self)
//
//                        }
//                        print("emailId : \(String(describing: self.tField.text))")
//                        emailId = self.tField.text!
//
//                        if ApiManagerClass.sharedInstance.isConnectedToInternet() == true {
//
//                            SVProgressHUD.show()
//
//                            var url = webConstant.baseUrl
//                            url.append(webConstant.sign_up)
//
//                            let params:Dictionary  = ["email":emailId,
//                                                      "firstname":first_name,
//                                                      "lastname":last_name
//                                                      ]
//                            Alamofire.request(url, method: .post, parameters: params)
//                                .responseJSON {
//                                    response in
//                                    switch response.result {
//                                    case .success:
//                                        print(response)
//                                        SVProgressHUD.dismiss()
//                                        if let JSON = response.result.value {
//
//                                            let jsonResult: NSDictionary = response.result.value as! NSDictionary
//                                            if jsonResult["status"] as! NSNumber == 1
//                                            {
//                                               print(jsonResult)
//
//                                            }else
//                                            {
//                                                SVProgressHUD.dismiss()
//                                                let message:String = jsonResult["msg"] as! String
//                                                ApiManagerClass.sharedInstance.showMessage(title: NSLocalizedString("Linkon", comment: ""), msg: message, on: self)
//                                            }
//                                        }
//                                        else
//                                        {
//                                            ApiManagerClass.sharedInstance.showMessage(title: NSLocalizedString("Linkon", comment: ""), msg: NSLocalizedString("somethingwrong", comment: ""), on: self)
//                                        }
//                                        break
//                                    case .failure(let error):
//                                        print(error)
//                                        SVProgressHUD.dismiss()
//                                        ApiManagerClass.sharedInstance.showMessage(title: NSLocalizedString("Linkon", comment: ""), msg: NSLocalizedString("ServerError", comment: ""), on: self)
//                                    }
//                            }
//                        }else{
//                            //
//                            ApiManagerClass.sharedInstance.showMessage(title: NSLocalizedString("Linkon", comment: ""), msg: NSLocalizedString("internercheck", comment: ""), on: self)
//
//                        }
//                  }))
//                    self.present(alert, animated: true, completion: {
//                        print("completion block")
//                    })
//                }
//                else
//                {
//                    if ApiManagerClass.sharedInstance.isConnectedToInternet() == true {
//
//                        SVProgressHUD.show()
//
//                        var url = webConstant.baseUrl
//                        url.append(webConstant.sign_up)
//
//                        let params:Dictionary  = ["email":emailId,
//                                                  "firstname":first_name,
//                                                  "lastname":last_name
//                                                  ]
//                        Alamofire.request(url, method: .post, parameters: params)
//                            .responseJSON {
//                                response in
//                                switch response.result {
//                                case .success:
//                                    print(response)
//                                    SVProgressHUD.dismiss()
//                                    if let JSON = response.result.value {
//
//                                        let jsonResult: NSDictionary = response.result.value as! NSDictionary
//                                        if jsonResult["status"] as! NSNumber == 1
//                                        {
//                                            print(jsonResult)
//
//                                        }else
//                                        {
//                                            SVProgressHUD.dismiss()
//                                            let message:String = jsonResult["msg"] as! String
//                                            ApiManagerClass.sharedInstance.showMessage(title: NSLocalizedString("Linkon", comment: ""), msg: message, on: self)
//                                        }
//                                    }
//                                    else
//                                    {
//                                        ApiManagerClass.sharedInstance.showMessage(title: NSLocalizedString("Linkon", comment: ""), msg: NSLocalizedString("somethingwrong", comment: ""), on: self)
//                                    }
//                                    break
//                                case .failure(let error):
//                                    print(error)
//                                    SVProgressHUD.dismiss()
//                                    ApiManagerClass.sharedInstance.showMessage(title: NSLocalizedString("Linkon", comment: ""), msg: NSLocalizedString("ServerError", comment: ""), on: self)
//                                }
//                        }
//                    }else{
//                        //
//                        ApiManagerClass.sharedInstance.showMessage(title: NSLocalizedString("Linkon", comment: ""), msg: NSLocalizedString("internercheck", comment: ""), on: self)
//
//                    }
//                }
                let objAppDelegate = (UIApplication.shared.delegate as? AppDelegate)
                objAppDelegate?.gotoMainController()
                
                print("faceBook Id",facebookId)
                print("email address",emailId)
                print("First Name",first_name)
                print("Last Name",last_name)
                
                
                
            case .failed(let error):
                print("Graph Request Failed: \(error)")
            }
        }
    }
            // MARK:- Validation method
            func IsvalideEmailAddress(testStr:String) -> Bool{
                let emailsRegsEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
                let emailTest = NSPredicate(format: "SELF MATCHES %@", emailsRegsEx)
                return emailTest.evaluate(with:testStr)
            }
            // MARK:- keyboard hide
            override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
                self.view.endEditing(true)
            }
         
    
    
}
