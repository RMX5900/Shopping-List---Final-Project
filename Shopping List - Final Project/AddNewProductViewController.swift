//
//  AddNewProductViewController.swift
//  Shopping List - Final Project
//
//  Created by admin on 13/01/2017.
//  Copyright © 2017 Gal Levy & Ben Mamia. All rights reserved.
//

import UIKit

class AddNewProductViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBOutlet weak var productNameLabel: UITextField!
    @IBOutlet weak var productQuantityLabel: UITextField!
    @IBOutlet weak var productCompanyLabel: UITextField!
    
    @IBOutlet weak var cameraButton: UIButton!
    
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
        //performSegue(withIdentifier: "createStudentSegue", sender: nil)
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()

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
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
