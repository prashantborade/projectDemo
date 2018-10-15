//
//  ApiManagerClass.swift
//  Linkon
//
//  Created by Avion on 7/13/18.
//  Copyright © 2018 Avion. All rights reserved.
//


import UIKit
import Alamofire;
import SwiftyJSON;
import SVProgressHUD



class ApiManagerClass: NSObject
{
    static let sharedInstance = ApiManagerClass()
    
    
    func isConnectedToInternet() ->Bool
    {
        return NetworkReachabilityManager()!.isReachable
    }
    
    func showMessage(title: String, msg: String, `on` controller: UIViewController) {
        let alert = UIAlertController(title: title, message: msg, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("ok", comment: ""), style: UIAlertActionStyle.default, handler: nil))
        controller.present(alert, animated: true, completion: nil)
    }
    
    class func requestPOSTURL(_ strURL : String, params : [String : AnyObject]!, success:@escaping (JSON) -> Void, failure:@escaping (Error) -> Void){
        
        print(params as Any)
        print(strURL)
        Alamofire.request(strURL, method: .post, parameters: params).responseJSON { (responseObject) -> Void in
            
            print(responseObject)
            
            if responseObject.result.isSuccess {
                let resJson = JSON(responseObject.result.value!)
                success(resJson)
            }
            if responseObject.result.isFailure {
                let error : Error = responseObject.result.error!
                failure(error)
            }
        }
    }
    
    
}

