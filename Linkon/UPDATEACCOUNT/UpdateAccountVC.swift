//
//  UpdateAccountVC.swift
//  Linkon
//
//  Created by Avion on 9/12/18.
//  Copyright © 2018 Avion. All rights reserved.
//

import UIKit

class UpdateAccountVC: UIViewController , UITextFieldDelegate,UIPopoverPresentationControllerDelegate {

    @IBOutlet weak var txtFirstName: TextField!
    @IBOutlet weak var txtLastName: TextField!
    @IBOutlet weak var txtEmail: TextField!
    @IBOutlet weak var txtCurrentPwd: TextField!
    @IBOutlet weak var txtNewPwd: TextField!
    @IBOutlet weak var txtConfirmPwd: TextField!

    var currentPwd:String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
 
       setNavigationBarItem()
       title = "Update Account"
        
        let userData = UserDefaults.standard.object(forKey: "customerDataSignUp") as![String : AnyObject]
        self.txtFirstName.text = userData["firstname"] as? String
        self.txtLastName.text = userData["lastname"] as? String
        self.txtEmail.text = userData["email"] as? String
        
        print(UserDefaults.standard.object(forKey: "Password") as! String)
        
    }
    
    //MARK: IBAction
    
    @IBAction func submitClicked(_ sender: Any) {
        
        if (txtFirstName.text?.isEmpty)!{
            popupAlert(title: "Linkon", message: "Please Enter Your First Name", actionTitles: ["Ok"], actions: [{ (action1) in
                },{(action2) in
                    
                }])
        }else if (txtLastName.text?.isEmpty)!{
            popupAlert(title: "Linkon", message: "Please Enter Your Last Name", actionTitles: ["Ok"], actions: [{ (action1) in
                },{(action2) in
                    
                }])
        }
        else if (txtEmail.text?.isEmpty)!{
            popupAlert(title: "Linkon", message: "Please Enter Your Email Address", actionTitles: ["Ok"], actions: [{ (action1) in
                },{(action2) in
                    
                }])
            
        }else if !isValidEmail(testStr: txtEmail.text!){
            popupAlert(title: "Linkon", message: "Please Enter Correct E-mail Address", actionTitles: ["Ok"], actions: [{ (action1) in
                },{(action2) in
                    
                }])
        }
        else if !(txtCurrentPwd.text == ""){
            
            if (txtNewPwd.text?.isEmpty)!{
                popupAlert(title: "Linkon", message: "Please Enter Your New Password", actionTitles: ["Ok"], actions: [{ (action1) in
                    },{(action2) in
                        
                    }])
            }
            else if !isValidPassword(password: txtNewPwd.text!){
                popupAlert(title: "Linkon", message: "Please Enter Valid Password", actionTitles: ["Ok"], actions: [{(action1) in
                    
                    }])
            }
            else if (txtNewPwd.text?.rangeOfCharacter(from: NSCharacterSet.whitespaces) != nil){
                popupAlert(title: "Linkon", message: "Password do not accept space as Password", actionTitles: ["Ok"], actions: [{(action1) in
                    
                    }])
            }
            else if (txtConfirmPwd.text?.rangeOfCharacter(from: NSCharacterSet.whitespaces) != nil){
                popupAlert(title: "Linkon", message: "Password do not accept space as Password", actionTitles: ["Ok"], actions: [{(action1) in
                    
                    }])
            }
            else if (txtConfirmPwd.text?.isEmpty)!{
                popupAlert(title: "Linkon", message: "Please Enter Your Confirm Password", actionTitles: ["Ok"], actions: [{ (action1) in
                    },{(action2) in
                        
                    }])
            }
            else if !(txtNewPwd.text == txtConfirmPwd.text) {
                popupAlert(title: "Linkon", message: "Password and Confirm Password does not Match", actionTitles: ["Ok"], actions: [{ (action1) in
                    },{(action2) in
                        
                    }])
            }else{
                updateAccount()
            }
            
            
        }else{
            
            updateAccount()
            
        }
  
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        
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
    //MARK:- WebService call
    func updateAccount(){
        var url = webConstant.baseUrl
        url.append(webConstant.updateCustomer)
     
        let userData = UserDefaults.standard.object(forKey: "customerDataSignUp") as![String : AnyObject]
        
        let params = ["firstname":txtFirstName.text!,
                      "lastname":txtLastName.text!,
                      "email":txtEmail.text!,
                      "currentpassword":txtCurrentPwd.text!,
                      "password":txtNewPwd.text!,
                      "customer_id":userData["customer_id"]! as Any]
        
        requestPOSTURL(url, params: params as [String : AnyObject], success: { (data) in
            print(data)
            let status = data["status"].boolValue
             let message = data["msg"].stringValue
            if !status{
                
                self.popupAlert(title: "Linkon", message:message, actionTitles: ["Ok"], actions:[{ (action1) in
                    
                    }])
            }else{
                
                UserDefaults.standard.set(self.txtEmail.text, forKey: "UserName")
                UserDefaults.standard.set(self.txtConfirmPwd.text, forKey: "Password")
                
                let customerData = data["data"]["customer"].dictionaryObject! as NSDictionary
                
                self.popupAlert(title: "Linkon", message:message, actionTitles: ["Ok"], actions:[{ (action1) in
                    
                    }])
                print(customerData)
                

                
            }
        }) { (error) in
            print(error)
        }
     
    }
    
    
    
    
}
