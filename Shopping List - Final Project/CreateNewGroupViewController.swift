//
//  CreateNewGroupViewController.swift
//  Shopping List - Final Project
//
//  Created by admin on 13/01/2017.
//  Copyright © 2017 Gal Levy & Ben Mamia. All rights reserved.
//

import UIKit

class CreateNewGroupViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{

    @IBOutlet weak var createButton: UIButton!
    
    @IBOutlet weak var groupNameTextField: UITextField!
    
    @IBOutlet weak var cameraButton: UIButton!
    
    var emailsList:[String] = []
    
    var groupImage:UIImage = #imageLiteral(resourceName: "defaultGroupImage")
    
    var groupImageUrl:String = ""
    
    @IBAction func createButtonClicked(_ sender: UIButton) {
        // Saves the image to the FireBase & locally
        Model.instance.saveImage(image: self.groupImage, name: self.groupNameTextField.text!, callback: {
            (str) in
            self.groupImageUrl = str!
            self.performSegue(withIdentifier: "unwindSegueCreateGroup", sender: self)
        })
    }
    
    
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
        self.groupImage = (info.values.first as! UIImage?)!
        self.dismiss(animated: true, completion: nil);
        
        // Set the chosen image as the background
        self.cameraButton.setBackgroundImage(self.groupImage, for: UIControlState.normal)
        //performSegue(withIdentifier: "addNewProductSegue", sender: nil)
        
    }
    
    // Called when the group name text changes
    func groupNameDidChange(textField:UITextField){
        // SET to false
        self.createButton.isEnabled = false
        
        // IF not empty - enable
        if (self.groupNameTextField.text! != ""){
            self.createButton.isEnabled = true
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor(patternImage: #imageLiteral(resourceName: "wallpaper"))
        
        self.groupNameTextField.addTarget(self, action: #selector(groupNameDidChange(textField:)), for: .editingChanged)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Saves the image to the FireBase & locally
        Model.instance.saveImage(image: self.groupImage, name: self.groupNameTextField.text!, callback: {
            (str) in
            self.groupImageUrl = str!
            print(str!)
            print(str!)
            print(self.groupImageUrl)
            print("asdasdasd")
            })
        //Model.instance.saveImage(image: groupImage, name: self.groupImageString)
        //Model..saveImageToFile(image: groupImage, name: self.groupImageString)
    }*/
    

}
