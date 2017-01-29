//
//  LoginViewController.swift
//  Shopping List - Final Project
//
//  Created by admin on 13/01/2017.
//  Copyright © 2017 Gal Levy & Ben Mamia. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let user :FIRUser? = FIRAuth.auth()?.currentUser
        
        
        if (user != nil) {
            print(user!.email!)

           // self.performSegue(withIdentifier: "presentLoggedInSegue", sender: self)
        } 
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func onLogin(_ sender: Any) {
        FIRAuth.auth()?.signIn(withEmail: self.emailTextField.text!, password: self.passTextField.text!) { (user, error) in
            //redirect user to main view (My Groups)
            
            if (user != nil) {
                print(user!.email!)
                self.performSegue(withIdentifier: "presentLoggedInSegue", sender: self)
            } else{
                print(error?.localizedDescription)
                //show credentials wrong alert
            }
        }
        
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
