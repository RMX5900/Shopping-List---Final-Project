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
    
    @IBOutlet weak var registerButton: UIButton!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor(patternImage: #imageLiteral(resourceName: "wallpaper"))
        
        self.nameTextField.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: .editingChanged)
        
        self.confirmPassTextField.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: .editingChanged)
        
        self.passTextField.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: .editingChanged)
        
        self.emailTextField.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: .editingChanged)

        // Do any additional setup after loading the view.
    }
    
    // Called when the group name text changes
    func textFieldDidChange(textField:UITextField){
        // SET to false
        self.registerButton.isEnabled = false
        
        // IF not empty && passwords match && mail valid - enable
        if (self.emailTextField.text! != "" &&
            self.passTextField.text! != "" &&
            self.nameTextField.text! != "" &&
            self.confirmPassTextField.text! != "" &&
            self.confirmPassTextField.text! == self.passTextField.text! &&
            self.isMailValid(mail: self.emailTextField.text!)){
            self.registerButton.isEnabled = true
        }
    }
    
    // Alert the user when error occured
    func alertMessage(strAlert:String){
        let alert = UIAlertController(title: "Alert", message: strAlert, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    // Called when the mail text changes
    func isMailValid(mail:String)->Bool{
        // Set the regEx Params
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        
        return emailTest.evaluate(with: mail)
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
        self.registerButton.isEnabled = false
    }
    
    @IBAction func onRegister(_ sender: Any) {
        FIRAuth.auth()?.createUser(withEmail: emailTextField.text!, password: passTextField.text! ) { (user, error) in
            if(error != nil)
            {
                let alertMsg:String = "Error signing out: " + (error?.localizedDescription)!
                self.alertMessage(strAlert: alertMsg)
                //print ("Error signing out: %@", error!)
            }
            
            if(user != nil){
                let alertMsg:String = "user created: " + (user?.displayName)!
                self.alertMessage(strAlert: alertMsg)
                //print ("user created: %@", user!)
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
