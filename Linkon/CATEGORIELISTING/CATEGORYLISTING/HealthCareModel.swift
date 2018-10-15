//
//  HealthCareModel.swift
//  Linkon
//
//  Created by Avion on 8/7/18.
//  Copyright © 2018 Avion. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON

class HealthCareModel
{
  
    var status = NSNumber()
    var msg = String()
    var product_data:[ProductData]
    init(healthCareJSON:JSON) {
        
        self.product_data = [ProductData(productJSON: healthCareJSON["product_data"])]
        self.status = healthCareJSON["status"].numberValue
        self.msg = healthCareJSON["msg"].stringValue
    }
}

class ProductData {
    
    var product_id = String()
    var image = String()
    var shopName = String()
    var review = String()
    var rating =  Double()
    var description = String()
    
    init(productJSON:JSON) {
        
        self.product_id = productJSON["product_id"].stringValue
        self.image = productJSON["image"].stringValue
        self.shopName = productJSON["shopName"].stringValue
        self.review = productJSON["review"].stringValue
        self.rating = productJSON["rating"].doubleValue
        self.description = productJSON["description"].stringValue
        
    }
        
        
    
}
