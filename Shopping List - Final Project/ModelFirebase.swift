//
//  ModelFirebase.swift
//  Shopping List - Final Project
//
//  Created by Mac on 28/01/2017.
//  Copyright © 2017 Gal Levy & Ben Mamia. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase


class ModelFirebase{
    init(){
        // FIRApp.configure()
    }
    
    func toFirebase(object:AnyObject) -> Dictionary<String,String> {
        var json = Dictionary<String,String>()
        let mirror = Mirror(reflecting: object)
        for(index, attr) in mirror.children.enumerated(){
            
            json[attr.label!] = attr.value as? String
        }
        return json
        
        /*
         json["id"] = id
         json["name"] = name
         if (imageUrl != nil){
         json["imageUrl"] = imageUrl!
         }
         return json*/
    }
    
    func addGroup(group:Group){
        print(group);
        let ref = FIRDatabase.database().reference().child("groups")
        ref.childByAutoId().setValue(toFirebase(object: group) )
    }
    
    func addUser(user:User){
        let ref = FIRDatabase.database().reference().child("users").child(user.userId)
        ref.setValue(toFirebase(object: user) )
    }
    
    func addProduct(product:Product, groupId:String){
        let ref = FIRDatabase.database().reference().child("groups").child(groupId).child("products")
        ref.childByAutoId().setValue(toFirebase(object: product) )
    }
    
    func addUserToGroup(userId:String, groupId:String){
        let ref = FIRDatabase.database().reference().child("users").child(userId).child("registeredGroups").child(groupId)
        ref.setValue(true)
    }
    
    func getProductsByGroupId(groupId:String, callback:@escaping ([Product])->Void){
        let ref = FIRDatabase.database().reference().child("users").child("products").child(groupId)
        ref.observeSingleEvent(of: .value, with: {(snapshot) in
            var products = [Product]()
            for child in snapshot.children.allObjects{
                if let childData = child as? FIRDataSnapshot{
                    let value = childData.value as? NSDictionary
                    let product = Product.init(name: value?["name"] as? String ?? "",
                                               company: value?["company"] as? String ?? "",
                                               quantity: value?["quantity"] as? Int ?? 0, image: nil, addedByUserId:value?["addedByUserId"] as? String ?? "", addedDate: value?["addedDate"] as? String ?? ""
                    )
                    //set product id here - Ben
                    self.getUserById(userId: product.addedByUserId, callback: { (user) in
                        product.addedByUser = user
                        products.append(product)
                        if(products.count == Int(snapshot.childrenCount)){
                            callback(products)
                        }
                    })
                    
                    
                }
            }
            
        })
    }
    
    private func getUserById(userId:String, callback:@escaping (User)->Void){
        let ref = FIRDatabase.database().reference().child("users").child(userId)
        ref.observeSingleEvent(of: .value, with: {(snapshot) in
            let value = snapshot.value as? NSDictionary
            let user = User.init(userId: userId,
                                 firstName: value?["firstName"] as? String ?? "",
                                 lastName: value?["lastName"] as? String ?? "",
                                 email: value?["email"] as? String ?? "")
            callback(user)
            
        })
    }
    
    func getGroupsByUserId(userId:String, callback:@escaping ([Group])->Void){
        var groups = [Group]()
        var groupIds = [String]()
        let ref = FIRDatabase.database().reference().child("users").child(userId).child("registeredGroups")
        let refGroups = FIRDatabase.database().reference().child("groups")
        
        
        print(ref)
        
        ref.queryOrderedByKey().observeSingleEvent(of: .value, with: {(snapshot) in
            //let json = snapshot.value as? Dictionary<String,String>
            for child in snapshot.children.allObjects{
                if let childData = child as? FIRDataSnapshot{
                    groupIds.append(childData.key)
                }
            }
            if(groupIds.count == 0){
                callback(groups)
                return
            }
            refGroups.queryOrderedByKey().queryStarting(atValue: groupIds[0]).queryEnding(atValue: groupIds[groupIds.count-1]).observeSingleEvent(of: .value, with: {(snapshot) in
                for child in snapshot.children.allObjects{
                    if let childData = child as? FIRDataSnapshot{
                        print(childData)
                        if let json = childData.value as? Dictionary<String,NSObject>{
                            let group = Group.init(mails: [String](), name: json["groupName"]! as! String, list: [Product](),groupId: childData.key)
                            //get here group products - Ben
                            print(json)
                            let productsSnapshot = childData.childSnapshot(forPath: "products")
                            for productSnapshot in productsSnapshot.children.allObjects {
                                let product  = productSnapshot as? FIRDataSnapshot
                                let productJson = product?.value as? Dictionary<String,String>
                                let productObj = Product.init(
                                                              name: ((productJson? ["productName"])! as? String)!,
                                                              company: ((productJson?["productCompany"])! as? String)!,
                                                              quantity: 4/*productJson?["quantity"]! as! Int!*/,
                                                              image: nil,
                                                              addedByUserId: productJson?["addedByUserId"]! as! String!,
                                                              addedDate: productJson?["addedDate"]! as! String!)
                                self.getUserById(userId: productObj.addedByUserId, callback: { (user) in
                                    productObj.addedByUser = user
                                    group.shoppingList.append(productObj)
                                    if(group.shoppingList.count == Int(productsSnapshot.childrenCount)){
                                        callback(groups)
                                    }
                                })
                                
                                print(productJson)
                            }
                            groups.append(group)
                            callback(groups)
                        }
                    }
                }
                
            })
            
            // callback(st)
        })
        
    }
    
    lazy var storageRef = FIRStorage.storage().reference(forURL: "gs://ios-shopping-list.appspot.com/")
    
    
    //lazy var storageRef = FIRStorage.storage().reference(forURL:
        //"gs://sssss-41596.appspot.com/")
    
    func saveImageToFirebase(image:UIImage, name:(String), callback:@escaping (String?)->Void){
        let filesRef = storageRef.child(name)
        print("-------------")
        print("-------------")
        print("-------------")
        if let data = UIImageJPEGRepresentation(image, 0.8) {
            filesRef.put(data, metadata: nil) { metadata, error in
                print("----asd-----")
                print("-------------")
                print("----asd-------")
                if (error != nil) {
                    callback("mshoo")
                    print("-------------")
                    print("-------------")
                    print("-------------")
                } else {
                    let downloadURL = metadata!.downloadURL()
                    print("-------------")
                    print("-------------")
                    print("-------------")
                    print(downloadURL)
                    print("-------------")
                    print("-------------")
                    print("-------------")
                    callback(downloadURL?.absoluteString)
                }
            }
        }
    }
    
    func getImageFromFirebase(url:String, callback:@escaping (UIImage?)->Void){
        let ref = FIRStorage.storage().reference(forURL: url)
        ref.data(withMaxSize: 10000000, completion: {(data, error) in
            if (error == nil && data != nil){
                let image = UIImage(data: data!)
                callback(image)
            }else{
                callback(nil)
            }
        })
    }
    
}
/*
 
 func getAllStudents(callback:@escaping ([Student])->Void){
 let ref = FIRDatabase.database().reference().child("students")
 ref.observeSingleEvent(of: .value, with: {(snapshot) in
 var students = [Student]()
 for child in snapshot.children.allObjects{
 if let childData = child as? FIRDataSnapshot{
 if let json = childData.value as? Dictionary<String,String>{
 let st = Student(json: json)
 students.append(st)
 }
 }
 }
 callback(students)
 })
 }*/


