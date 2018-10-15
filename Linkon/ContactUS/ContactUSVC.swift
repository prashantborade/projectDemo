//
//  ContactUSVC.swift
//  Linkon
//
//  Created by Avion on 10/4/18.
//  Copyright © 2018 Avion. All rights reserved.
//

import UIKit

class ContactUSVC: UIViewController,UITextFieldDelegate,UITextViewDelegate {

    @IBOutlet weak var txtFirstName: TextField!
    
    @IBOutlet weak var txtLastName: TextField!
    
    @IBOutlet weak var txtEmail: TextField!
    
    @IBOutlet weak var txtPhoneNumber: TextField!
    
    @IBOutlet weak var txtComments: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setNavigationBarItem()
        txtPhoneNumber.delegate = self
        self.title = "ContactUS"
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range:NSRange, replacementString string: String) -> Bool
    {
        
        let currentCharacterCount = txtPhoneNumber.text?.count ?? 0
        if (range.length + range.location > currentCharacterCount){
            return false
        }
        let newLength = currentCharacterCount + string.count - range.length
        return newLength <= 10
        
    }
    //MARK: UITextViewDelegate
    func textViewDidBeginEditing(_ textView: UITextView) {
        txtComments.text = ""
    }
    @IBAction func btnSubmitClicked(_ sender: Any) {
        
        
        if (txtFirstName.text?.isEmpty)!{
            popupAlert(title: webConstant.Title, message: webConstant.EmptyFirstName, actionTitles: ["Ok"], actions: [{ (action1) in
                },{(action2) in
                    
                }])
            
        }else if (txtLastName.text?.isEmpty)!{
            popupAlert(title: webConstant.Title, message: webConstant.EmptyLastName, actionTitles: ["Ok"], actions: [{ (action1) in
                },{(action2) in
                    
                }])
            
        }else if (txtEmail.text?.isEmpty)!{
            popupAlert(title: webConstant.Title, message: webConstant.EmptyEmail, actionTitles: ["Ok"], actions: [{ (action1) in
                },{(action2) in
                    
                }])
        }else if !isValidEmail(testStr: txtEmail.text!){
            popupAlert(title: webConstant.Title, message: webConstant.CorrectEmail, actionTitles: ["Ok"], actions: [{ (action1) in
                },{(action2) in
                    
                }])
            
        }else if(txtPhoneNumber.text?.isEmpty)!{
            
            popupAlert(title: webConstant.Title, message: webConstant.EmptyPhone, actionTitles: ["Ok"], actions: [{ (action1) in
                },{(action2) in
                    
                }])
        }else if(txtComments.text?.isEmpty)!{
            
            popupAlert(title: webConstant.Title, message: webConstant.EmptyMessage, actionTitles: ["Ok"], actions: [{ (action1) in
                },{(action2) in
                    
                }])
        }
        else{
            
            let params:Dictionary  = ["name":"\(txtFirstName.text!) \(txtLastName.text!)"  as Any,
                                      "email":txtEmail.text! as Any,
                                      "telephone":txtPhoneNumber.text! as Any,
                                      "comment":txtComments.text! as Any]
            callContactWebservice(params: params)
            
        }
    }
    func callContactWebservice(params:Dictionary<String, Any>){
        var url = webConstant.baseUrl
        url.append(webConstant.Contact)
        
        requestPOSTURL(url, params: params as [String : AnyObject], success: { (data) in
            print(data)
            let status = data["status"].boolValue
            let message = data["msg"].stringValue
            if !status{
                
                self.popupAlert(title: webConstant.Title, message:message, actionTitles: ["Ok"], actions:[{ (action1) in
                    
                    }])
            }else{
                
                self.txtFirstName.text = ""
                self.txtLastName.text = ""
                self.txtEmail.text = ""
                self.txtPhoneNumber.text = ""
                self.txtComments.text = ""
                self.popupAlert(title: webConstant.Title, message:message, actionTitles: ["Ok"], actions:[{ (action1) in
                    
                    }])
            }
        }) { (error) in
            print(error)
        }
    }
    
}
