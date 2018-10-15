//
//  CartVC.swift
//  Linkon
//
//  Created by Avion on 8/14/18.
//  Copyright © 2018 Avion. All rights reserved.
//

import UIKit

class CartVC: UIViewController {

    @IBOutlet weak var cartView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
       cartView.setCardLayoutEffect()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
       
    }
    

}
