//
//  UpdateProfileVC.swift
//  Linkon
//
//  Created by Avion on 7/12/18.
//  Copyright © 2018 Avion. All rights reserved.
//

import UIKit
import Alamofire
import SVProgressHUD


class UpdateProfileVC: UIViewController {
   
    @IBOutlet weak var imageProfile: UIImageView!
    @IBOutlet weak var txtFirstName: TextField!
    @IBOutlet weak var txtLastName: TextField!
    @IBOutlet weak var txtEmail: TextField!
    @IBOutlet weak var txtPassword: TextField!
    @IBOutlet weak var txtConfirmPassword: TextField!

    // for Address
    @IBOutlet weak var txtAddrFirstName: TextField!
    @IBOutlet weak var txtAddrLastName: TextField!
    @IBOutlet weak var txtAddrCountryCode: TextField!
    @IBOutlet weak var txtAddrZipeCode: TextField!
    @IBOutlet weak var txtAddrCity: TextField!
    @IBOutlet weak var txtAddrTelephone: TextField!
    @IBOutlet weak var txtAddrFax: TextField!
    @IBOutlet weak var txtAddrCompany: TextField!
    @IBOutlet weak var txtAddrStreet: TextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // make profile image Circle
     // self.imageProfile.makeCircle()
      self.setNavigationBarItem()
      self.navigationController?.isNavigationBarHidden = false
      self.title = "Update Profile"
      let userData = UserDefaults.standard.object(forKey: "customerDataSignUp") as![String : AnyObject]
      txtFirstName.text = userData["firstname"] as? String
      txtLastName.text = userData["firstname"] as? String
      txtEmail.text = userData["email"] as? String
      txtPassword.text = UserDefaults.standard.object(forKey: "Password") as? String
      txtConfirmPassword.text = UserDefaults.standard.object(forKey: "Password") as? String
    }
    @IBAction func submitProfileClicked(_ sender: Any) {
        
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        let SignUp = storyboard.instantiateViewController(withIdentifier: "OfferListVC") as! OfferListVC
//        self.navigationController?.pushViewController(SignUp, animated: true)

        if (txtFirstName.text?.isEmpty)!{
            popupAlert(title: "Linkon", message: "Please Enter Your Firstname", actionTitles: ["Ok"],
                       actions: [{ (action1) in
                },{(action2) in

                }])
        }else if (txtLastName.text?.isEmpty)!{
            popupAlert(title: "Linkon", message: "Please Enter Your Lastname", actionTitles: ["Ok"], actions: [{ (action1) in
                },{(action2) in

                }])

        }else if (txtEmail.text?.isEmpty)!{
            popupAlert(title: "Linkon", message: "Please Enter Your E-mail Address", actionTitles: ["Ok"], actions: [{ (action1) in
                },{(action2) in

                }])
        }else if !isValidEmail(testStr: txtEmail.text!){
            popupAlert(title: "Linkon", message: "Please Enter Correct E-mail Address", actionTitles: ["Ok"], actions: [{ (action1) in
                },{(action2) in

                }])
        }else if (txtPassword.text?.isEmpty)!{
            popupAlert(title: "Linkon", message: "Please Enter Your Password", actionTitles: ["Ok"], actions: [{ (action1) in
                },{(action2) in
                    
                }])
        }else if (txtPassword.text?.rangeOfCharacter(from: NSCharacterSet.whitespaces) != nil){
            popupAlert(title: "Linkon", message: "Password do not accept space as Password", actionTitles: ["Ok"], actions: [{(action1) in
                
                }])
        }else if (txtConfirmPassword.text?.isEmpty)!{
                popupAlert(title: "Linkon", message: "Please Enter Your Confirm Password", actionTitles: ["Ok"], actions: [{ (action1) in
                    },{(action2) in
                        
                }])
        }else if (txtConfirmPassword.text?.rangeOfCharacter(from: NSCharacterSet.whitespaces) != nil){
                popupAlert(title: "Linkon", message: "Password do not accept space as Password", actionTitles: ["Ok"], actions: [{(action1) in
                    
                }])
        }else if !(txtPassword.text == txtConfirmPassword.text ) {
                popupAlert(title: "Linkon", message: "Password and Confirm Password does not Match", actionTitles: ["Ok"], actions: [{ (action1) in
                    },{(action2) in
                        
                }])
         }else if (txtAddrFirstName.text?.isEmpty)!{
                popupAlert(title: "Linkon", message: "Please Enter Your Address Firstname", actionTitles: ["Ok"], actions: [{ (action1) in
                    },{(action2) in

                }])
        }else if (txtAddrLastName.text?.isEmpty)!{
                popupAlert(title: "Linkon", message: "Please Enter Your Address Lastname", actionTitles: ["Ok"], actions: [{ (action1) in
                    },{(action2) in

                }])

        }else if (txtAddrCountryCode.text?.isEmpty)!{
            popupAlert(title: "Linkon", message: "Please Enter Your Country Code", actionTitles: ["Ok"], actions: [{ (action1) in
                },{(action2) in

                }])
        }else if (txtAddrZipeCode.text?.isEmpty)!{
            popupAlert(title: "Linkon", message: "Please Enter Your ZipCode", actionTitles: ["Ok"], actions: [{ (action1) in
                },{(action2) in

                }])
        }else if (txtAddrCity.text?.isEmpty)!{
            popupAlert(title: "Linkon", message: "Please Enter Your City Name", actionTitles: ["Ok"], actions: [{ (action1) in
                },{(action2) in

                }])
        }else if (txtAddrTelephone.text?.isEmpty)! {
            popupAlert(title: "Linkon", message: "Please Enter Your Telephone Number", actionTitles: ["Ok"], actions: [{ (action1) in
                },{(action2) in

                }])
            
        }else if (txtAddrFax.text?.isEmpty)! {
            popupAlert(title: "Linkon", message: "Please Enter Your Fax", actionTitles: ["Ok"], actions: [{ (action1) in
                },{(action2) in

                }])
        }else if (txtAddrCompany.text?.isEmpty)! {
            popupAlert(title: "Linkon", message: "Please Enter Company Name", actionTitles: ["Ok"], actions: [{ (action1) in
                },{(action2) in

                }])
        }else if (txtAddrStreet.text?.isEmpty)! {
            popupAlert(title: "Linkon", message: "Please Enter Street Name", actionTitles: ["Ok"], actions: [{ (action1) in
                },{(action2) in

                }])
        }else{

            getWebserviceData()

        }
        
   }
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range:NSRange, replacementString string: String) -> Bool
    {
        
        let currentCharacterCount = txtAddrTelephone.text?.count ?? 0
        if (range.length + range.location > currentCharacterCount){
            return false
        }
        let newLength = currentCharacterCount + string.count - range.length
        return newLength <= 10
        
    }
    //MARK: Webservice Call
    func getWebserviceData()
    {
        
        if ApiManagerClass.sharedInstance.isConnectedToInternet() == true {
            SVProgressHUD.show()
            SVProgressHUD.setDefaultMaskType(.clear)
            var url = webConstant.baseUrl
            url.append(webConstant.editCustomer)
            let userData = UserDefaults.standard.object(forKey: "customerDataSignUp") as![String : AnyObject]
            let params:Dictionary  = ["customer_id":userData["customer_id"]! as Any,
                                      "firstname":txtFirstName.text! as Any,
                                      "lastname":txtLastName.text! as Any,
                                      "email":txtEmail.text! as Any,
                                      "password":txtPassword.text! as Any,
                                      "usertype":userData["user_type"]! as Any,
                                      "address_firstname":txtAddrFirstName.text! as Any,
                                      "address_lastname":txtAddrLastName.text! as Any,
                                      "address_countrycode":txtAddrCountryCode.text! as Any,
                                      "address_zipcode":txtAddrZipeCode.text! as Any,
                                      "address_city":txtAddrCity.text! as Any,
                                      "address_telephone":txtAddrTelephone.text! as Any,
                                      "address_fax":txtAddrFax.text! as Any,
                                      "address_company":txtAddrCompany.text! as Any,
                                      "address_street":txtAddrStreet.text! as Any]
            
            Alamofire.request(url, method: .post, parameters: params)
                .responseJSON {
                    response in
                    switch response.result {
                    case .success(let data):
                        print(response)
                        SVProgressHUD.dismiss()
                        if let JSON = response.result.value {
                            
                            let jsonResult: NSDictionary = response.result.value as! NSDictionary
                            if jsonResult["status"] as! NSNumber == 1
                            {
                                 SVProgressHUD.dismiss()
                                
                                let message:String = jsonResult["msg"] as! String
                                let customer_data: NSDictionary = jsonResult["customer_data"] as! NSDictionary
                                self.txtFirstName.text = customer_data["firstname"] as? String
                                self.txtLastName.text = customer_data["lastname"] as? String
                                self.txtEmail.text = customer_data["email"] as? String
                                
                                let addressArray = customer_data["addresses"] as? NSArray
                                
                                let address:NSDictionary = addressArray![0] as! NSDictionary
       
                                
                                
                                
                                self.txtAddrFirstName.text = address["firstname"] as? String
                                self.txtAddrLastName.text = address["lastname"] as? String
                                self.txtAddrCity.text = address["city"] as? String
                                self.txtAddrZipeCode.text = address["postcode"] as? String
                                self.txtAddrCompany.text = address["company"] as? String
                                self.txtAddrFax.text = address["fax"] as? String
                                self.txtAddrCountryCode.text = address["country_id"] as? String
                                self.txtAddrTelephone.text = address["telephone"] as? String
                             
                            
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
