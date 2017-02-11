//
//  Model.swift
//  Shopping List - Final Project
//
//  Created by Mac on 28/01/2017.
//  Copyright © 2017 Gal Levy & Ben Mamia. All rights reserved.
//

import Foundation
import UIKit



class Model{
    static let instance = Model()
    
    //lazy private var modelSql:ModelSql? = ModelSql()
    lazy private var modelFirebase:ModelFirebase? = ModelFirebase()
    
    private init(){
    }
    
    func addGroup(group:Group){
        modelFirebase?.addGroup(group: group)
       // st.addStudent(database: modelSql?.database)
    }
    func addUser(user:User){
        modelFirebase?.addUser(user: user)
        // st.addStudent(database: modelSql?.database)
    }
    func addProduct(product:Product, groupId:String){
        modelFirebase?.addProduct(product: product, groupId: groupId)
        // st.addStudent(database: modelSql?.database)
    }
    func addUserToGroup(userId:String, groupId:String){
      modelFirebase?.addUserToGroup(userId: userId, groupId: groupId)
        // st.addStudent(database: modelSql?.database)
    }
    func getProductsByGroupId(groupId:String, callback:@escaping ([Product])->Void){
        modelFirebase?.getProductsByGroupId(groupId: groupId, callback: callback)        // st.addStudent(database: modelSql?.database)
    }
    func getGroupsByUserId(userId:String, callback:@escaping ([Group])->Void){
        modelFirebase?.getGroupsByUserId(userId: userId, callback: callback)
    }
    
    func removeProduct(product:Product, groupId:String){
        modelFirebase?.removeProduct(product: product, groupId: groupId)
    }
    
    func editProduct(product:Product, groupId:String){
        modelFirebase?.editProduct(product: product, groupId: groupId)
    }

    func saveImage(image:UIImage, name:String, callback:@escaping (String?)->Void){
        //2. save image localy
        self.saveImageToFile(image: image, name: name)
        
        //1. save image to Firebase
        modelFirebase?.saveImageToFirebase(image: image, name: name, callback: {(url) in
            if (url != nil){
                //2. save image localy
                self.saveImageToFile(image: image, name: name)
            }
            //3. notify the user on complete
            callback(url)
        })
    }
    
    func getImage(urlStr:String, callback:@escaping (UIImage?)->Void){
        //1. try to get the image from local store
        let url = URL(string: urlStr)
        let localImageName = url!.lastPathComponent
        if let image = self.getImageFromFile(name: localImageName){
            callback(image)
        }else{
            //2. get the image from Firebase
            modelFirebase?.getImageFromFirebase(url: urlStr, callback: { (image) in
                if (image != nil){
                    //3. save the image localy
                    self.saveImageToFile(image: image!, name: localImageName)
                }
                //4. return the image to the user
                callback(image)
            })
        }
    }
    
    
    private func saveImageToFile(image:UIImage, name:String){
        if let data = UIImageJPEGRepresentation(image, 0.8) {
            let filename = getDocumentsDirectory().appendingPathComponent(name)
            try? data.write(to: filename)
        }
    }
    private func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in:
            .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
    
    private func getImageFromFile(name:String)->UIImage?{
        let filename = getDocumentsDirectory().appendingPathComponent(name)
        return UIImage(contentsOfFile:filename.path)
    }
    
}
