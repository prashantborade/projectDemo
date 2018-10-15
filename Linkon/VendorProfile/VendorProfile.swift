//
//  VendorProfile.swift
//  Linkon
//
//  Created by Avion on 7/30/18.
//  Copyright © 2018 Avion. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON

class VendorProfile {

    var status = NSNumber()
    var msg = String()
    var sellerDetails:SellerDetail
    var mapdata:Mapdata
    var videoData:VideoData
    
    init(vendorJSON:JSON) {
    
        self.sellerDetails = SellerDetail(selllerJSON:vendorJSON["sellerdetails"])
        self.mapdata = Mapdata(mapJSON:vendorJSON["mapdata"])
        self.videoData = VideoData(videoJSON:vendorJSON["videoData"])
        self.status = vendorJSON["status"].numberValue
        self.msg = vendorJSON["msg"].stringValue
    }
}
class SellerDetail {
    
    var shopLogo = String()
    var shopName = String()
    var shopDescription = String()
    var shopTiming = String()
    var shopEmail = String()
    var shopLocation = String()
    var shopContactno = String()
    
    
    init(selllerJSON:JSON) {
       
        self.shopLogo = selllerJSON["shopLogo"].stringValue
        self.shopName = selllerJSON["shopName"].stringValue
        self.shopDescription = selllerJSON["shopDescription"].stringValue
        self.shopTiming = selllerJSON["shopTiming"].stringValue
        self.shopEmail = selllerJSON["shopEmail"].stringValue
        self.shopLocation = selllerJSON["shopLocation"].stringValue
        self.shopContactno = selllerJSON["shopContactno"].stringValue
    }

}

class Mapdata {
    
    var mapLat = String()
    var mapLong = String()
    
    init(mapJSON:JSON) {
        
        self.mapLat = mapJSON["mapLat"].stringValue
        self.mapLong = mapJSON["mapLong"].stringValue
    }
}

class VideoData {
    
    var video = String()
    
    init(videoJSON:JSON) {
        
        self.video = videoJSON["video"].stringValue
    }
}

