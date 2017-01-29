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
        
        self.view.backgroundColor = UIColor(patternImage: #imageLiteral(resourceName: "wallpaper"))

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
    
    @IBAction func onRegister(_ sender: Any) {
        FIRAuth.auth()?.createUser(withEmail: emailTextField.text!, password: passTextField.text! ) { (user, error) in
            if(error != nil){
                print ("Error signing out: %@", error!)
            }
            
            if(user != nil){
                print ("user created: %@", user!)
                let newUser = User.init(userId: (user?.uid)!, firstName: self.nameTextField.text!, lastName: "", email: self.emailTextField.text!)
                Model.instance.addUser(user: newUser)
                FIRAuth.auth()?.signIn(withEmail: self.emailTextField.text!, password: self.passTextField.text!) { (user, error) in
                    //redirect user to main view (My Groups)
                    
                    
                    self.performSegue(withIdentifier: "presentRegisteredInSegue", sender: self)
                }
            }
        }
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
