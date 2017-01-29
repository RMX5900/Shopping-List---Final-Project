//
//  EditProductViewController.swift
//  Shopping List - Final Project
//
//  Created by admin on 20/01/2017.
//  Copyright © 2017 Gal Levy & Ben Mamia. All rights reserved.
//

import UIKit

class EditProductViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var productNameTextField: UITextField!
    
    @IBOutlet weak var companyTextField: UITextField!
    
    @IBOutlet weak var quantityTextField: UITextField!
    
    @IBOutlet weak var saveButton: UIButton!
    
    @IBOutlet weak var cameraButton: UIButton!
    
    var product:Product = Product(name: "", company: "", quantity: 0, image: nil,addedByUserId:"", addedDate:"")
    
    var productImage:UIImage?
    
    @IBAction func cameraButtonClicked(_ sender: UIButton) {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary;
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]){
        self.productImage = (info.values.first as! UIImage?)!
        self.dismiss(animated: true, completion: nil);
        
        // Set the chosen image as the background
        self.cameraButton.setBackgroundImage(self.productImage, for: UIControlState.normal)
    }
    
    @IBOutlet weak var imageButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.productNameTextField.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: .editingChanged)
        self.companyTextField.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: .editingChanged)
        self.quantityTextField.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: .editingChanged)
        
        // Set the values t the text fields
        self.productNameTextField.text = product.productName
        self.companyTextField.text = product.productCompany
        self.quantityTextField.text = String(product.productQuantity)
        
        // Set the chosen image as the background
        self.cameraButton.setBackgroundImage(product.productImage, for: UIControlState.normal)
        
        self.productImage = product.productImage

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Called when the group name text changes
    func textFieldDidChange(textField:UITextField){
        // SET to false
        self.saveButton.isEnabled = false
        
        // IF not empty - enable
        if (self.productNameTextField.text! != "" && self.companyTextField.text! != "" && self.checkIfNumber(num: self.quantityTextField.text!)){
            self.saveButton.isEnabled = true
        }
    }
    
    // Check if the string is a number
    func checkIfNumber (num:String) -> Bool{
        //let number = Int(num)
        if Int(num) != nil{
            return true
        }
        return false
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Update the product
        self.product = Product(name: productNameTextField.text!, company: companyTextField.text!, quantity: Int(quantityTextField.text!)!, image: productImage, addedByUserId: "pre", addedDate: "preDate")
    }
    

}
