//
//  FavouritesVC.swift
//  Linkon
//
//  Created by Avion on 7/10/18.
//  Copyright © 2018 Avion. All rights reserved.
//

import UIKit

class FavouritesVC: UIViewController,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UITabBarDelegate,UIPopoverPresentationControllerDelegate {

    @IBOutlet weak var tabBarFavourite: UITabBar!
    @IBOutlet weak var collectionViewFavourite: UICollectionView!
    var favouriteList = [NSDictionary]()
    override func viewDidLoad() {
        super.viewDidLoad()
    
        
        
        if UserDefaults.standard.bool(forKey: "HomeVC")
        {
             self.collectionViewFavourite.isHidden = false
             getFevouriteList()
        }
        else
        {
            showMessage()
            self.collectionViewFavourite.isHidden = true
        }
        
        // set home tab Bar
        tabBarFavourite.selectedItem = tabBarFavourite.items![3] as UITabBarItem

         self.setNavigationBarItem()
    
         title = "Favourites"
        let layout = UICollectionViewFlowLayout()
        //        self.cellSizeRow = self.cellSizeRow/self.row
        //        self.cellSizeHeight = self.cellSizeHeight/self.col
        // layout.itemSize = CGSize(width: self.LatestCategoriesCollectionView.frame.width / 2, height: 200)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.scrollDirection = .vertical
        layout.headerReferenceSize = CGSize(width: 0, height: 0)
        layout.sectionInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        self.collectionViewFavourite.collectionViewLayout = layout
    }
    func showMessage()
    {
        let lblMessage =  UILabel(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 200))
        lblMessage.center = self.view.center
        lblMessage.text = "Sorry!!! Your not sign in."
        lblMessage.textAlignment = .center
        lblMessage.numberOfLines = 0
        lblMessage.textColor = UIColor.red
        
        self.view.addSubview(lblMessage)
    
    }
 
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return favouriteList.count;
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FavouriteCell", for: indexPath) as! FavouriteCell
        
        //configure cell
        let favObj = favouriteList[indexPath.row]
        cell.containerView.setCardLayoutEffect()
        
        cell.lblTitle.text = favObj.value(forKey: "shop_title") as? String
        cell.lblDecription.text = favObj.value(forKey: "shop_description") as? String
        cell.reviewCount.text = favObj.value(forKey: "review") as? String
        let imgURL = favObj.value(forKey: "shop_logo") as? String
        let ratingValue:Float = ((favObj.value(forKey: "rating") as? NSString)?.floatValue)!
        cell.ratingView.rating = Double(ratingValue)
        cell.imgView.sd_setImage(with: URL(string: imgURL!), placeholderImage: UIImage(named: "NoImage"))
       

        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let padding: CGFloat = 15
        let collectionCellSize = collectionView.frame.size.width - padding
        
        return CGSize(width: collectionCellSize/2, height: collectionCellSize/2 + 30)
        
    }
    
  // MARK:  - UITabBar Delegate Methods
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        
        if (item.tag == 0)
        {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let updateProfileVC = storyboard.instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
            self.navigationController?.pushViewController(updateProfileVC, animated: false)
        }
        else if (item.tag == 1)
        {
            
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
    // getFevouriteList
    func getFevouriteList(){
        var url = webConstant.baseUrl
        url.append(webConstant.favoritelisting)

        let userData = UserDefaults.standard.object(forKey: "customerDataSignUp") as![String : AnyObject]
        let params:Dictionary  = ["cust_id":userData["customer_id"]! as Any]
      
        requestPOSTURL(url, params: params as [String : AnyObject], success: { (data) in
            print(data)
            let status = data["status"].boolValue
            let message = data["msg"].stringValue
            if !status{

//                self.popupAlert(title: "Linkon", message:message, actionTitles: ["Ok"], actions:[{ (action1) in }])
                 self.collectionViewFavourite.setEmptyMessage(message)
                
            }else{

                self.favouriteList = data["category_data"].arrayObject! as! [NSDictionary]
                
                if (self.favouriteList.count > 0){

                    DispatchQueue.main.async(execute: {() -> Void in self.collectionViewFavourite.reloadData() })
                     self.collectionViewFavourite.restore()
                  }
                
            }
        }) { (error) in
            print(error)
        }
    }

}
