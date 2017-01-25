//
//  RegisterViewController.swift
//  Shopping List - Final Project
//
//  Created by admin on 13/01/2017.
//  Copyright © 2017 Gal Levy & Ben Mamia. All rights reserved.
//

import UIKit
import Firebase

class RegisterViewController: UIViewController {
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var confirmPassTextField: UITextField!
    @IBOutlet weak var passTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Clears all the fields
    @IBAction func clearFieldsClicked(_ sender: UIButton) {
        nameTextField.text = ""
        confirmPassTextField.text = ""
        passTextField.text = ""
        emailTextField.text = ""
    }
//    @IBAction func clearFieldsClicked2(_ sender: UIButton) {
//        let email = "dfdfd@dsds.com"
//        let pass = "123456"
//        FIRAuth.auth()?.createUser(withEmail: email, password: pass ) { (user, error) in
//print ("Error signing out: %@", error)
//            
//        }
//    }
    
    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
