//
//  AboutUSVC.swift
//  Linkon
//
//  Created by Avion on 10/4/18.
//  Copyright © 2018 Avion. All rights reserved.
//

import UIKit

class AboutUSVC: UIViewController {

    @IBOutlet weak var lblComments: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setNavigationBarItem()
        self.title = "AboutUS"
        
        print(Locale.current.languageCode!)
        callAboutUS()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        callAboutUS()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
       
    }
    
    func callAboutUS(){
        
        var url = webConstant.baseUrl
        url.append(webConstant.about)
        let params = ["language":Locale.current.languageCode!]
        
        requestPOSTURL(url, params: params as [String : AnyObject], success: { (data) in
            print(data)
            let status = data["status"].boolValue
            let message = data["msg"].stringValue
            if !status{
                
                self.popupAlert(title: webConstant.Title, message:message, actionTitles: ["Ok"], actions:[{ (action1) in
                    
                    }])
            }else{
                
               self.showToast(message: message)
               self.lblComments.text = data["category_data"].stringValue
            }
        }) { (error) in
            print(error)
        }
    }
   
}
