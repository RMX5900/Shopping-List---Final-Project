//
//  ShoppingListTableViewController.swift
//  Shopping List - Final Project
//
//  Created by admin on 13/01/2017.
//  Copyright © 2017 Gal Levy & Ben Mamia. All rights reserved.
//

import UIKit

class ShoppingListTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var selectedIndex:Int?
    
    var group:Group = Group(mails: [], name: "", list: [])
    
    var isOnEditMode:Bool = false
    
    var shoppingList:[Product] = []
    
    var currProduct:Product?
    
    @IBOutlet weak var navigationBar: UINavigationItem!

    @IBOutlet weak var productsTableView: UITableView!
    
    @IBOutlet weak var editBarButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationBar.title = group.groupName + " List"
        
        self.productsTableView.backgroundView = UIImageView(image: #imageLiteral(resourceName: "greyBackgroundImage"))

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // Changing the edit mode accordingly
    @IBAction func onEditListClick(_ sender: UIBarButtonItem) {
        if (!self.isOnEditMode){
            self.isOnEditMode = true
            self.editBarButton.title = "Done"
            self.productsTableView.setEditing(true, animated: true)
        }
        else{
            self.isOnEditMode = false
            self.editBarButton.title = "Edit"
            self.productsTableView.setEditing(false, animated: true)
        }
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        // Returs the number of students
        //return self.studentsList.count
        return shoppingList.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        // Sets the products in the table
        let rowCell = self.productsTableView.dequeueReusableCell(withIdentifier: "productCell", for: indexPath)
        
        let productCell = rowCell as! ProductTableViewCell
        productCell.productNameLabel.text = self.shoppingList[indexPath.row].productName
        productCell.productCompanyLabel.text = "by " + self.shoppingList[indexPath.row].productCompany
        productCell.productQuantityLabel.text = String(self.shoppingList[indexPath.row].productQuantity)
        productCell.productImageView.image = self.shoppingList[indexPath.row].productImage
        
        return productCell
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        
        // Set the selected index
        self.selectedIndex = indexPath.row
        
        if (isOnEditMode){
            
            currProduct = shoppingList[selectedIndex!]
        
            // Perform segue to the student details window
            self.performSegue(withIdentifier: "editProductSegue", sender: self)
        }

    }
    
    public func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath){
        // Delete the student from the list
        self.shoppingList.remove(at: indexPath.row)
        
        // Remove the student row from the tableview
        self.productsTableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.fade)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let editVc = segue.destination as? EditProductViewController{
            
            // Pass the product details
            editVc.product = currProduct!
        }
    }
    
    // The unwind segue from new product
    @IBAction func unwindToShoppingListTableViewController(segue: UIStoryboardSegue){
        if let newProductVc = segue.source as? AddNewProductViewController{
            if (segue.identifier == "addNewProductUnwindSegue"){
                // Create a new product by the details
                let newProduct:Product = Product(name: newProductVc.productNameTextField.text!, company: newProductVc.productCompanyTextField.text!,quantity:Int(newProductVc.productQuantityTextField.text!)!, image: newProductVc.productImage)
                
                // Adding the item to the list
                self.shoppingList.append(newProduct)
                
                // Upadte the group
                self.group.shoppingList = self.shoppingList
                
                // Refresh data
                self.productsTableView.reloadData()
            }
        }
        if let editProductVc = segue.source as? EditProductViewController{
            if (segue.identifier == "editProductUnwindSegue"){
                // Update the product
                self.shoppingList[selectedIndex!] = editProductVc.product
                
                // Upadte the group
                self.group.shoppingList = self.shoppingList
                
                // Refresh data
                self.productsTableView.reloadData()
            }
        }

        
            // Create a new student by the details
            //let newStud:Student = Student(fName: newStudentVc.firstNameText.text!, lName: newStudentVc.lastNameText.text!, stID: newStudentVc.studentIdText.text!, phoneNum: newStudentVc.phoneText.text!)
            
            // Add the student to the list
            //studentsList.append(newStud)
            
            // Refresh the tableview
            //StudentsTableView.reloadData()
        }
    }


