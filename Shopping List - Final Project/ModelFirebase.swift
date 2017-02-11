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
import FirebaseStorage
import FirebaseAuth

class ModelFirebase{
    init(){
        // FIRApp.configure()
    }
    
    func toFirebase(object:AnyObject) -> Dictionary<String,Any> {
        var json = Dictionary<String,Any>()
        let mirror = Mirror(reflecting: object)
        for(index, attr) in mirror.children.enumerated(){
            
            json[attr.label!] = String(describing: attr.value)
        }
        return json
        
    }
    
    func addGroup(group:Group){
        print(group);
        let ref = FIRDatabase.database().reference().child("groups")
        let newNodeRef = ref.childByAutoId()
        let key = newNodeRef.key;
        newNodeRef.setValue(toFirebase(object: group) )
        let userId = (FIRAuth.auth()?.currentUser?.uid)!
        
        addUserToGroup(userId: userId, groupId: key)
    }
    
    func addUser(user:User){
        let ref = FIRDatabase.database().reference().child("users").child(user.userId)
        ref.setValue(toFirebase(object: user) )
    }
    
    func addProduct(product:Product, groupId:String){
        let ref = FIRDatabase.database().reference().child("products").child(groupId)
        ref.childByAutoId().setValue(toFirebase(object: product) )
    }
    
    func addUserToGroup(userId:String, groupId:String){
        var products = [Product]()
        let ref = FIRDatabase.database().reference().child("users").child(userId)
            .child("registeredGroups").child(groupId)
        ref.setValue(true)
    }
    
    func getProductsByGroupId(groupId:String, callback:@escaping ([Product])->Void){
        var products = [Product]()
        let ref = FIRDatabase.database().reference().child("users").child("products").child(groupId)
        let groupProductsRef = FIRDatabase.database().reference().child("products").child(groupId)
        
        groupProductsRef.observe(.childAdded, with: {(snapshot) in
            let productKey = snapshot.key;
            if let json = snapshot.value as? Dictionary<String,NSObject>{
                
                let product = Product.init(name: json["productName"]! as! String,
                                           company: json["productCompany"]! as! String,
                                           quantity: Int(json["productQuantity"]! as! String)!,
                                           addedByUserId: json["addedByUserId"]! as! String,
                                           addedDate: json["addedDate"]! as! String,
                                           productKey:productKey
                )
                products.append(product)
                callback(products)
            }
        },
        withCancel: {(snapshot) in
                                    //error/cancel
        })
        
        groupProductsRef.observe(FIRDataEventType.childChanged, with: {(snapshot) in
            if let json = snapshot.value as? Dictionary<String,NSObject>{
                
                let product = Product.init(name: json["productName"]! as! String,
                                           company: json["productCompany"]! as! String,
                                           quantity: Int(json["productQuantity"]! as! String)!,
                                           addedByUserId: json["addedByUserId"]! as! String,
                                           addedDate: json["addedDate"]! as! String,
                                           productKey:json["productKey"]! as! String
                )
                let index = products.index(where: { (a) -> Bool in
                    a.productKey == product.productKey
                })
                products[index!] = product
                callback(products)
            }
        })
        
        groupProductsRef.observe(FIRDataEventType.childRemoved, with: {(snapshot) in
            let key = snapshot.key
            let index = products.index(where: { (a) -> Bool in
                a.productKey == key
            })
            products.remove(at: index!)
            callback(products)
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
        let userGroupsRef = FIRDatabase.database().reference().child("users").child(userId).child("registeredGroups")
        let refGroups = FIRDatabase.database().reference().child("groups")
        
        
        userGroupsRef.observe(FIRDataEventType.value, with: {(snapshot) in
            //check if there are no groups
        })
        
        
        userGroupsRef.observe(.childAdded, with: {(snapshot) in
            let groupKey = snapshot.key
            refGroups.child(groupKey).observe(.value, with: {(snapshotInner) in
                if let json = snapshotInner.value as? Dictionary<String,NSObject>{
                    let group = Group.init(mails: [String](), name: json["groupName"]! as! String, list: [Product](),groupId: snapshotInner.key)
                    groups.append(group)
                    callback(groups)
                }
            })
            
            
        },
        withCancel: {(snapshot) in
        //error/cancel
        })

    }
    
    func editProduct(product:Product, groupId:String){
        let ref = FIRDatabase.database().reference().child("products").child(groupId).child(product.productKey)
        ref.setValue(toFirebase(object: product) )
    }
    
    func removeProduct(product:Product, groupId:String){
        let ref = FIRDatabase.database().reference().child("products").child(groupId).child(product.productKey)
        ref.removeValue()
    }
    
    lazy var storageRef = FIRStorage.storage().reference(forURL: "gs://ios-shopping-list.appspot.com/")
    
    
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



