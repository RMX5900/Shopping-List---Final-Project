//
//  CreateNewGroupViewController.swift
//  Shopping List - Final Project
//
//  Created by admin on 13/01/2017.
//  Copyright © 2017 Gal Levy & Ben Mamia. All rights reserved.
//

import UIKit

class CreateNewGroupViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{

    @IBOutlet weak var createButton: UIButton!
    
    @IBOutlet weak var invitedEmailTableView: UITableView!
    
    @IBOutlet weak var particEmailTextField: UITextField!
    
    @IBOutlet weak var groupNameTextField: UITextField!
    
    @IBOutlet weak var addMailButton: UIButton!
    
    var emailsList:[String] = []
    
    @IBAction func addParticClicked(_ sender: UIButton) {
        
        // Add the email to the list
        emailsList.append(particEmailTextField.text!)
        
        // Erase the text field after adding the mail
        particEmailTextField.text = ""

        // Refresh the tableview
        self.invitedEmailTableView.reloadData()
    }
    
    // Called when the mail text changes
    func mailTextFieldDidChange(textField:UITextField){
        // Set the regEx Params
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        
        // Check if the mail is valid
        if (emailTest.evaluate(with: particEmailTextField.text!)){
            self.addMailButton.isEnabled = true
        }
        else{
            self.addMailButton.isEnabled = false
        }
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
        
        self.particEmailTextField.addTarget(self, action: #selector(mailTextFieldDidChange(textField:)), for: .editingChanged)
        
        self.groupNameTextField.addTarget(self, action: #selector(groupNameDidChange(textField:)), for: .editingChanged)

        // Enables editing
        self.invitedEmailTableView.setEditing(true, animated: true)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return emailsList.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        // Sets the mails in the table
        let rowCell = self.invitedEmailTableView.dequeueReusableCell(withIdentifier: "mailCell", for: indexPath)
        
        let mailCell = rowCell as! MailTableViewCell
        mailCell.mailLabel.text = self.emailsList[indexPath.row]
        
        return mailCell
    }
    
    public func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath){
        // Delete the student from the list
        self.emailsList.remove(at: indexPath.row)
        
        // Remove the student row from the tableview
        self.invitedEmailTableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.fade)
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
