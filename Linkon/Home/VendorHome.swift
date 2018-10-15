//
//  VendorHome.swift
//  Linkon
//
//  Created by Avion on 8/1/18.
//  Copyright © 2018 Avion. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON

class VendorHome {
    
   
    var service_data:ServiceData
    var category_data:CategoryData
   
    
    init(vendorHomeJSON:JSON) {
        
        self.service_data = ServiceData(serviceDataJSON:vendorHomeJSON["service_data"])
        self.category_data = CategoryData(categoryDataJSON:vendorHomeJSON["category_data"])
       
    }
}
class CategoryData {
    
    var categoryId = String()
    var categoryName = String()
    var categoryUrl = String()
  

    init(categoryDataJSON:JSON) {
        
        self.categoryId = categoryDataJSON["categoryId"].stringValue
        self.categoryName = categoryDataJSON["categoryName"].stringValue
        self.categoryUrl = categoryDataJSON["categoryUrl"].stringValue
      
    }
    
}

class ServiceData {
    
    var serviceImage = String()
    var serviceName = String()
    var serviceDescription = String()
    

    init(serviceDataJSON:JSON) {
        
        self.serviceImage = serviceDataJSON["serviceImage"].stringValue
        self.serviceName = serviceDataJSON["serviceName"].stringValue
        self.serviceDescription = serviceDataJSON["serviceDescription"].stringValue
    }
}

