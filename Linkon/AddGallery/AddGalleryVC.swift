//
//  AddGalleryVC.swift
//  Linkon
//
//  Created by Avion on 8/30/18.
//  Copyright © 2018 Avion. All rights reserved.
//

import UIKit
import SVProgressHUD
import Alamofire
    
class AddGalleryVC: UIViewController,UIImagePickerControllerDelegate , UINavigationControllerDelegate {
        
    @IBOutlet weak var firstCardLayoutView: UIView!
    @IBOutlet weak var secondCardLayoutView: UIView!
    @IBOutlet weak var thirdCardLayoutView: UIView!
    @IBOutlet weak var fourthCardLayoutView: UIView!
    @IBOutlet weak var fifthCardLayoutView: UIView!
    @IBOutlet weak var txtVideoURL: UITextField!
    var imagePicker:UIImagePickerController? = UIImagePickerController()
    var  flagImage:String = ""
    @IBOutlet weak var firstImgView: UIImageView!
    @IBOutlet weak var secondImgView: UIImageView!
    @IBOutlet weak var thirdImgView: UIImageView!
    @IBOutlet weak var fourthImgView: UIImageView!
    @IBOutlet weak var fifthImgView: UIImageView!
        
        
        
    override func viewDidLoad() {
    super.viewDidLoad()
        
    
    self.setNavigationBarItem()
    title = "Add Gallery"
    getWebserviceData()
    firstCardLayoutView.setCardLayoutEffect()
    secondCardLayoutView.setCardLayoutEffect()
    thirdCardLayoutView.setCardLayoutEffect()
    fourthCardLayoutView.setCardLayoutEffect()
    fifthCardLayoutView.setCardLayoutEffect()
    imagePicker?.delegate = self
    
        }
   
    override func viewWillAppear(_ animated: Bool) {
       
        getWebserviceData()
    }
    override func didReceiveMemoryWarning() {
            super.didReceiveMemoryWarning()
            
        }
        //MARK: IBAction for set image
    @IBAction func setFirstImage(_ sender: Any) {
            
            flagImage = "first";
            self.openGallery()
            
        }
    @IBAction func setSecondImage(_ sender: Any) {
            
            flagImage = "second";
            self.openGallery()
        }
    @IBAction func setThirdImage(_ sender: Any) {
            
            flagImage = "third";
            self.openGallery()
        }
        
    @IBAction func setFourthImage(_ sender: Any) {
            
            flagImage = "fourth";
            self.openGallery()
        }
    @IBAction func setFifthImage(_ sender: Any) {
            
            flagImage = "five";
            self.openGallery()
        }
        
    // MARK: - UIImagePickerControllerDelegate Methods
        
    func openGallery()
        {
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary)
            {
                let imagePicker = UIImagePickerController()
                imagePicker.delegate = self
                imagePicker.sourceType = .photoLibrary;
                imagePicker.allowsEditing = true
                self.present(imagePicker, animated: true, completion: nil)
            }
        }
        
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
            if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
                
                if flagImage == "first"{
                    
                    self.firstImgView.image = pickedImage;
                    self.firstImgView.autoresizingMask = [.flexibleWidth, .flexibleHeight, .flexibleBottomMargin, .flexibleRightMargin, .flexibleLeftMargin, .flexibleTopMargin]
                    self.firstImgView.contentMode = .scaleAspectFill // OR .scaleAspectFill
                    self.firstImgView.clipsToBounds = true
                    
                }
                else if flagImage == "second"
                {
                    self.secondImgView.image = pickedImage;
                    self.secondImgView.autoresizingMask = [.flexibleWidth, .flexibleHeight, .flexibleBottomMargin, .flexibleRightMargin, .flexibleLeftMargin, .flexibleTopMargin]
                    self.secondImgView.contentMode = .scaleAspectFill // OR .scaleAspectFill
                    self.secondImgView.clipsToBounds = true
                }
                else if flagImage == "third"
                {
                    self.thirdImgView.image = pickedImage;
                    self.secondImgView.autoresizingMask = [.flexibleWidth, .flexibleHeight, .flexibleBottomMargin, .flexibleRightMargin, .flexibleLeftMargin, .flexibleTopMargin]
                    self.secondImgView.contentMode = .scaleAspectFill // OR .scaleAspectFill
                    self.secondImgView.clipsToBounds = true
                    
                }
                else if flagImage == "fourth"
                {
                    self.fourthImgView.image = pickedImage;
                    self.secondImgView.autoresizingMask = [.flexibleWidth, .flexibleHeight, .flexibleBottomMargin, .flexibleRightMargin, .flexibleLeftMargin, .flexibleTopMargin]
                    self.secondImgView.contentMode = .scaleAspectFill // OR .scaleAspectFill
                    self.secondImgView.clipsToBounds = true
                }
                else
                {
                    
                    self.fifthImgView.image = pickedImage;
                    self.secondImgView.autoresizingMask = [.flexibleWidth, .flexibleHeight, .flexibleBottomMargin, .flexibleRightMargin, .flexibleLeftMargin, .flexibleTopMargin]
                    self.secondImgView.contentMode = .scaleAspectFill // OR .scaleAspectFill
                    self.secondImgView.clipsToBounds = true
                }
            }
            picker.dismiss(animated: true, completion: nil)
        }
        
    @IBAction func addNewClicked(_ sender: Any) {
        
          self.uploadImageToServer()
    
    }
    //MARK: get WebServiceData
        func getWebserviceData()
        {
            
            if ApiManagerClass.sharedInstance.isConnectedToInternet() == true {
                SVProgressHUD.show()
                SVProgressHUD.setDefaultMaskType(.clear)
                var url = webConstant.baseUrl
                url.append(webConstant.vendorimages)
                
               let userData = UserDefaults.standard.object(forKey: "customerDataSignUp") as![String : AnyObject]
               let params:Dictionary  = ["customer_id":userData["customer_id"]! as Any]
                
               // let params:Dictionary  = ["customer_id":"2" as Any]
                
                Alamofire.request(url, method: .post, parameters: params)
                    .responseJSON {
                        response in
                        switch response.result {
                        case .success:
                            print(response)
                       
                            if let JSON = response.result.value {
                                
                                print("JSON register: \(JSON)")
                                
                                let jsonResult: NSDictionary = response.result.value as! NSDictionary
                                
                                if jsonResult["status"] as! NSNumber == 1
                                {
                                    
                                    let message:String = jsonResult["msg"] as! String
                                    let sellerData:NSDictionary = jsonResult["seller_data"] as! NSDictionary
                                    let idVDict:NSDictionary = sellerData["id"] as! NSDictionary
                                    let id = idVDict.value(forKey: "id") as! String
                                    
                                    let videoData:NSDictionary = sellerData["videoData"] as! NSDictionary
                                    self.txtVideoURL.text = videoData.value(forKey: "video") as! String
                                    

                                    
                                    if let imagesDict:NSDictionary = sellerData["images"] as! NSDictionary {
                                        
                                        if let imgUrl:String = imagesDict["image"] as? String{
                                            
                                            self.firstImgView.sd_setImage(with: URL(string: imgUrl))
                                        }
                                        
                                        if let imgUrl:String = imagesDict["image2"] as? String {
                                            
                                            self.secondImgView.sd_setImage(with: URL(string: imgUrl))
                                        }
                                        if let imgUrl:String = imagesDict["image3"] as? String {
                                            
                                            self.thirdImgView.sd_setImage(with: URL(string: imgUrl))
                                        }
                                        if let imgUrl:String = imagesDict["image4"] as? String {
                                            
                                            self.fourthImgView.sd_setImage(with: URL(string: imgUrl))
                                        }
                                        if let imgUrl:String = imagesDict["image5"] as? String {
                                            
                                            self.fifthImgView.sd_setImage(with: URL(string: imgUrl))
                                        }
                                    }
                                    
                                    self.popupAlert(title: "Linkon", message: message, actionTitles: ["ok"], actions: [{ (action1) in
                                        },{(action2) in }])
                                    
                                }else
                                {
                                    DispatchQueue.main.async {
                                        
                                        SVProgressHUD.dismiss()
                                    }
                                    let message:String = jsonResult["msg"] as! String
                                    ApiManagerClass.sharedInstance.showMessage(title: NSLocalizedString("Linkon", comment: ""), msg: message, on: self)
                                }
                            }
                            else
                            {
                                ApiManagerClass.sharedInstance.showMessage(title: NSLocalizedString("Linkon", comment: ""), msg: NSLocalizedString("somethingwrong", comment: ""), on: self)
                            }
                            
                            DispatchQueue.main.async {
                                
                               SVProgressHUD.dismiss()
                            }
                            
                            
                            break
                        case .failure(let error):
                            print(error)
                            
                            DispatchQueue.main.async {
                                SVProgressHUD.dismiss()
                            }
                            ApiManagerClass.sharedInstance.showMessage(title: NSLocalizedString("Linkon", comment: ""), msg: NSLocalizedString("ServerError", comment: ""), on: self)
                        }
                }
            }else{
                
                ApiManagerClass.sharedInstance.showMessage(title: NSLocalizedString("Linkon", comment: ""), msg: NSLocalizedString("internercheck", comment: ""), on: self)
                
            }
            
        }
    
    //MARK:Upload images
    func uploadImageToServer(){
        
        var url = webConstant.baseUrl
        url.append(webConstant.vendorgallarysave)
        var image = [Data]()
        
        let userData = UserDefaults.standard.object(forKey: "customerDataSignUp") as![String : AnyObject]
    
        let parameters = ["seller_id":userData["seller_id"]! as! String]
        
        if self.firstImgView?.image != nil
        {
            let imgData1 = UIImageJPEGRepresentation((self.firstImgView?.image)!, 0.2)
            image .append(imgData1!)
            
        }
        
        if self.secondImgView?.image != nil
        {
            let imgData2 = UIImageJPEGRepresentation((self.secondImgView?.image)!, 0.2)
            image .append(imgData2!)
            
        }
        if  self.thirdImgView?.image != nil
        {
            let imgData3 = UIImageJPEGRepresentation((self.thirdImgView?.image)!, 0.2)
            image .append(imgData3!)
            
        }
        if self.fourthImgView?.image != nil
        {
            let imgData4 = UIImageJPEGRepresentation((self.fourthImgView?.image)!, 0.2)
            image .append(imgData4!)
            
        }
        if self.fifthImgView?.image != nil
        {
            let imgData5 = UIImageJPEGRepresentation((self.fifthImgView?.image)!, 0.2)
            image .append(imgData5!)
            
        }
        //        let imgData1 = UIImageJPEGRepresentation((btn_One.imageView?.image)!, 0.2)
        //        let imgData2 = UIImageJPEGRepresentation((btn_Two.imageView?.image)!, 0.2)
        //        let imgData3 = UIImageJPEGRepresentation((btn_Three.imageView?.image)!, 0.2)
        
        
        uploadImageWithData(url, params: parameters as [String : AnyObject], multipleImageData: image,imageData:nil , success: { (data) in
            print(data)
            let resp = data["resp"].boolValue
            let message = data["message"].stringValue
            if !resp{
                self.popupAlert(title: "Linkon", message: message, actionTitles: ["Ok"], actions: [{ (action1) in
                   
                    }])
            }else{
                
                self.popupAlert(title: "Linkon", message: message, actionTitles: ["Ok"], actions: [{ (action1) in
                
                    }])
            }
        }) { (error) in
            print(error)
        }
    }
        
   
        
}

