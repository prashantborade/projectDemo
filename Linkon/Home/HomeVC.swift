//
//  HomeVC.swift
//  Linkon
//
//  Created by Avion on 7/13/18.
//  Copyright © 2018 Avion. All rights reserved.
//

import UIKit
import AVFoundation
import Alamofire
import SwiftyJSON
import SVProgressHUD
import SDWebImage
import Speech

enum ServiceDataKeys:String {
    case serviceName
    case serviceImage
    case serviceDescription
    
}

enum CategoryDataKeys:String{
    case categoryId
    case categoryName
    case categoryThumbImage
    case categoryImage
       
}

class HomeVC: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UISearchBarDelegate,UICollectionViewDelegateFlowLayout,UITabBarDelegate,UIPopoverPresentationControllerDelegate,SFSpeechRecognizerDelegate{

    @IBOutlet weak var popUpBackgroundView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var LatestCategoriesCollectionViewHeight: NSLayoutConstraint!
   
    // for voice Search
    @IBOutlet weak var btnAddPopupOutlet: UIButton!
    
    
    
    private let speechRecognizer = SFSpeechRecognizer(locale: Locale.init(identifier: "en-US"))!
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    private let audioEngine = AVAudioEngine()
    
    var index:Int = 0
    @IBOutlet var popUpView: UIView!
    var ScrollingTimer = Timer()
    var searchActive : Bool = false
//    var data:[String] = []
//    var filtered:[String] = []
    
    var animal = [String]()
    var photos = [String]()
//  var service_data = [String: String]()
//  var category_data = [String: String]()
    var serviceDataArray = NSMutableArray()
    var categoryDataArray = NSMutableArray()
    
    var filtered:[AnyObject] = []
    var categoryIDFromHome:String = ""
    var collectionHeight:CGFloat = 0.0
     var Scrollinftimer = Timer() // Set Timer
    @IBOutlet weak var tabItemHomeSelected: UITabBarItem!
    @IBOutlet weak var tabBarHome: UITabBar!
    
    @IBOutlet weak var featuredCollectionView: UICollectionView!
    
    @IBOutlet weak var tabBarAdd: UITabBarItem!
    @IBOutlet weak var LatestCategoriesCollectionView: UICollectionView!
    @IBOutlet weak var TabBarHomeSelected: UITabBarItem!
    override func viewDidLoad() {
        super.viewDidLoad()
 
        getServiceTypes()
        getWebserviceData()
        popUpBackgroundView.isHidden = true
        self.LatestCategoriesCollectionView.isScrollEnabled = false
       
        let tap = UITapGestureRecognizer(target: self, action: #selector(hidePopupView))
        tap.numberOfTapsRequired = 1
        self.popUpBackgroundView.addGestureRecognizer(tap)
       
        
        // set home tab Bar
        tabBarHome.selectedItem = tabBarHome.items![0] as UITabBarItem
        LatestCategoriesCollectionView?.backgroundColor = UIColor.clear
        //LatestCategoriesCollectionView?.contentInset = UIEdgeInsets(top: 23, left: 5, bottom: 5, right: 5)
        // Set the PinterestLayout delegate
//        if let layout = LatestCategoriesCollectionView?.collectionViewLayout as? PinterestLayout {
//            layout.delegate = self
//        }
        
        let layout = UICollectionViewFlowLayout()
       
//        self.cellSizeRow = self.cellSizeRow/self.row
//        self.cellSizeHeight = self.cellSizeHeight/self.col
       // layout.itemSize = CGSize(width: self.LatestCategoriesCollectionView.frame.width / 2, height: 200)
        
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.scrollDirection = .vertical
        layout.headerReferenceSize = CGSize(width: 0, height: 0)
        layout.sectionInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        
        self.LatestCategoriesCollectionView.collectionViewLayout = layout
        
        
//        DispatchQueue.main.async {
//
//            let layout1 = UICollectionViewFlowLayout()
//
//            layout1.minimumInteritemSpacing = 20
//            layout1.minimumLineSpacing = 0
//            layout1.scrollDirection = .horizontal
//            layout1.headerReferenceSize = CGSize(width: 0, height: 0)
//            layout1.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
//            self.featuredCollectionView.contentInset = UIEdgeInsetsMake(0, 60, 0, 60)
//            self.featuredCollectionView.collectionViewLayout = layout1
//
//
//        }

        setNavigationBarItem()
        self.title = "Home"
       
        // add search Bar
        let searchBtn = UIBarButtonItem(image: UIImage(named: "search"), style: .plain, target: self, action: #selector(self.createSearchBar))
        navigationItem.rightBarButtonItem = searchBtn
        
        //self.setNavigationBarItem()
        self.navigationController?.isNavigationBarHidden = false
        self.title = "Home"
        
    }
    override func viewWillAppear(_ animated: Bool) {
        getServiceTypes()
        getWebserviceData()
        self.navigationItem.titleView = nil
        self.navigationItem.title = "Home"
        
    }
    //MARK: AutoScroll Baner
    func startTimer() {
        
        Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(self.scroll) , userInfo: nil, repeats: true);
    }
    @objc func scroll()
    {
        if (index == serviceDataArray.count-1)
        {
            index = -1
        }
        index = index + 1
        let indexPath = IndexPath(item: self.index, section: 0)
        print(self.index)
        self.featuredCollectionView.scrollToItem(at: indexPath, at: [.centeredHorizontally], animated: true)
        
        
    }
    //  Private Functions
    private func viewConfigrations() {
        
        featuredCollectionView.register(UINib(nibName: "BanerCell", bundle: nil), forCellWithReuseIdentifier: "BanerCell")
        featuredCollectionView.contentInset = UIEdgeInsetsMake(0, 30, 0, 30)
        featuredCollectionView.decelerationRate = UIScrollViewDecelerationRateFast
    }
    
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
    }
    
    //  Create SearchBar
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.navigationItem.titleView = nil
        self.navigationItem.title = "Home"
        self.setNavigationBarItem()
    }
 
    @objc func createSearchBar()
    {
        let searchBar = UISearchBar()
        searchBar.showsCancelButton = true
        searchBar.placeholder = "Search here"
        searchBar.delegate = self
        self.navigationItem.titleView = searchBar
   
    }
    func gotoSearchController(searchText:String)
    {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let globalObj = storyboard.instantiateViewController(withIdentifier: "GlobalSearchVC") as! GlobalSearchVC
        globalObj.searchText = searchText
        
        self.navigationController?.pushViewController(globalObj, animated: true)
        
    }
    @objc func hidePopupView(){
        
        popUpBackgroundView.isHidden = true
    }
    //MARK: Get Service Types
    
    func getServiceTypes()
    {
        
        if ApiManagerClass.sharedInstance.isConnectedToInternet() == true {
            SVProgressHUD.show()
            SVProgressHUD.setDefaultMaskType(.clear)
            var url = webConstant.baseUrl
            url.append(webConstant.servicetype)
            
            let params:Dictionary  = ["usertype":"service_provider" as Any]
            
            Alamofire.request(url, method: .post, parameters: params)
                .responseJSON {
                    response in
                    switch response.result {
                    case .success:
                        print(response)
                        DispatchQueue.main.async {
                            
                            SVProgressHUD.dismiss()
                        }
                        if let JSON = response.result.value {
                            print("JSON register: \(JSON)")
                            let jsonResult: NSDictionary = response.result.value as! NSDictionary
                            if jsonResult["status"] as! NSNumber == 1
                            {
                                let message:String = jsonResult["msg"] as! String
                                
                                let serviceTypes = jsonResult["service_data"] as! NSArray
                                
                
                                 UserDefaults.standard.set(serviceTypes, forKey: "serviceTypes")
                            
//                                self.popupAlert(title: "Linkon", message: message, actionTitles: ["ok"], actions: [{ (action1) in
//
//                                    },{(action2) in
//
//                                    }])
                                
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
    
    // get WebServiceData
    func getWebserviceData()
    {
        
        if ApiManagerClass.sharedInstance.isConnectedToInternet() == true {
            SVProgressHUD.show()
            
            var url = webConstant.baseUrl
            url.append(webConstant.Homepage)
            
            Alamofire.request(url, method: .get)
                .responseJSON {
                    response in
                    switch response.result {
                    case .success:
                        print(response)
                        
                        DispatchQueue.main.async {
                            
                            SVProgressHUD.dismiss()
                        }
                        if let JSON = response.result.value {
                            print("JSON register: \(JSON)")
                            let jsonResult: NSDictionary = response.result.value as! NSDictionary
                            if jsonResult["status"] as! NSNumber == 1
                            {
                                let serviceData:NSDictionary = jsonResult["service_data"] as! NSDictionary
                                let categoryData:NSDictionary = jsonResult["category_data"] as!NSDictionary
                                
                                self.serviceDataArray.removeAllObjects()
                                self.categoryDataArray.removeAllObjects()
                                for str in serviceData {
                                    
                                    self.serviceDataArray.add(str.value)
                                }
                                for str in categoryData {
                                    
                                    self.categoryDataArray.add(str.value)
                                }
                                print(self.serviceDataArray)
                                self.featuredCollectionView.reloadData()
                                self.LatestCategoriesCollectionView.reloadData()
                                
                                // Autoscroll images
                                self.viewConfigrations()
                                self.startTimer()
                                
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
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return 1;
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView == self.featuredCollectionView {
            
            return self.serviceDataArray.count // Replace with count of your data for featuredCollectionView
        }
        else
        {
            if(searchActive) {
                
                return filtered.count
            }
            else
            {
              return self.categoryDataArray.count
            }// Replace with count of your data for
        }
        
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // Set up cell
        if collectionView == self.featuredCollectionView {
            
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BanerCell", for: indexPath) as! BanerCell
            cell.cardView.setCardLayoutEffect()
            let obj:NSDictionary = self.serviceDataArray[indexPath.row] as! NSDictionary
            let imgURL = obj.value(forKey: ServiceDataKeys.serviceImage.rawValue) as? String
            cell.wallpaperImageView.sd_setImage(with: URL(string: imgURL!), placeholderImage: UIImage(named: ""))
            cell.lbCaption.text! = (obj.value(forKey: ServiceDataKeys.serviceName.rawValue) as? String)!
            cell.lblComment.text! = (obj.value(forKey: ServiceDataKeys.serviceDescription.rawValue) as? String)!
//            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FeaturedCollectionCell", for: indexPath) as! FeaturedCollectionCell
//            cell.cardViewEffect.setCardLayoutEffect()
//            let obj:NSDictionary = self.serviceDataArray[indexPath.row] as! NSDictionary
//            cell.lblCaption.text! = (obj.value(forKey: ServiceDataKeys.serviceName.rawValue) as? String)!
//            cell.lblcomments.text! = (obj.value(forKey: ServiceDataKeys.serviceDescription.rawValue) as? String)!
//
//            print(cell.lblCaption.text!)
//            print(cell.lblcomments.text!)
//
//
//            let imgURL = obj.value(forKey: ServiceDataKeys.serviceImage.rawValue) as? String
//            cell.imageView.sd_setImage(with: URL(string: imgURL!), placeholderImage: UIImage(named: ""))
//
//
//            // Auto Scrolling cell
//
//            var rowIndex = indexPath.row
//            let Numberofrecords : Int = self.serviceDataArray.count - 1
//            if (rowIndex < Numberofrecords)
//            {
//                rowIndex = (rowIndex + 0) // 1
//            }
//            else
//            {
//                rowIndex = 0
//            }
            
//             Scrollinftimer = Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(HomeVC.startTimer(timersset:)), userInfo: rowIndex, repeats: true)
            
            return cell
        }
        else
        {
            // ...Set up cell
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LatestCategoryCell", for: indexPath) as! LatestCategoryCell
//            if let Cell = cell as? LatestCategoryCell {
            
                if(searchActive){
                    
                    let obj:NSDictionary = self.filtered[indexPath.row] as! NSDictionary
                    let imgURL = obj.value(forKey: CategoryDataKeys.categoryImage.rawValue) as? String
                    cell.lblTitle.text = (obj.value(forKey: CategoryDataKeys.categoryName.rawValue) as? String)?.uppercased()
                    
                    let imgIcon = obj.value(forKey: CategoryDataKeys.categoryThumbImage.rawValue) as? String
                    
                    if (imgURL == nil || (imgURL?.isEmpty)! || imgIcon == nil || (imgIcon?.isEmpty)!)
                    {
                        cell.imgView.image = UIImage(named: "NoImage")
                        cell.iconImgView.image = UIImage(named: "NoImage")
                    }
                    else {
                        cell.imgView.sd_setImage(with: URL(string: imgURL!), placeholderImage: UIImage(named: ""))
                        cell.iconImgView.sd_setImage(with: URL(string: imgIcon!), placeholderImage: UIImage(named: ""))
                    }
                    
                  //  return cell
                } else {
                   // cell.lblTitle.text = data[indexPath.row]
                      // let image = UIImage(named: photos[indexPath.item])
                    let obj:NSDictionary = self.categoryDataArray[indexPath.row] as! NSDictionary
                    let imgURL = obj.value(forKey: CategoryDataKeys.categoryImage.rawValue) as? String
                    cell.lblTitle.text = (obj.value(forKey: CategoryDataKeys.categoryName.rawValue) as? String)?.uppercased()
                  
                    let imgIcon = obj.value(forKey: CategoryDataKeys.categoryThumbImage.rawValue) as? String
                    
                    if (imgURL == nil || (imgURL?.isEmpty)! || imgIcon == nil || (imgIcon?.isEmpty)!)
                    {
                        cell.imgView.image = UIImage(named: "NoImage")
                        cell.iconImgView.image = UIImage(named: "NoImage")
                    }
                    else {
                        cell.imgView.sd_setImage(with: URL(string: imgURL!), placeholderImage: UIImage(named: ""))
                        cell.iconImgView.sd_setImage(with: URL(string: imgIcon!), placeholderImage: UIImage(named: ""))
                    }
            }
            return cell
        }
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if collectionView == self.featuredCollectionView {
            
            
        }
        else{
            
             if(searchActive){
                
                let obj:NSDictionary = self.filtered[indexPath.row] as! NSDictionary
                self.categoryIDFromHome =  (obj.value(forKey: CategoryDataKeys.categoryId.rawValue) as? String)!
                
               }
            else
             {
                let obj:NSDictionary = self.categoryDataArray[indexPath.row] as! NSDictionary
                self.categoryIDFromHome =  (obj.value(forKey: CategoryDataKeys.categoryId.rawValue) as? String)!
             }
            // self.navigationController?.popViewController(animated: true)
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let categororyListingVC = storyboard.instantiateViewController(withIdentifier: "CategoryListingVC") as! CategoryListingVC
            categororyListingVC.categoryID = self.categoryIDFromHome
            self.navigationController?.pushViewController(categororyListingVC, animated: true)
        }
        
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if collectionView == self.featuredCollectionView {
            
            var cellSize: CGSize = collectionView.bounds.size
            
            cellSize.width -= collectionView.contentInset.left * 2
            cellSize.width -= collectionView.contentInset.right * 2
            cellSize.height = cellSize.width
            
            return cellSize
        }
        else{
            let padding: CGFloat = 15
            let collectionCellSize = collectionView.frame.size.width - padding
            return CGSize(width: collectionCellSize/2, height: collectionCellSize/2)
        }
    
        
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        
        if scrollView == self.scrollView
        {
            self.LatestCategoriesCollectionView.isScrollEnabled = (self.scrollView.contentOffset.y >= 200)
        }
        
        if scrollView == self.LatestCategoriesCollectionView {
            
            self.LatestCategoriesCollectionView.isScrollEnabled = (self.LatestCategoriesCollectionView.contentOffset.y > 0)
        }
    }
    
    
//    //MARK:  Auto Scrolling method
//    @objc func scrollToNextCell(){
//
//        //get cell size
//        let cellSize = CGSize(width: self.view.frame.width, height: self.view.frame.height)
//        //get current content Offset of the Collection view
//        let contentOffset = self.featuredCollectionView.contentOffset;
//
//        if self.featuredCollectionView.contentSize.width <= self.featuredCollectionView.contentOffset.x + cellSize.width
//        {
//            self.featuredCollectionView.scrollRectToVisible(CGRect(x: 0, y: contentOffset.y, width: cellSize.width, height: cellSize.height), animated: true)
//
//        } else {
//
//            self.featuredCollectionView.scrollRectToVisible(CGRect(x: contentOffset.x + cellSize.width, y: contentOffset.y, width: cellSize.width, height: cellSize.height), animated: true)
//
//        }
//
//    }
//    func startTimer() {
//        Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(HomeVC.scrollToNextCell) , userInfo: nil, repeats: true);
//    }
    
    @IBAction func btnAddPopUpClicked(_ sender: UIButton) {
        
//        sender.isSelected = !sender.isSelected
//
//        if(sender.isSelected) {
//
//            print("yes")
//        }
//        else
//        {
//            print("No")
//        }
        popUpBackgroundView.isHidden = false
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
   
   
//    @objc func startTimer(timersset : Timer)
//    {
//        UIView.animate(withDuration: 5.0, delay: 0, options: .curveEaseOut, animations:
//            {
//                self.featuredCollectionView.scrollToItem(at: IndexPath(row: timersset.userInfo! as! Int,section:0), at: .centeredHorizontally, animated: false)
//
//         }, completion: nil)
//
//
//    }
  

    
//    // 1. Returns the photo height
//    func collectionView(_ collectionView: UICollectionView, heightForPhotoAtIndexPath indexPath:IndexPath) -> CGFloat {
//
//        if collectionView == self.LatestCategoriesCollectionView {
////        let image = UIImage(named: photos[indexPath.item])
////
////        let height = (image?.size.height)!/3
////        print("original height=\(height)")
////        collectionHeight = collectionHeight + (height/2)
////        print("collectionHeightt=\(height)")
//
//                switch arc4random_uniform(5) {
//                case 0 :
//                        return 200
//                case 1 :
//                        return 225
//                case 2 :
//                        return 250
//                case 4 :
//                        return 300
//                default :
//                        return 250
//            }
//
//        }
//        else
//        {
//            return 0
//        }
//    }
    
    // Search Bar Delegate
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false;
        searchBar.resignFirstResponder()
        if((searchBar.text) != nil){
            
            gotoSearchController(searchText: searchBar.text!)
        }
        
    }
    
    func searchBarBookmarkButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false;
    }
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        
    
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
//        // Put your key in predicate that is "Name"
//        let searchPredicate = NSPredicate(format: "categoryName CONTAINS[C] %@", searchText)
//        filtered = self.categoryDataArray.filtered(using: searchPredicate) as [AnyObject]
//
//        print ("array = \(filtered)")
//
//        if(filtered.count == 0){
//            searchActive = false;
//        } else {
//            searchActive = true;
//        }
//        self.LatestCategoriesCollectionView.reloadData()
//        //searchBar.resignFirstResponder()
        
    }
    
    //MARK: UITabBarDelegate Method
    
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        
        if (item.tag == 1)
        {
            let objAppDelegate = (UIApplication.shared.delegate as? AppDelegate)
            objAppDelegate?.gotoAllCategoryListingVC()
        }
        else if (item.tag == 2)
        {
            
        }
        else if (item.tag == 3)
        {
            let objAppDelegate = (UIApplication.shared.delegate as? AppDelegate)
            objAppDelegate?.gotoFavouritesVC()
        }
        else if (item.tag == 4)
        {
            let objAppDelegate = (UIApplication.shared.delegate as? AppDelegate)
            objAppDelegate?.gotoNotificationVC()
            
        }

   
        
    }
    
   
  
}

