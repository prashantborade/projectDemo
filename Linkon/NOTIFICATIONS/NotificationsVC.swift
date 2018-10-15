//
//  NotificationsVC.swift
//  Linkon
//
//  Created by Avion on 7/10/18.
//  Copyright © 2018 Avion. All rights reserved.
//

import UIKit

class NotificationsVC: UIViewController,UITableViewDelegate,UITableViewDataSource,UITabBarDelegate,UIPopoverPresentationControllerDelegate {
    @IBOutlet weak var tabBarNotification: UITabBar!
    
    var hotels:[String: String] = ["The Grand Del Mar": "5300 Grand Del Mar Court, San Diego, CA 92130,5300 Grand Del Mar Court, San Diego, CA 92130,5300 Grand Del Mar Court, San Diego, CA 92130,5300 Grand Del Mar Court, San Diego, CA 92130,5300 Grand Del Mar Court, San Diego, CA 92130",
                                   "French Quarter Inn": "166 Church St, Charleston, SC 29401,5300 Grand Del Mar Court, San Diego, CA 92130,5300 Grand Del Mar Court, San Diego, CA 92130",
                                   "Bardessono": "6526 Yount Street, Yountville, CA 94599",
                                   "Hotel Yountville": "6462 Washington Street, Yountville, CA 94599",
                                   "Islington Hotel": "321 Davey Street, Hobart, Tasmania 7000, Australia,5300 Grand Del Mar Court, San Diego, CA 92130",
                                   "The Henry Jones Art Hotel": "25 Hunter Street, Hobart, Tasmania 7000, Australia",
                                   "Clarion Hotel City Park Grand": "22 Tamar Street, Launceston, Tasmania 7250, Australia",
                                   "Quality Hotel Colonial Launceston": "31 Elizabeth St, Launceston, Tasmania 7250, Australia",
                                   "Premier Inn Swansea Waterfront": "",
                                   "Hatcher's Manor": "73 Prossers Road, Richmond, Clarence, Tasmania 7025, Australia"]
    
    var hotelNames:[String] = []
    
    
    @IBOutlet weak var notificationTablView: UITableView!
    var notificationList = [NSDictionary]()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setNavigationBarItem()
        
        // set home tab Bar
        tabBarNotification.selectedItem = tabBarNotification.items![4] as UITabBarItem
        
        hotelNames = [String](hotels.keys)
        notificationTablView.estimatedRowHeight = 68.0
        notificationTablView.rowHeight = UITableViewAutomaticDimension
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    // UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return hotels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        let userCellID = "NotificationCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: userCellID, for: indexPath) as! NotificationCell
        
        let hotelName = hotelNames[indexPath.row]
        
        cell.lblCaption.text = hotelName
        cell.lblComment.text = hotels[hotelName]
        cell.cardView.setCardLayoutEffect()
    
        return cell
    }
    // MARK:  - UITabBar Delegate Methods
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        
        if (item.tag == 0)
        {
            let objAppDelegate = (UIApplication.shared.delegate as? AppDelegate)
            objAppDelegate?.gotoMainController()
        }
        else if (item.tag == 1)
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
    
    

}
