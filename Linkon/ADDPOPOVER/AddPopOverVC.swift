//
//  AddPopOverVC.swift
//  Linkon
//
//  Created by Avion on 8/24/18.
//  Copyright © 2018 Avion. All rights reserved.
//

import UIKit

class AddPopOverVC: UIViewController, UITableViewDelegate,UITableViewDataSource {

    var popOver:[String] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        
        popOver = ["Add your business","How Linkon works","Refer a Busines","Advertise with us","Share App"]

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        return popOver.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        let userCellID = "CustomCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: userCellID, for: indexPath) as! CustomCell
        tableView.separatorStyle = .none
        cell.lblTitle?.text = popOver[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 50
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
    }

  

}
