//
//  CurrentUser.swift
//  Linkon
//
//  Created by Avion on 7/28/18.
//  Copyright © 2018 Avion. All rights reserved.
//

import Foundation
import UIKit

class CurrentUser: NSObject
{
    var firstName: String
    var lastName: String
    var email: String
    var password: String
    init(firstName:String,lastName:String,email:String,pwd:String)
    {
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
        self.password = pwd
    }
    
    
}
