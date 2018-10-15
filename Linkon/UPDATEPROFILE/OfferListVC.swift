//
//  OfferListVC.swift
//  Linkon
//
//  Created by Avion on 7/12/18.
//  Copyright © 2018 Avion. All rights reserved.
//

import UIKit

class OfferListVC: UIViewController,UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate {

    var offerList = [String]()
    override func viewDidLoad() {
        super.viewDidLoad()

        let flipButton = UIBarButtonItem(image: UIImage(named: "check_selected"), style: .plain, target: self, action: #selector(self.createSearchBar))
        navigationItem.rightBarButtonItem = flipButton
        self.setNavigationBarItem()
        self.navigationController?.isNavigationBarHidden = false
        self.title = "Offer"
        
        // Do any additional setup after loading the view.
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.navigationItem.titleView = nil
        self.navigationItem.title = "Offer"
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    } // UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
      //  return offerList.count
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        let userCellID = "OfferCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: userCellID, for: indexPath) as! OfferCell
        cell.CardLayoutView.setCardLayoutEffect()
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 180.0
    }
    

}


