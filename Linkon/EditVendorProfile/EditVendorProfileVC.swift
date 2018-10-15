//
//  EditVendorProfileVC.swift
//  Linkon
//
//  Created by Avion on 8/28/18.
//  Copyright © 2018 Avion. All rights reserved.
//

import UIKit
import SVProgressHUD
import Alamofire
import CoreData
import GoogleMaps
import GooglePlaces

class EditVendorProfileVC: UIViewController,GMSMapViewDelegate,UITextFieldDelegate, UITextViewDelegate,UIImagePickerControllerDelegate , UINavigationControllerDelegate {
   
    
    var locality:String = ""
    var postal_code:String = ""
    
    var txtserviceType: UITextField!
    var txtlatitude: UITextField!
    var txtlongitude: UITextField!
    
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var btnAddProfile: UIButton!
    @IBOutlet weak var txtUserName: TextField!
    @IBOutlet weak var txtCityName: TextField!
    @IBOutlet weak var txtLocationName: TextField!
    @IBOutlet weak var txtEmailAddress: TextField!
    @IBOutlet weak var txtContactNumber: TextField!
    @IBOutlet weak var txtTypeOfServices: TextField!
    @IBOutlet weak var btnServiceMenu: UIButton!
    @IBOutlet weak var txtServiceName: TextField!
    @IBOutlet weak var txtFromTime1: TextField!
    @IBOutlet weak var txtToTime1: TextField!
    @IBOutlet weak var txtFromTime2: TextField!
    @IBOutlet weak var txtToTime2: TextField!
    
    @IBOutlet weak var txtZipCode: TextField!
    @IBOutlet weak var textViewDiscription: UITextView!
    @IBOutlet weak var tblViewMenu: UITableView!
    
    var serviceList = [NSDictionary]()
    override func viewDidLoad() {
        super.viewDidLoad()
        getVendorProfileData()
        let userData:Dictionary = UserDefaults.standard.object(forKey: "customerDataSignUp") as![String : AnyObject]
        serviceList = (UserDefaults.standard.object(forKey: "serviceTypes") as! NSArray) as! [NSDictionary]
       // txtEmailAddress.text! = userData["email"] as! String
        print(userData)
        
        let obj = serviceList[Int(userData["service_type"] as! String)!]
        txtTypeOfServices.text! = obj.value(forKey: "name") as! String
        
        
        
        self.setNavigate()
        self.txtserviceType = UITextField()
        self.txtserviceType.delegate = self
        self.txtlatitude = UITextField()
        self.txtlatitude.delegate = self
        self.txtlongitude = UITextField()
        self.txtlongitude.delegate = self
        
        

        self.imgProfile.makeCircle()
        self.tblViewMenu.isHidden = true
        
        title = "Update Profile"
    }
    @IBAction func btnAddProfileClicked(_ sender: Any) {
        
        self.openGallery()
    }
    
    @IBAction func btnServiceMenuClicked(_ sender: Any) {
        
        if tblViewMenu.isHidden
        {
            animate(toogle: true)
        }
        else
        {
            animate(toogle: false)
        }
    }
    func animate(toogle:Bool)
    {
        if toogle
        {
            UIView.animate(withDuration: 0.3) {
                self.tblViewMenu.isHidden = false
            }
            
        }
        else
        {
            UIView.animate(withDuration: 0.3) {
                self.tblViewMenu.isHidden = true
            }
        }
    }
    @IBAction func btnSubmitClicked(_ sender: Any) {
        
        if (txtUserName.text?.isEmpty)!{
            popupAlert(title: "Linkon", message: "Please Enter Your Username", actionTitles: ["Ok"], actions: [{ (action1) in
                },{(action2) in
                    
                }])
        }else if (txtServiceName.text?.isEmpty)!{
            popupAlert(title: "Linkon", message: "Please Enter Your Company Name", actionTitles: ["Ok"], actions: [{ (action1) in
                },{(action2) in
                    
                }])
        }
        else if (txtEmailAddress.text?.isEmpty)!{
            popupAlert(title: "Linkon", message: "Please Enter Your E-mail Address", actionTitles: ["Ok"], actions: [{ (action1) in
                },{(action2) in
                    
                }])
            
        }else if !isValidEmail(testStr: txtEmailAddress.text!){
            popupAlert(title: "Linkon", message: "Please Enter Correct E-mail Address", actionTitles: ["Ok"], actions: [{ (action1) in
                },{(action2) in
                    
                }])
        }else if (txtContactNumber.text?.isEmpty)!{
            popupAlert(title: "Linkon", message: "Please Enter Your Contact Number", actionTitles: ["Ok"], actions: [{ (action1) in
                },{(action2) in
                    
                }])
            
        }else if (txtLocationName.text?.isEmpty)!{
            popupAlert(title: "Linkon", message: "Please Enter Your Businedd Address", actionTitles: ["Ok"], actions: [{ (action1) in
                },{(action2) in
                    
                }])
            
        }
        else if (txtCityName.text?.isEmpty)!{
            popupAlert(title: "Linkon", message: "Please Enter Your City", actionTitles: ["Ok"], actions: [{ (action1) in
                },{(action2) in
                    
                }])
            
        }else if (txtZipCode.text?.isEmpty)!{
            popupAlert(title: "Linkon", message: "Please Enter Your ZipCode", actionTitles: ["Ok"], actions: [{ (action1) in
                },{(action2) in
                    
                }])
            
        }else if (txtTypeOfServices.text?.isEmpty)!{
            popupAlert(title: "Linkon", message: "Please Enter Your TypeService", actionTitles: ["Ok"], actions: [{ (action1) in
                },{(action2) in
                    
                }])
            
        }else if (txtFromTime1.text?.isEmpty)!{
            popupAlert(title: "Linkon", message: "Please Enter Your Time", actionTitles: ["Ok"], actions: [{ (action1) in
                },{(action2) in
                    
                }])
            
        }else if (txtToTime1.text?.isEmpty)!{
            popupAlert(title: "Linkon", message: "Please Enter Your Time", actionTitles: ["Ok"], actions: [{ (action1) in
                },{(action2) in
                    
                }])
            
        }else if (txtFromTime2.text?.isEmpty)!{
            popupAlert(title: "Linkon", message: "Please Enter Your Time", actionTitles: ["Ok"], actions: [{ (action1) in
                },{(action2) in
                    
                }])
            
        }else if (txtToTime2.text?.isEmpty)!{
            popupAlert(title: "Linkon", message: "Please Enter Your Time", actionTitles: ["Ok"], actions: [{ (action1) in
                },{(action2) in
                    
                }])
            
        }else if (textViewDiscription.text?.isEmpty)!{
            popupAlert(title: "Linkon", message: "Please Enter Your Time", actionTitles: ["Ok"], actions: [{ (action1) in
                },{(action2) in
                    
                }])
            
        }
        else
        {
            
            editVendorProfile()
            /*
             seller_id
             shop_id
             shop_title
             shop_email
             contact_number
             shop_description
             shop_logo
             service_type
             shop_location
             shop_latitude
             shop_longitude
             shop_zipcode
             city
             before_shop_time_from
             before_shop_time_to
             after_shop_time_from
             after_shop_time_to
             */
            
        }
        
        
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
       
    }
//    func textField(_ textField: UITextField, shouldChangeCharactersIn range:NSRange, replacementString string: String) -> Bool
//    {
//
//        let currentCharacterCount = txtContactNumber.text?.count ?? 0
//        if (range.length + range.location > currentCharacterCount){
//            return false
//        }
//        let newLength = currentCharacterCount + string.count - range.length
//        return newLength <= 10
//
//    }
    func textViewDidBeginEditing(_ textView: UITextView) {
        textViewDiscription.text = ""
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        if (textField == txtLocationName) {
        let acController = GMSAutocompleteViewController()
        acController.delegate = self
//        let filterContrller = GMSAutocompleteFilter()
//        filterContrller.type = GMSPlacesAutocompleteTypeFilter.address
        self.present(acController, animated: true, completion: nil)
        }
        
      /*  GMSAutocompleteViewController *acController = [[GMSAutocompleteViewController alloc] init];
        acController.delegate = self;
        GMSAutocompleteFilter *filter = [[GMSAutocompleteFilter alloc] init];
        filter.type = kGMSPlacesAutocompleteTypeFilterAddress;
        filter.country=@"US";
        acController.autocompleteFilter=filter;
        [self presentViewController:acController animated:YES completion:nil]; */
        
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
       
          
            self.imgProfile.image = pickedImage;
            imgProfile.autoresizingMask = [.flexibleWidth, .flexibleHeight, .flexibleBottomMargin, .flexibleRightMargin, .flexibleLeftMargin, .flexibleTopMargin]
            imgProfile.contentMode = .scaleAspectFill // OR .scaleAspectFill
            imgProfile.clipsToBounds = true
          
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    //MARK:- WebService call
    func getVendorProfileData(){
        var url = webConstant.baseUrl
        url.append(webConstant.vendorProfile)
        
        let userData = UserDefaults.standard.object(forKey: "customerDataSignUp") as![String : AnyObject]
        let params = ["customer_id": userData["customer_id"] as Any, "seller_id":userData["seller_id"] as Any]
        
        requestPOSTURL(url, params: params as [String : AnyObject], success: { (data) in
            print(data)
            let status = data["status"].boolValue
            let message = data["msg"].stringValue
            if !status{
                
                self.popupAlert(title: "Linkon", message:message, actionTitles: ["Ok"], actions:[{ (action1) in
                    
                    }])
            }else{
              
               self.txtUserName.text! = data["seller_data"]["sellerdetails"]["shop_id"].stringValue
               self.txtEmailAddress.text! = data["seller_data"]["sellerdetails"]["shopEmail"].stringValue
               self.txtServiceName.text! = data["seller_data"]["sellerdetails"]["shopName"].stringValue
               self.txtContactNumber.text! = data["seller_data"]["sellerdetails"]["shopContactno"].stringValue
               self.txtLocationName.text! = data["seller_data"]["sellerdetails"]["shopLocation"].stringValue
               self.txtCityName.text! = data["seller_data"]["mapdata"]["city"].stringValue
               self.txtZipCode.text! = data["seller_data"]["mapdata"]["zipcode"].stringValue
               self.txtFromTime1.text! = data["seller_data"]["sellerdetails"]["before_shop_time_from"].stringValue
               self.txtToTime1.text! = data["seller_data"]["sellerdetails"]["before_shop_time_to"].stringValue
               self.txtFromTime2.text! = data["seller_data"]["sellerdetails"]["after_shop_time_from"].stringValue
               self.txtToTime2.text! = data["seller_data"]["sellerdetails"]["after_shop_time_to"].stringValue
               self.textViewDiscription.text! = data["seller_data"]["sellerdetails"]["shopDescription"].stringValue
               let imgURL = data["seller_data"]["sellerdetails"]["shopLogo"].stringValue
               self.imgProfile.sd_setImage(with: URL(string: imgURL), placeholderImage: UIImage(named: "userProfile"))
              
            }
        }) { (error) in
            print(error)
        }
        
    }
    
    func editVendorProfile(){
        var url = webConstant.baseUrl
        url.append(webConstant.editseller)
        
        
        //let time2 = "\(txtFromTime2.text!) to  \(txtToTime2.text!)"
        
        let userData = UserDefaults.standard.object(forKey: "customerDataSignUp") as![String : AnyObject]
        
        let imgData = UIImageJPEGRepresentation(self.imgProfile.image!, 0.2)
        
        let parameters = ["seller_id":"\(userData["seller_id"]!)",
                          "shop_id":txtUserName.text! ,
                          "shop_title":txtServiceName.text! ,
                          "shop_email":txtEmailAddress.text! ,
                          "contact_number":txtContactNumber.text! ,
                          "shop_description":textViewDiscription.text! ,
                          "service_type":txtserviceType.text! ,
                          "shop_location":txtLocationName.text! ,
                          "shop_latitude":txtlatitude.text! ,
                          "shop_longitude":txtlongitude.text! ,
                          "shop_zipcode":txtZipCode.text! ,
                          "city":txtCityName.text! ,
                          "before_shop_time_from":txtFromTime1.text! ,
                          "before_shop_time_to":txtToTime1.text! ,
                          "after_shop_time_from":txtFromTime2.text! ,
                          "after_shop_time_to":txtToTime2.text! ] as [String : Any] as [String : Any]
        
        
        uploadImageWithData(url, params: parameters as [String : AnyObject], multipleImageData: nil,imageData: imgData, success: { (data) in
            print(data)
            let status = data["status"].boolValue
            let message = data["msg"].stringValue
            
            if !status{
                self.popupAlert(title: "Linkon", message: message, actionTitles: ["Ok"], actions: [{ (action1) in
                    self.navigationController?.popViewController(animated: true)
                    }])
            }else{
                
                self.txtEmailAddress.text! = data["data"]["shop_email"].stringValue
                
                print(self.txtEmailAddress.text!)
             
                self.popupAlert(title: "Linkon", message: message, actionTitles: ["Ok"], actions: [{ (action1) in
                    self.navigationController?.popViewController(animated: true)
                    }])
            }
        }) { (error) in
            print(error)
        }
        
    }
    
    
    
}

extension EditVendorProfileVC: UITableViewDelegate,UITableViewDataSource {
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.serviceList.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        let obj = self.serviceList[indexPath.row]
        
        cell.textLabel!.text = obj.value(forKey: "name") as? String
        cell.textLabel?.textAlignment = .center
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        let obj = self.serviceList[indexPath.row]
        txtTypeOfServices.text! = (obj.value(forKey: "name") as? String)!
        //serviceType.text! = (obj.value(forKey: "id") as? String)!
        
        animate(toogle: false)
    }
}

extension EditVendorProfileVC: GMSAutocompleteViewControllerDelegate {
    
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        
        self.txtlatitude.text! = "\(place.coordinate.latitude)"
        self.txtlongitude.text! = "\(place.coordinate.longitude)"
        self.txtLocationName.text = place.formattedAddress
        
        print("Place name: \(place.name)")
        print("Place name: \(place.coordinate.latitude)")
        print("Place name: \(place.coordinate.longitude)")
        print("Place name: \(place.placeID)")
        print("Place address: \(place.formattedAddress ?? "null")")
        print("Place attributions: \(String(describing: place.attributions))")
        
        
        // Get the address components.
        if let addressLines = place.addressComponents {
            // Populate all of the address fields we can find.
            for field in addressLines {
                switch field.type {
                case kGMSPlaceTypeStreetNumber:
                    print("street_number: \(field.name)")
                   // street_number = field.name
                case kGMSPlaceTypeRoute:
                    print("route: \(field.name)")
                   // route = field.name
                case kGMSPlaceTypeNeighborhood:
                    print("neighborhood: \(field.name)")
                   // neighborhood = field.name
                case kGMSPlaceTypeLocality:
                    print("locality: \(field.name)")
                     locality = field.name
                case kGMSPlaceTypeAdministrativeAreaLevel1:
                    print("administrative_area_level_1: \(field.name)")
                   // administrative_area_level_1 = field.name
                case kGMSPlaceTypeCountry:
                    print("country: \(field.name)")
                   // country = field.name
                case kGMSPlaceTypePostalCode:
                    print("postal_code: \(field.name)")
                    postal_code = field.name
                case kGMSPlaceTypePostalCodeSuffix:
                    print("Place name: \(field.name)")
                    //postal_code_suffix = field.name
                // Print the items we aren't using.
                default:
                    print("Type: \(field.type), Name: \(field.name)")
                }

            }
        }
        
        fillAddressForm()
        
        self.dismiss(animated: true, completion: nil)
    }
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        // TODO: handle the error.
        //        print("Error: \(error.description)")
        self.dismiss(animated: true, completion: nil)
    }
    
    // User canceled the operation.
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        print("Autocomplete was cancelled.")
        self.dismiss(animated: true, completion: nil)
    }
    // Populate the address form fields.
    func fillAddressForm() {
        
        txtCityName.text! = locality
        txtZipCode.text! = postal_code
        // Clear values for next time.
       
        locality = ""
        postal_code = ""

    }
    
}





