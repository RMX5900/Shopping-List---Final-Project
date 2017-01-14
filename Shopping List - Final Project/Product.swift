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
    var productImage:UIImage?
    
    init(name:String, company:String, quantity:Int, image:UIImage?) {
        self.productName = name
        self.productCompany = company
        self.productQuantity = quantity
        self.productImage = image
    }
}
