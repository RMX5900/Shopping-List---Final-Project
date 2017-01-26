//
//  GroupsTableViewController.swift
//  Shopping List - Final Project
//
//  Created by admin on 13/01/2017.
//  Copyright © 2017 Gal Levy & Ben Mamia. All rights reserved.
//

import UIKit

class GroupsTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var isOnEditMode:Bool = false
    
    var groupList:[Group] = []
    @IBOutlet weak var groupsTableView: UITableView!
    @IBOutlet weak var editBarButton: UIBarButtonItem!
    
    @IBAction func onEditGroupListClick(_ sender: UIBarButtonItem) {
        // If is not on edit mode
        if (!self.isOnEditMode){
            self.isOnEditMode = true
            self.editBarButton.title = "Done"
            self.groupsTableView.setEditing(true, animated: true)
        }
        else{
            self.isOnEditMode = false
            self.editBarButton.title = "Edit"
            self.groupsTableView.setEditing(false, animated: true)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.groupsTableView.backgroundView = UIImageView(image: #imageLiteral(resourceName: "greyBackgroundImage"))

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.groupList.count
    }

    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "groupCell", for: indexPath)
        
        let groupCell = cell as! GroupTableViewCell
        groupCell.groupNameLabel.text = self.groupList[indexPath.row].groupName
        groupCell.groupImageView.image = self.groupList[indexPath.row].groupImage
        var mailUsersStringed:String = ""
        
        
        for mail in self.groupList[indexPath.row].mailList {
            if (mailUsersStringed != ""){
                mailUsersStringed += ", "
            }
            mailUsersStringed += mail.components(separatedBy: "@")[0]
        }
        
        groupCell.mailsListLabel.text = mailUsersStringed

        return groupCell
    }
    
    var selectedIndex:Int?
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        
        // Set the selected index
        self.selectedIndex = indexPath.row
        
        // Perform segue to the student details window
        self.performSegue(withIdentifier: "presentShoppingListSegue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let shopListVc = segue.destination as? ShoppingListTableViewController{
            
            // Pass the group   
            shopListVc.group = self.groupList[self.selectedIndex!]
            
            // Pass the student details
            shopListVc.shoppingList = self.groupList[self.selectedIndex!].shoppingList
        }
    }
    
    public func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath){
        // Delete the student from the list
        self.groupList.remove(at: indexPath.row)
        
        // Remove the student row from the tableview
        self.groupsTableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.fade)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    // The unwind segue from new product
    @IBAction func unwindToGroupsTableViewController(segue: UIStoryboardSegue){
        if let newGroupVc = segue.source as? CreateNewGroupViewController{
            
            if (segue.identifier! == "unwindSegueCreateGroup"){
                // Create a new group and add it
                self.groupList.append(Group(mails: newGroupVc.emailsList, name: newGroupVc.groupNameTextField.text!,list:[], image: newGroupVc.groupImage))

                // Refresh the tableview
                self.groupsTableView.reloadData()
            }
        }
        else if let joinGroupVc = segue.source as? JoinGroupViewController{
            // TODO:
            // Add the exiting group code
        }
    }

}
