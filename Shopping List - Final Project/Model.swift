//
//  Model.swift
//  Shopping List - Final Project
//
//  Created by Mac on 28/01/2017.
//  Copyright © 2017 Gal Levy & Ben Mamia. All rights reserved.
//

import Foundation



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

    
    /*
    func getStudentById(id:String, callback:@escaping (Student)->Void){
    }
    
    func getAllStudents(callback:@escaping ([Student])->Void){
        let students = Student.getAllStudents(database:modelSql?.database)
        callback(students)
    }*/
    
}
