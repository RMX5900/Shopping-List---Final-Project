//
//  GroupsTableViewController.swift
//  Shopping List - Final Project
//
//  Created by admin on 13/01/2017.
//  Copyright © 2017 Gal Levy & Ben Mamia. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage

class GroupsTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    let storage = FIRStorage.storage()
    
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
        self.navigationItem.hidesBackButton = true;
        
        Model.instance.getGroupsByUserId(userId: (FIRAuth.auth()?.currentUser!.uid)!, callback: { (groups) in
            self.groupList = groups
            self.groupsTableView.backgroundView = UIImageView(image: #imageLiteral(resourceName: "wallpaper"))
            self.groupsTableView.reloadData()
        })
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
        groupCell.acitivityIndicatorView.startAnimating()
        groupCell.groupNameLabel.text = self.groupList[indexPath.row].groupName
        //groupCell.groupImageView.image = self.groupList[indexPath.row].groupImage
        
        // Get the cached image group
        let imUrl = self.groupList[indexPath.row].imageUrl
        Model.instance.getImage(urlStr: imUrl, callback:
                {
                    (image) in groupCell.groupImageView!.image = image
                    groupCell.acitivityIndicatorView.stopAnimating()
                    
        })
        
        
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
        
        // Perform segue to the shopping list details window
        self.performSegue(withIdentifier: "presentShoppingListSegue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let shopListVc = segue.destination as? ShoppingListTableViewController{
            
            // Pass the group
            shopListVc.group = self.groupList[self.selectedIndex!]
            
            // Pass the group details
            shopListVc.shoppingList = self.groupList[self.selectedIndex!].shoppingList
        }
    }
    
    public func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath){
        Model.instance.removeGroup(userId: (FIRAuth.auth()?.currentUser?.uid)!,
                                   groupId: self.groupList[indexPath.row].groupId)
        
        /*
        // Delete the group from the list
        self.groupList.remove(at: indexPath.row)
        
        // Remove the student row from the tableview
        self.groupsTableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.fade)
 */
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
                self.groupList.append(Group(mails: [], name: newGroupVc.groupNameTextField.text!,list:[], groupId:"", img: newGroupVc.groupImageUrl))
                Model.instance.addGroup(group: Group(mails: [], name: newGroupVc.groupNameTextField.text!,list:[], groupId:"", img: newGroupVc.groupImageUrl))
                
        
                // Refresh the tableview
                self.groupsTableView.reloadData()
            }
        }
    }
    
}
