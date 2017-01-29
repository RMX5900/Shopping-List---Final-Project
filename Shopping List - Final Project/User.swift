//
//  User.swift
//  Shopping List - Final Project
//
//  Created by Mac on 28/01/2017.
//  Copyright © 2017 Gal Levy & Ben Mamia. All rights reserved.
//

import Foundation

class User{
    var userId:String
    var firstName:String
    var lastName:String
    var email:String
    
    init(userId:String, firstName:String, lastName:String, email:String) {
        self.userId = userId
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
    }
    
    init(){
        self.userId = ""
        self.firstName = ""
        self.lastName = ""
        self.email = ""
    }
}
