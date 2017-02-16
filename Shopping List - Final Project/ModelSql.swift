//
//  ModelSql.swift
//  Shopping List - Final Project
//
//  Created by Mac on 11/02/2017.
//  Copyright © 2017 Gal Levy & Ben Mamia. All rights reserved.
//

import Foundation
import SQLite



/*
extension String {
    public init?(validatingUTF8 cString: UnsafePointer<UInt8>) {
        if let (result, _) = String.decodeCString(cString, as: UTF8.self,
                                                  repairingInvalidCodeUnits: false) {
            self = result
        }
        else {
            return nil
        }
    }
}
*/

/*
 
 static let PRODUCTS_TABLE = "PRODUCTS"
 static let PR_ID = "PR_ID"
 static let PR_NAME = "NAME"
 static let PR_IMAGE_URL = "IMAGE_URL"
 static let PR_QUANTITY = "QUANTITY"
 static let PR_COMPANY = "COMPANY"
 static let PR_ADDED_DATE = "ADDED_DATE"
 static let PR_GROUP_ID = "GROUP_ID"
 
 */

class ModelSql{
    
    var db:Connection
    init() throws{
        db = try Connection("path/to/db.sqlite3")
    }
    
    func getProductsByGroupId(groupId:String)throws -> [Product]{
       var productsResult:[Product] = [Product]()
       let productsTable = try createProductsTable()
       let groupIdExp = Expression<String>("groupId")
       let products = productsTable.filter(groupIdExp == groupId)
        
        let id = Expression<String>("id")
        let name = Expression<String?>("name")
        let imageUrl = Expression<String>("imageUrl")
        let quantity = Expression<Int64>("quantity")
        let company = Expression<String>("company")
        let addedDate = Expression<String>("addedDate")
        let addedByUserId = Expression<String>("addedByUserId")
        
        for productItem in try db.prepare(products) {
            let product = Product.init(name: productItem[name]!,
                                       company: productItem[company],
                                       quantity: Int(productItem[quantity]),
                                       image: productItem[imageUrl],
                                       addedByUserId: productItem[addedByUserId],
                                       addedDate: productItem[addedDate],
                                       productKey: productItem[id])
            
            productsResult.append(product)

        }
        return productsResult
    }
    func getGroupsByUserId(userId:String) throws{
        var groupsResult:[Group] = [Group]()
        let groupsTable = try createGroupsTable()
        //let userGroupsTable = try createUserGroupsTable()
        let groupIdExp = Expression<String>("groupId")
        let userIdExp = Expression<String>("userId")
        let nameExp = Expression<String>("name")
        let imageUrl = Expression<String>("imageUrl")
        let id = Expression<String>("groupId")
        let query = groupsTable.join(groupsTable, on: groupIdExp == groupsTable[groupIdExp])
        .filter(userIdExp==userId)
        for groupItem in try db.prepare(query) {
            let group = Group.init(mails: [],
                                   name: groupItem[nameExp],
                                   list: [],
                                   groupId: groupItem[id],
                                   img: groupItem[imageUrl])
            
            
            
            /*
             
             self.mailList = mails
             self.groupName = name
             self.shoppingList = list
             self.groupId = groupId
             self.imageUrl = img
             */
            
            
            groupsResult.append(group)
        }
    }
        
    func getUserByEmail(email:String) throws{
        let user:User = User()
        let usersTable = try createGroupsTable()
        let emailExp = Expression<String>("email")
        let name = Expression<String>("name")
        let id = Expression<String>("id")

        let query = usersTable.filter(emailExp==email)
        for userItem in try db.prepare(query) {
            user.email = userItem[emailExp];
            user.firstName = userItem[name];
            user.userId = userItem[id];
        }
    }
    
    func addProduct(product:Product, groupId:String) throws{
        
         let id = Expression<String>("id")
         let name = Expression<String?>("name")
         let imageUrl = Expression<String>("imageUrl")
         let quantity = Expression<Int64>("quantity")
         let company = Expression<String>("company")
         let addedDate = Expression<String>("addedDate")
 
        let productsTable = try createProductsTable()
        let groupIdExp = Expression<String>("groupId")
        let userIdExp = Expression<String>("userId")
        try db.run(productsTable.insert(name <- product.productName,
                             id <- product.productKey,
                             imageUrl <- product.imageUrl,
                             quantity <- Int64(product.productQuantity),
                             company <- product.productCompany,
            addedDate <- product.addedDate,
            groupIdExp <- groupId
                             ))
    }
    func updateProduct(product:Product) throws{
        
        let idExp = Expression<String>("id")
        let name = Expression<String?>("name")
        let imageUrl = Expression<String>("imageUrl")
        let quantity = Expression<Int64>("quantity")
        let company = Expression<String>("company")
        
        
        let productsTable = try createProductsTable()
        let productItem = productsTable.filter(idExp==product.productKey)
        try db.run(productItem.update(name <- product.productName))
        try db.run(productItem.update(imageUrl <- product.imageUrl))
        try db.run(productItem.update(quantity <- Int64(product.productQuantity)))
        try db.run(productItem.update(company <- product.productCompany))

    }
    func addUser(user:User) throws{
        let usersTable = try createUsersTable()
        
        let id = Expression<String>("id")
        let name = Expression<String?>("name")
        let email = Expression<String>("email")
        
        let query = usersTable.insert(id <- user.userId,
                           name <- user.firstName,
                           email <- user.email
        )
        try db.run(query)
    }
    func addGroup(group:Group, userId:String) throws{
        
        let id = Expression<String>("id")
        let name = Expression<String?>("name")
        let imageUrl = Expression<String>("imageUrl")
        
        let groupsTable = try createGroupsTable()
        let groupIdExp = Expression<String>("groupId")
        let userIdExp = Expression<String>("userId")
        try db.run(groupsTable.insert(name <- group.groupName,
                             id <- group.groupId,
                             imageUrl <- group.imageUrl
        ))
    }
    func addUserToGroup(userId:String, groupId:String) throws{
        let groupsTable = try createGroupsTable()
        let groupIdExp = Expression<String>("groupId")
        let userIdExp = Expression<String>("userId")
        try db.run(groupsTable.insert(groupIdExp <- groupId,
                           userIdExp <- userId
        ))
    }
    func removeUserFromGroup(userId:String, groupId:String) throws{
        let userGroups = try createUserGroupsTable()
        let groupIdExp = Expression<String>("groupId")
        let userIdExp = Expression<String>("userId")
        
        let userGroup = userGroups.filter(groupIdExp==groupId).filter(userIdExp==userIdExp)
        try db.run(userGroup.delete())
    }
    func removeProduct(productId:String, groupId:String) throws{
        let productsTable = try createProductsTable()
        let productIdExp = Expression<String>("id")
        let groupIdExp = Expression<String>("groupId")
        
        let product = productsTable.filter(groupIdExp==groupId).filter(productIdExp==productId)
        try db.run(product.delete())
    }
    
    func createProductsTable()throws-> Table{
        let db = try Connection("db/db.sqlite3")
        let products = Table("products")
        let id = Expression<String>("id")
        let name = Expression<String?>("name")
        let imageUrl = Expression<String>("imageUrl")
        let quantity = Expression<Int64>("quantity")
        let company = Expression<String>("company")
        let addedDate = Expression<String>("addedDate")
        let groupId = Expression<String>("groupId")
        
        try db.run(products.create(ifNotExists: true) { t in
            t.column(id, primaryKey: true)
            t.column(name)
            t.column(imageUrl)
            t.column(quantity)
            t.column(company)
            t.column(addedDate)
            t.column(groupId)
            
        })
        
        let productsResult = products.filter(groupId == "kkk")
        return productsResult
        
    }
    func createGroupsTable()throws-> Table{
        let db = try Connection("db/db.sqlite3")
        let groups = Table("groups")
        let id = Expression<String>("id")
        let name = Expression<String?>("name")
        let imageUrl = Expression<String>("imageUrl")

        
        try db.run(groups.create(ifNotExists: true) { t in
            t.column(id, primaryKey: true)
            t.column(name)
            t.column(imageUrl)
            
        })
        
        return groups
        
    }
    func createUserGroupsTable()throws-> Table{
        let db = try Connection("db/db.sqlite3")
        let userGroups = Table("user_groups")
        let userId = Expression<String>("userId")
        let groupId = Expression<String?>("groupId")
        
        
        try db.run(userGroups.create(ifNotExists: true) { t in
            t.column(userId)
            t.column(groupId)
            
        })
        
        return userGroups
        
    }
    func createUsersTable()throws-> Table{
        let db = try Connection("db/db.sqlite3")
        let users = Table("users")
        let id = Expression<String>("id")
        let name = Expression<String?>("name")
        let email = Expression<String>("email")
        
        
        try db.run(users.create(ifNotExists: true) { t in
            t.column(id, primaryKey: true)
            t.column(name)
            t.column(email)
            
        })
        
        return users
        
    }
    

}
