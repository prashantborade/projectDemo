
//  ProfileVC.swift
//  Linkon
//
//  Created by Avion on 7/10/18.
//  Copyright © 2018 Avion. All rights reserved.
//

import UIKit
import LIHImageSlider
import MapKit
import Alamofire
import SVProgressHUD
import SwiftyJSON
import SDWebImage

class CustomPin:NSObject,MKAnnotation
{
    var coordinate: CLLocationCoordinate2D
    var subtitle: String?
    var title: String?
    init(pinTitle:String,pinSubTitle:String,location:CLLocationCoordinate2D) {
        
        self.title = pinTitle
        self.subtitle = pinSubTitle
        self.coordinate = location
        
    }
}

class VendorProfileVC: UIViewController,UIScrollViewDelegate,LIHSliderDelegate,MKMapViewDelegate,UIWebViewDelegate {
   
    //
    var customerID:String!
    var sellerID:String!
    
    var custIDFav:String!
    var sellerIDFav:String!
    
    // vendor Profle
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var imgVendorProfile: UIImageView!
    @IBOutlet weak var lblVendorTitle: UILabel!
    @IBOutlet weak var textViewVendorDecription: UITextView!
    
    @IBOutlet weak var lblVendorEmail: UILabel!
    @IBOutlet weak var beforeShopTime: UILabel!
    
    @IBOutlet weak var afterShopTime: UILabel!
    @IBOutlet weak var lblVendorPhone: UILabel!
    @IBOutlet weak var lblVendorAddress: UILabel!
    @IBOutlet weak var lblVendorReviewCount: UILabel!
    
    @IBOutlet weak var mainProfileView: UIView!
    @IBOutlet weak var webVideo: UIWebView!
    var myResponse : JSON = JSON.null
    var users : [VendorProfile] = []
    var addFavourits = [NSDictionary]()
    //for image slider
     @IBOutlet weak var photoGalleryView: UIView!
     fileprivate var sliderVc1: LIHSliderViewController!
    
    // rating view
    @IBOutlet weak var FullstarRating: CosmosView!
     private let starRating:Float = 2.0
    
    //video view
  //  @IBOutlet weak var videoView: UIView!
    @IBOutlet weak var mapView: UIView!
    @IBOutlet weak var myMap: MKMapView!
    @IBOutlet weak var btnShare: UIButton!
    @IBOutlet weak var btnLike: UIButton!
    @IBOutlet weak var btnedit: UIButton!
  
     var sliderImages = NSMutableArray()
     var imagesArray: [UIImage] = []
    var isFromMenu:Bool = false
    @IBOutlet weak var profileView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
      
        btnedit.isHidden = true
        
        showVendorProfile()
        
        // add RightBar Button
//        let rightBarBtn = UIBarButtonItem(image: UIImage(named: "search"), style: .plain, target: self, action: #selector(self.addGallery))
//        navigationItem.rightBarButtonItem = rightBarBtn
//        self.navigationController?.isNavigationBarHidden = false
        self.title = "Home"
        
        
        // get Vendor Profile Data
        self.setNavigationBarItem()
        self.imgVendorProfile.makeCircle()
        self.btnShare.btnMakeCircle()
        self.btnLike.btnMakeCircle()
        self.webVideo.setCardLayoutEffect()
        self.photoGalleryView.setCardLayoutEffect()
        self.mapView.setCardLayoutEffect()
        self.title = "Vendor Profile"
        let value = Double(starRating)
        self.FullstarRating.rating = value
        
        webVideo.scrollView.isScrollEnabled = false
       // webVideo.scrollView.bounces = false
       webVideo.scrollView.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, 0, 0)
       
        self.profileView.clipsToBounds = true
        self.profileView.layer.cornerRadius = 15
        if #available(iOS 11.0, *) {
            self.profileView.layer.maskedCorners = [.layerMinXMaxYCorner,.layerMaxXMaxYCorner]
        } else {
            // Fallback on earlier versions
        }
        
    }
    override func viewWillAppear(_ animated: Bool) {
        
        showVendorProfile()
    }
    func showVendorProfile() {
        
        if(isFromMenu)
        {
            let userData = UserDefaults.standard.object(forKey: "customerDataSignUp") as![String : AnyObject]
            let params:Dictionary = ["customer_id": userData["customer_id"] as Any, "seller_id":userData["seller_id"] as Any]
            getWebserviceData(params: params)
            btnedit.isHidden = false
            btnLike.isHidden = true
            btnShare.isHidden = true
            
            
        }
        else
        {
            let params:Dictionary = ["customer_id": self.customerID!, "seller_id":self.sellerID!]
           // getVendorProfileData(params: params)
            btnedit.isHidden = true
            btnLike.isHidden = false
            btnShare.isHidden = false
            getWebserviceData(params: params)
        }
    }
    @objc func addGallery() {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let updateProfileVC = storyboard.instantiateViewController(withIdentifier: "AddGalleryVC") as! AddGalleryVC
        self.navigationController?.pushViewController(updateProfileVC, animated: true)
        
    }
    func updateSlider(){
    
        let slider1: LIHSlider = LIHSlider(images: self.imagesArray)
        self.sliderVc1  = LIHSliderViewController(slider: slider1)
        sliderVc1.delegate = self
        self.addChildViewController(self.sliderVc1)
        self.sliderVc1.view.setCardLayoutEffect()
        self.mainProfileView.addSubview(self.sliderVc1.view)
        self.sliderVc1.didMove(toParentViewController: self)

    }
    // set custom pin
    func updateMapView(lat:Double , lon:Double,title:String){
        
        let location = CLLocationCoordinate2D(latitude: lat, longitude: lon)
        let region = MKCoordinateRegion(center: location, span: MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005))
        self.myMap.setRegion(region, animated: true)
        let pin = CustomPin(pinTitle: title, pinSubTitle: "", location: location)
        self.myMap.addAnnotation(pin)
        self.myMap.delegate = self
        
    }
    @IBAction func btnFavouriteClicked(_ sender: Any) {
        
        callAddFavourite()
    }
    @IBAction func btneditClicked(_ sender: Any) {
        
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        let updateProfileVC = storyboard.instantiateViewController(withIdentifier: "EditVendorProfileVC") as! EditVendorProfileVC
//        self.navigationController?.pushViewController(updateProfileVC, animated: true)
    }
    
    @IBAction func readMoreClicked(_ sender: Any){
        
        
    }
    @IBAction func shareVendorLinkClicked(_ sender: Any) {
        
       // self.App_Link = "google.com"
        let text = "google.com"
        
        // set up activity view controller
        let textToShare = [ text ]
        let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
        activityViewController.popoverPresentationController?.sourceRect = CGRect(x: view.center.x, y: view.center.y, width: 0, height: 0)
        
        activityViewController.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection(rawValue: 0)
        // present the view controller
        self.present(activityViewController, animated: true, completion: nil)
        
        
    }
    @IBAction func likeVendorProfileClicked(_ sender: Any) {
    }
    
    // MKmapView Delegate
    
    // for slider image
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
    
        if annotation is MKUserLocation
        {
            return nil
        }
        
        let annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "custompin")
        annotationView.image = UIImage(named: "mapIcon")
        annotationView.canShowCallout = true
        return annotationView
    }
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        
        print("Annotation Title= \(view.annotation?.title!)")
        
    }
    override func viewDidLayoutSubviews() {
       
        if (self.imagesArray.count > 0) {
        self.sliderVc1!.view.frame = self.photoGalleryView.frame
        }
    }
    
    func itemPressedAtIndex(index: Int) {
        
        print("index \(index) is pressed")
    }
    func webViewDidStartLoad(_ webView: UIWebView) {
        
        self.activityIndicator.startAnimating()
        
    }
    func webViewDidFinishLoad(_ webView: UIWebView) {
        
       self.activityIndicator.stopAnimating()
       self.activityIndicator.hidesWhenStopped = true
    }
    func getLabelHeight(text: String, width: CGFloat, font: UIFont) -> CGFloat {
        let lbl = UILabel(frame: .zero)
        lbl.frame.size.width = width
        lbl.font = font
        lbl.numberOfLines = 0
        lbl.text = text
        lbl.sizeToFit()
        
        return lbl.frame.size.height
    }

    // addFevourite
    func callAddFavourite(){
        var url = webConstant.baseUrl
        url.append(webConstant.addfavorite)
        
        let params = ["cust_id":self.custIDFav , "seller_id": self.sellerIDFav]
        
        requestPOSTURL(url, params: params as [String : AnyObject], success: { (data) in
            print(data)
            let status = data["status"].boolValue
            let message = data["msg"].stringValue
            if !status{
                
                self.popupAlert(title: "Linkon", message:message, actionTitles: ["Ok"], actions:[{ (action1) in }])
            }else{
                
                self.addFavourits = data["data"].arrayObject! as! [NSDictionary]
                if (self.addFavourits.count > 0){
                    
                    let obj = self.addFavourits[0]
                    self.custIDFav = obj.value(forKey: "cust_id") as? String
                    self.sellerIDFav = obj.value(forKey: "seller_id") as? String
                    
                    self.popupAlert(title: "Linkon", message:message, actionTitles: ["Ok"], actions:[{ (action1) in }])
                }
                
            }
        }) { (error) in
            print(error)
        }
    }
    
    // get WebServiceData
    func getWebserviceData( params:Dictionary<String, Any>)
    {
        
        if ApiManagerClass.sharedInstance.isConnectedToInternet() == true {
            SVProgressHUD.show()
            SVProgressHUD.setDefaultMaskType(.clear)
            var url = webConstant.baseUrl
            url.append(webConstant.vendorProfile)
//            var params = NSDictionary()
            
          //  let params:Dictionary  = ["customer_id":"1" as Any]
            
            Alamofire.request(url, method: .post, parameters: params)
                .responseJSON {
                    response in
                    switch response.result {
                    case .success(let data):

                        SVProgressHUD.dismiss()
                        if response.result.value != nil {
                            
                            self.myResponse = JSON(data)
                            print(self.myResponse["status"])
                           
                            if (self.myResponse["status"]).boolValue
                            {
                                
                                let jsonResult: NSDictionary = response.result.value as! NSDictionary
                                let message:String = self.myResponse["msg"].stringValue
                                var seller_data = self.myResponse["seller_data"].dictionary!["sellerdetails"]?.dictionary
                                let sellerdetails:NSDictionary = jsonResult["seller_data"] as! NSDictionary
                                let images:NSDictionary = sellerdetails["images"] as! NSDictionary
                            
                                for str in images {
                                    
                                    self.sliderImages.add(str.value)
                                }
                            
                                for img in self.sliderImages
                                {
                                    
                                    if !(((img as? String) != nil))
                                    {
                                    do {
                                        let url:URL = URL(string: img as! String )!
                                        let data = try Data(contentsOf: url)
                                        let images = UIImage(data: data)
                                        self.imagesArray.append(images!)
                                        print("image array = \(self.imagesArray)")
                                    }
                                    catch{
                                        print(error)
                                    }
                                    }
                                 }
                             
                                if (self.imagesArray.count > 0) { self.updateSlider() }
                                
                                let imgURL = seller_data!["shopLogo"]?.stringValue
                                self.imgVendorProfile.sd_setImage(with: URL(string: imgURL!), placeholderImage: UIImage(named: "userProfile"))
                                self.textViewVendorDecription.text = seller_data!["shopDescription"]?.stringValue
//                                self.beforeShopTime.text = "\(seller_data!["before_shop_time_from"]!.stringValue) to \(seller_data!["before_shop_time_to"]!.stringValue)"
                                
//                                self.afterShopTime.text = "\(seller_data!["after_shop_time_from"]!.stringValue) to \(seller_data!["after_shop_time_to"]!.stringValue)"
//                                
//                                self.beforeShopTime.text = "\(seller_data!["before_shop_time_from"]!.stringValue) to \(seller_data!["before_shop_time_to"]!.stringValue)"

                               
                                self.lblVendorEmail.text = seller_data!["shopEmail"]?.stringValue
                                self.lblVendorPhone.text = seller_data!["shopContactno"]?.stringValue
                                self.lblVendorAddress.text = seller_data!["shopLocation"]?.stringValue
                                self.lblVendorTitle.text = seller_data!["shopName"]?.stringValue
                                self.lblVendorReviewCount.text = seller_data!["review"]?.stringValue
                                
                                let youtubeVideoLink:String = "http://www.youtube.com/embed/xcJtL7QggTI"
                                var str2:String = "&playsinline=1&showinfo=0&loop=1&rel=0&fs=0&modestbranding=0&iv_load_policy=3"
                                var str:String = youtubeVideoLink+str2
                                let width = self.webVideo.frame.width
                                let height = self.webVideo.frame.height
                                let frame = 10
                                let htmlCode:String = "<iframe width=\(width) height=\(height) src=\(str) frameborder=\(frame) ></iframe>"
                                self.webVideo.allowsInlineMediaPlayback = true
                                self.webVideo.loadHTMLString(htmlCode as String , baseURL: nil )
//
//                                var str1:String = "http://www.youtube.com/embed/xcJtL7QggTI"
//                                var str2:String = "?&playsinline=1"
//                                var str:String = str1+str2
//                                 self.webVideo.allowsInlineMediaPlayback = true
//                                 self.webVideo.loadHTMLString("<iframe width=\"\(self.webVideo.frame.width)\" height=\"\(self.webVideo.frame.height)\" src=\"\(str)\" frameborder=\"0\" allowfullscreen=\"true\"></iframe>", baseURL: nil)
                                
                                
                //src=\"http://www.youtube.com/embed/efRNKkmWdc0?&playsinline=1\"

//
//                                self.webVideo.loadHTMLString("", baseURL: <#T##URL?#>)
//                                //src=\"http://www.youtube.com/embed/efRNKkmWdc0?&playsinline=1\"
//
//                                <iframe allow="autoplay; encrypted-media" allowfullscreen="" src="https://www.youtube.com/embed/xcJtL7QggTI?playlist=xcJtL7QggTI&amp;loop=1&amp;showinfo=0" width="560" height="315" frameborder="0"></iframe>
                                
                                // for mapView
                                let mapdata:NSDictionary = sellerdetails["mapdata"] as! NSDictionary
                                
                                let mapLat:String = mapdata["mapLat"] as! String
                                let mapLong:String = mapdata["mapLong"] as! String
                                
                                self.updateMapView(lat: Double(mapLat)!, lon: Double(mapLong)!,title: self.lblVendorTitle.text!)
                                
                            }
                            else
                            {
                                SVProgressHUD.dismiss()
                                let message:String = self.myResponse["msg"].stringValue
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
            
            ApiManagerClass.sharedInstance.showMessage(title: NSLocalizedString("Linkon", comment: ""), msg: NSLocalizedString("internercheck", comment: ""), on: self)
            
        }
        
    }

    //MARK:- WebService call
    func getVendorProfileData(params:Dictionary<String, Any>){
        var url = webConstant.baseUrl
        url.append(webConstant.vendorProfile)
        
        requestPOSTURL(url, params: params as [String : AnyObject], success: { (data) in
            print(data)
            let status = data["status"].boolValue
            let message = data["msg"].stringValue
            if !status{
                
                
                self.popupAlert(title: "Linkon", message:message, actionTitles: ["Ok"], actions:[{ (action1) in
                    
                    }])
            }else{
                
                let vendorPrfileData = data["seller_data"].dictionaryObject!
                let sellerdetails = data["seller_data"]["sellerdetails"].dictionaryObject!
                self.popupAlert(title: "Linkon", message:message, actionTitles: ["Ok"], actions:[{ (action1) in
                    
                    }])
               // print("\(String(describing: vendorPrfileData))")
                print("\(String(describing: sellerdetails))")
                
                
                //                let dob = data["dob"].stringValue
                //                let lastName = data["last_name"].stringValue
                //                let firstName = data["first_name"].stringValue
                //                let email = data["email"].stringValue
                //                let profileImage = data["profile_image"].stringValue
                //                _ = data["address"].stringValue
                //                let fullname = firstName + " " + lastName
                //                self.lblFullname.text = fullname
                //                self.txtEmail.text = email
                //                self.txtLastname.text = lastName
                //                self.txtFirstname.text = firstName
                //                self.txtDateOfBirth.text = dob
                
                
                //                    {
                //                        "status": 1,
                //                        "msg": "The Customer data has been saved.",
                //                        "data": {
                //                            "customer": {
                //                                "id": "4",
                //                                "email": "test20@gmail.com",
                //                                "firstname": "test8",
                //                                "lastname": "test9",
                //                                "storeId": 1,
                //                                "websiteId": 1
                //                            }
                //                        }
                //                }
                
            }
        }) { (error) in
            print(error)
        }
        
    }
    
 

}
