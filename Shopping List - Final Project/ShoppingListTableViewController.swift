//
//  ShoppingListTableViewController.swift
//  Shopping List - Final Project
//
//  Created by admin on 13/01/2017.
//  Copyright © 2017 Gal Levy & Ben Mamia. All rights reserved.
//

import UIKit

class ShoppingListTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // Changing the edit mode accordingly
    @IBAction func onEditListClick(_ sender: UIBarButtonItem) {
        // If is not on edit mode
        /*if (!self.isOnEditMode){
            self.isOnEditMode = true
            self.editBarButton.image=#imageLiteral(resourceName: "finishEditIcon")
            self.StudentsTableView.setEditing(true, animated: true)
        }
        else{
            self.isOnEditMode = false
            self.editBarButton.image=#imageLiteral(resourceName: "editIcon")
            self.StudentsTableView.setEditing(false, animated: true)
        }*/
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        // Returs the number of students
        //return self.studentsList.count
        return 1
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        // Sets the students in the table
        //let rowCell = self.StudentsTableView.dequeueReusableCell(withIdentifier: "studentCell", for: indexPath)
        
        //let studentCell = rowCell as! StudentTableViewCell
        //studentCell.stFirstName.text = self.studentsList[indexPath.row].firstName
        //studentCell.stLastName.text = self.studentsList[indexPath.row].lastName
        
        return UITableViewCell()
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        
        // Set the selected index
        //selectedIndex = indexPath.row
        
        // Perform segue to the student details window
        //self.performSegue(withIdentifier: "presentSegueDetails", sender: self)

    }
    
    public func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath){
        // Delete the student from the list
        //self.studentsList.remove(at: indexPath.row)
        
        // Remove the student row from the tableview
        //self.StudentsTableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.fade)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //if let stDetailsVc = segue.destination as? StudentDetailsViewController{
            
            // Pass the student details
            //stDetailsVc.student = self.studentsList[self.selectedIndex!]
        //}
    }
    
    // The unwind segue from new product
    @IBAction func unwindToShoppingListTableViewController(segue: UIStoryboardSegue){
        if let newStudentVc = segue.source as? AddNewProductViewController{
            
            // Create a new student by the details
            //let newStud:Student = Student(fName: newStudentVc.firstNameText.text!, lName: newStudentVc.lastNameText.text!, stID: newStudentVc.studentIdText.text!, phoneNum: newStudentVc.phoneText.text!)
            
            // Add the student to the list
            //studentsList.append(newStud)
            
            // Refresh the tableview
            //StudentsTableView.reloadData()
        }
    }

}
