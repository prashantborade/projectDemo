//
//  ForgotPasswordVC.swift
//  Linkon
//
//  Created by Avion on 7/24/18.
//  Copyright © 2018 Avion. All rights reserved.
//

import UIKit
import SVProgressHUD
import Alamofire

class ForgotPasswordVC: UIViewController {

    @IBOutlet weak var txtEmail: TextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func btnSubmitClicked(_ sender: Any) {
        
        if (txtEmail.text?.isEmpty)!{
            popupAlert(title: "Linkon", message: "Please Enter Your E-mail Address", actionTitles: ["Ok"], actions: [{ (action1) in
                },{(action2) in
                    
                }])
        }else if !isValidEmail(testStr: txtEmail.text!){
            popupAlert(title: "Linkon", message: "Please Enter Correct E-mail Address", actionTitles: ["Ok"], actions: [{ (action1) in
                },{(action2) in
                    
                }])
        }else {
            
              getWebserviceData()
        }
    }
    @IBAction func btnSignInClicked(_ sender: Any) {
            
     self.navigationController?.popViewController(animated: true)
    }
        
    //MARK: Webservice Call
    func getWebserviceData()
    {
        
        if ApiManagerClass.sharedInstance.isConnectedToInternet() == true {
            SVProgressHUD.show()
            SVProgressHUD.setDefaultMaskType(.clear)
            var url = webConstant.baseUrl
            url.append(webConstant.forgotpwd)
        
            let params:Dictionary  = ["email":txtEmail.text! as Any]
            
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

                                let message:String = jsonResult["msg"] as! String
                                ApiManagerClass.sharedInstance.showMessage(title: NSLocalizedString("Linkon", comment: ""), msg: message, on: self)
                                
                                let objAppDelegate = (UIApplication.shared.delegate as? AppDelegate)
                                objAppDelegate?.gotSigInController()
                                
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
