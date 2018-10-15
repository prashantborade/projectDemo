//
//  ChoosePlanVC.swift
//  Linkon
//
//  Created by Avion on 7/17/18.
//  Copyright © 2018 Avion. All rights reserved.
//

import UIKit

class ChoosePlanVC: UIViewController {

    @IBOutlet weak var segmentControllPlan: UISegmentedControl!
    override func viewDidLoad() {
        super.viewDidLoad()

        segmentControllPlan.layer.cornerRadius = 20.0
        segmentControllPlan.layer.borderColor = UIColor.lightGray.cgColor
        segmentControllPlan.layer.borderWidth = 1.0
        segmentControllPlan.layer.masksToBounds = true
        segmentControllPlan.setTitleTextAttributes([NSAttributedStringKey.foregroundColor: UIColor.white], for: .selected)
        
        self.setNavigationBarItem()
        
        self.title = "Choose a Plan"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    

}
