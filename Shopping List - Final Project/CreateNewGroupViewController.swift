//
//  CreateNewGroupViewController.swift
//  Shopping List - Final Project
//
//  Created by admin on 13/01/2017.
//  Copyright © 2017 Gal Levy & Ben Mamia. All rights reserved.
//

import UIKit

class CreateNewGroupViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{

    @IBOutlet weak var invitedEmailTableView: UITableView!
    
    @IBOutlet weak var particEmailTextField: UITextField!
    
    @IBOutlet weak var groupNameTextField: UITextField!
    
    var emailsList:[String] = []
    
    @IBAction func addParticClicked(_ sender: UIButton) {
        //invitedEmailTableView.insertRows(at: [0], with: UITableViewRowAnimation.fade)
        emailsList.append(particEmailTextField.text!)
        particEmailTextField.text = ""

        // Refresh the tableview
        self.invitedEmailTableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
