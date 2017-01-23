//
//  Group.swift
//  Shopping List - Final Project
//
//  Created by admin on 14/01/2017.
//  Copyright © 2017 Gal Levy & Ben Mamia. All rights reserved.
//

import Foundation

class Group {
    
    var mailList:[String]
    var groupName:String
    var shoppingList:[Product]
    
    // init the params
    init(mails:[String], name:String, list:[Product]) {
        self.mailList = mails
        self.groupName = name
        self.shoppingList = list
    }
}
