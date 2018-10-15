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
let headers: HTTPHeaders = [
    "Authorization": "Info XXX",
    "Accept": "application/json",
    "Content-Type" :"application/json",
    "Content-type": "multipart/form-data"
]
class Connectivity {
    class var isConnectedToInternet:Bool {
        return NetworkReachabilityManager()!.isReachable
    }
}

public func requestPOSTURL(_ strURL : String, params : [String : AnyObject]!, success:@escaping (JSON) -> Void, failure:@escaping (Error) -> Void){
    if Connectivity.isConnectedToInternet {
        SVProgressHUD.show()
        SVProgressHUD.setDefaultMaskType(.clear)
        Alamofire.request(strURL, method: .post, parameters: params, encoding: URLEncoding.default).responseJSON { responseObject in
            
            if responseObject.result.isSuccess {
                SVProgressHUD.dismiss()
                let resJson = JSON(responseObject.result.value!)
                success(resJson)
            }
            if responseObject.result.isFailure {
//                SVProgressHUD.dismiss()
                let error : Error = responseObject.result.error!
                failure(error)
                DispatchQueue.main.async {
                    SVProgressHUD.dismiss()
                    let alert = UIAlertController(title: "Linkon", message: "Server Failed", preferredStyle: .alert)
                    let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
                    alert.addAction(action)
                    UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true, completion: nil)
                    
                }
                
            }
        }
    }else{
        DispatchQueue.main.async {
            SVProgressHUD.dismiss()
            let alert = UIAlertController(title: "Linkon", message: "Please,check your internet connection", preferredStyle: .alert)
            let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
            alert.addAction(action)
            UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true, completion: nil)
            
        }
    }
}
public func uploadImageWithData(_ strUrl:String,params:[String:AnyObject]?,multipleImageData:[Data]?,imageData: Data?, success:@escaping (JSON) -> Void, failure:@escaping (Error) -> Void){
    if Connectivity.isConnectedToInternet {
        SVProgressHUD.show()
        SVProgressHUD.setDefaultMaskType(.clear)
        
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            
            
            if multipleImageData != nil{
                var count = 1
                for img in multipleImageData!{
                    
                    multipartFormData.append(img,withName: "image\(count)", fileName: "image\(count).jpeg", mimeType: "image/jpeg")
                    count += 1
                    
                }
            }else if imageData != nil{
                multipartFormData.append(imageData!,withName: "shop_logo", fileName: "image.jpeg", mimeType: "image/jpeg")
            }else{
                print("success")
            }
            
            
            for(key,value) in params!{
                multipartFormData.append(value.data(using:String.Encoding.utf8.rawValue)!, withName: key)
            }
            
            
        }, usingThreshold: UInt64.init(), to: strUrl, method: .post, headers:nil) { (result) in
            switch result{
            case .success(let upload, _, _):
                upload.uploadProgress(closure: { (progress) in
                    
                    print("uploding: \(progress.fractionCompleted)")
                })
                upload.responseJSON { response in
                    
                    
                    if response.result.isSuccess {
                        SVProgressHUD.dismiss()
                        let resJson = JSON(response.result.value!)
                        success(resJson)
                    }
                }
                
            case .failure(let error):
                
                print("Error in upload: \(error.localizedDescription)")
                failure(error)
                DispatchQueue.main.async {
                    SVProgressHUD.dismiss()
                    let alert = UIAlertController(title: "Linkon", message: "Server Failed", preferredStyle: .alert)
                    let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
                    alert.addAction(action)
                    UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true, completion: nil)
                    
                }
            }
            
        }
    }else{
        DispatchQueue.main.async {
            SVProgressHUD.dismiss()
            let alert = UIAlertController(title: "Linkon", message: "Please,check your internet connection", preferredStyle: .alert)
            let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
            alert.addAction(action)
            UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true, completion: nil)
            
        }
        
    }
    
}
public func requestGETURL(_ strURL: String, params : [String : AnyObject]?, success:@escaping (JSON) -> Void, failure:@escaping (Error) -> Void) {
    if Connectivity.isConnectedToInternet {
        SVProgressHUD.show()
        SVProgressHUD.setDefaultMaskType(.clear)
        
        Alamofire.request(strURL, method: .get, parameters: params, encoding: URLEncoding.default).responseJSON { (responseObject) -> Void in
            
           
            
            if responseObject.result.isSuccess {
                SVProgressHUD.dismiss()
                let resJson = JSON(responseObject.result.value!)
                success(resJson)
            }
            if responseObject.result.isFailure {
                //SVProgressHUD.dismiss()
                let error : Error = responseObject.result.error!
                failure(error)
                DispatchQueue.main.async {
                    SVProgressHUD.dismiss()
                    let alert = UIAlertController(title: "Linkon", message: "Server Failed", preferredStyle: .alert)
                    let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
                    alert.addAction(action)
                    UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true, completion: nil)
                    
                }
            }
        }
    }else{
        DispatchQueue.main.async {
            SVProgressHUD.dismiss()
            let alert = UIAlertController(title: "Linkon", message: "Please,check your internet connection", preferredStyle: .alert)
            let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
            alert.addAction(action)
            UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true, completion: nil)
            
        }
        
        
    }
}

