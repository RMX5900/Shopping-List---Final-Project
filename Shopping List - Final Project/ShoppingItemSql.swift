//
//  ShoppingItemSql.swift
//  Shopping List - Final Project
//
//  Created by Mac on 11/02/2017.
//  Copyright © 2017 Gal Levy & Ben Mamia. All rights reserved.
//

import Foundation
extension Product{
    static let PRODUCTS_TABLE = "PRODUCTS"
    static let PR_ID = "PR_ID"
    static let PR_NAME = "NAME"
    static let PR_IMAGE_URL = "IMAGE_URL"
    static let PR_QUANTITY = "QUANTITY"
    static let PR_COMPANY = "COMPANY"
    static let PR_ADDED_DATE = "ADDED_DATE"
    static let PR_GROUP_ID = "GROUP_ID"
    
    
    static func createTable(database:OpaquePointer?)->Bool{
        var errormsg: UnsafeMutablePointer<Int8>? = nil
        
        let res = sqlite3_exec(database, "CREATE TABLE IF NOT EXISTS " + PRODUCTS_TABLE + " ( " + PR_ID + " TEXT PRIMARY KEY, "
            + PR_NAME + " TEXT, "
            + PR_IMAGE_URL + " TEXT"
            + PR_QUANTITY + " TEXT"
            + PR_COMPANY + " TEXT"
            + PR_ADDED_DATE + " TEXT"
            + PR_GROUP_ID + " TEXT"
            
            + ")"
            
            , nil, nil, &errormsg);
        if(res != 0){
            print("error creating table products");
            return false
        }
        
        return true
    }
    
    func addProduct(database:OpaquePointer?){
        var sqlite3_stmt: OpaquePointer? = nil
        if (sqlite3_prepare_v2(database,"INSERT OR REPLACE INTO " + Product.PRODUCTS_TABLE
            + "(" + Product.PR_ID + ","
            + Product.PR_NAME + ","
            + Product.PR_IMAGE_URL + ","
            + Product.PR_QUANTITY + ","
            + Product.PR_COMPANY + ","
            + Product.PR_ADDED_DATE + "," +
            +Product.PR_GROUP_ID +
            "," + ") VALUES (?,?,?,?,?,?,?);",-1, &sqlite3_stmt,nil) == SQLITE_OK){
            
            //let id = self..cString(using: .utf8)
            let name = self.productName.cString(using: .utf8)
            let key = self.productKey.cString(using: .utf8)
            var imageUrl = "".cString(using: .utf8)
            if self.imageUrl != nil {
                imageUrl = self.imageUrl.cString(using: .utf8)
            }
            
            //let quantity = self.productQuantity.cString(using: .utf8)
            let company = self.productCompany.cString(using: .utf8)
            let date = self.addedDate.cString(using: .utf8)
           // let groupId = self.cString(using: .utf8)
            
            sqlite3_bind_text(sqlite3_stmt, 1, key,-1,nil);
            sqlite3_bind_text(sqlite3_stmt, 2, name,-1,nil);
            sqlite3_bind_text(sqlite3_stmt, 3, imageUrl,-1,nil);
            sqlite3_bind_text(sqlite3_stmt, 5, company,-1,nil);
            sqlite3_bind_text(sqlite3_stmt, 6, date,-1,nil);
            
            if(sqlite3_step(sqlite3_stmt) == SQLITE_DONE){
                print("new row added succefully")
            }
        }
        sqlite3_finalize(sqlite3_stmt)
    }
    
    static func getAllStudents(database:OpaquePointer?)->[Product]{
        var products = [Product]()
        var sqlite3_stmt: OpaquePointer? = nil
        if (sqlite3_prepare_v2(database,"SELECT * from PRODUCTS WHERE GROUP_ID=?;",-1,&sqlite3_stmt,nil) == SQLITE_OK){
            while(sqlite3_step(sqlite3_stmt) == SQLITE_ROW){
                let stId =  String(validatingUTF8:sqlite3_column_text(sqlite3_stmt,0))
                let name =  String(validatingUTF8:sqlite3_column_text(sqlite3_stmt,1))
                var imageUrl =  String(validatingUTF8:sqlite3_column_text(sqlite3_stmt,2))
                print("read from filter st: \(stId) \(name) \(imageUrl)")
                if (imageUrl != nil && imageUrl == ""){
                    imageUrl = nil
                }
                let product = Product.init(name: <#T##String#>, company: <#T##String#>, quantity: <#T##Int#>, image: <#T##String#>, addedByUserId: <#T##String#>, addedDate: <#T##String#>, productKey: <#T##String#>)
                products.append(product)
            }
        }
        sqlite3_finalize(sqlite3_stmt)
        return products
    }
    
}
