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
    
    @IBOutlet weak var loginButton: UIButton!
    
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor(patternImage: #imageLiteral(resourceName: "wallpaper"))
        
        let user :FIRUser? = FIRAuth.auth()?.currentUser
        
        
        if (user != nil) {
            print(user!.email!)

           // self.performSegue(withIdentifier: "presentLoggedInSegue", sender: self)
        }
        
        self.emailTextField.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: .editingChanged)
        
        self.passTextField.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: .editingChanged)
        
        // Do any additional setup after loading the view.
    }
    
    // Called when the group name text changes
    func textFieldDidChange(textField:UITextField){
        // SET to false
        self.loginButton.isEnabled = false
        
        // IF not empty && mail valid - enable
        if (self.emailTextField.text! != "" &&
            self.passTextField.text! != "" &&
            self.isMailValid(mail: self.emailTextField.text!)){
            self.loginButton.isEnabled = true
        }
    }
    
    // Called when the mail text changes
    func isMailValid(mail:String)->Bool{
        // Set the regEx Params
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        
        return emailTest.evaluate(with: mail)
    }
    
    // Alert the user when error occured
    func alertMessage(strAlert:String){
        let alert = UIAlertController(title: "Alert", message: strAlert, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func onLogin(_ sender: Any) {
        self.activityIndicatorView.startAnimating()
        
        FIRAuth.auth()?.signIn(withEmail: self.emailTextField.text!, password: self.passTextField.text!) { (user, error) in
            //redirect user to main view (My Groups)
            
            self.activityIndicatorView.stopAnimating()
            if (user != nil) {
                self.performSegue(withIdentifier: "presentLoggedInSegue", sender: self)
            } else{
                self.alertMessage(strAlert: (error?.localizedDescription)!)
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
