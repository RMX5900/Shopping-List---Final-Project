//
//  Product.swift
//  Shopping List - Final Project
//
//  Created by admin on 14/01/2017.
//  Copyright © 2017 Gal Levy & Ben Mamia. All rights reserved.
//
import UIKit
import Foundation

class Product{
    var productName:String
    var productCompany:String
    var productQuantity:Int
    var addedByUserId:String
    var addedByUser:User
    var addedDate:String
    var imageUrl:String
    var productKey:String
    
    init(name:String, company:String, quantity:Int, image:String, addedByUserId:String, addedDate:String, productKey:String) {
        self.productName = name
        self.productCompany = company
        self.productQuantity = quantity
        self.imageUrl = image
        self.addedByUser = User()
        self.addedByUserId = addedByUserId
        self.addedDate = addedDate
        self.productKey = productKey
    }
}
