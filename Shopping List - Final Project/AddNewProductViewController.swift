//
//  AddNewProductViewController.swift
//  Shopping List - Final Project
//
//  Created by admin on 13/01/2017.
//  Copyright © 2017 Gal Levy & Ben Mamia. All rights reserved.
//

import UIKit

class AddNewProductViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBOutlet weak var productNameTextField: UITextField!
    @IBOutlet weak var productQuantityTextField: UITextField!
    @IBOutlet weak var productCompanyTextField: UITextField!
    
    @IBOutlet weak var cameraButton: UIButton!
    
    @IBOutlet weak var addButton: UIButton!
    
    var productImage:UIImage = #imageLiteral(resourceName: "defaultProductImage")
    
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
        //performSegue(withIdentifier: "addNewProductSegue", sender: nil)
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor(patternImage: #imageLiteral(resourceName: "wallpaper"))
        
        self.productNameTextField.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: .editingChanged)
        self.productCompanyTextField.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: .editingChanged)
        self.productQuantityTextField.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: .editingChanged)
    }
    
    // Called when the group name text changes
    func textFieldDidChange(textField:UITextField){
        // SET to false
        self.addButton.isEnabled = false
        
        // IF not empty - enable
        if (self.productNameTextField.text! != "" && self.productCompanyTextField.text! != "" && self.checkIfNumber(num: self.productQuantityTextField.text!)){
            self.addButton.isEnabled = true
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
