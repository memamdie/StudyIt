//
//  setViewController.swift
//  StudyIt
//
//  Created by Michelle Emamdie on 11/4/15.
//  Copyright © 2015 Isabel Laurenceau. All rights reserved.
//

import UIKit
import Parse

class setViewController: UIViewController, UITableViewDelegate {
    var sets = [String]()
    var setName: String!
    var selectedSet = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        downloadSets()
        // Do any additional setup after loading the view.
    }
    @IBAction func newSet(sender: AnyObject) {
        let alertControl: UIAlertController = UIAlertController(title: "Start by naming your set", message: "", preferredStyle: .Alert)
        let ok = UIAlertAction(title: "OK", style: .Cancel) { action -> Void in
            let titlename = alertControl.textFields![0] as UITextField
            self.setName = titlename.text!
            if self.setName != "" {
                self.performSegueWithIdentifier("toCard", sender: nil)
            }
        }
        alertControl.addAction(ok)
        alertControl.addTextFieldWithConfigurationHandler { (textField) in
            textField.placeholder = "Set Title"
        }
        
        self.presentViewController(alertControl, animated: true, completion: nil)
        
    }
    func downloadSets() {
        let query = PFQuery(className:"CardInfo")
        query.whereKey("username", equalTo: (PFUser.currentUser()!.username)!)
        //query.whereKey("setName", notEqualTo: "")
        print((PFUser.currentUser()!.username)!)
        do {
            let result = try query.findObjects()
            for set in result {
                setName? = set["setName"] as! String
                //print(setName)
                if set["setName"] != nil  && !(sets.contains(set["setName"] as! String)){
                    sets.append(set["setName"] as! String)
                }
            }
        }
        catch{}
    }
    func deleteSet(setName: String) {
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sets.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) ->UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "cell")
        cell.textLabel!.text = sets[indexPath.row]
        return cell
    }
    
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        
        let delete = UITableViewRowAction(style: .Normal, title: "Delete") { action, index in
            print("delete button tapped")
            self.deleteSet(self.sets[indexPath.row])
        }
        delete.backgroundColor = UIColor.redColor()

        return [delete]
    }
    
    func tableView(tableView: UITableView, didEndEditingRowAtIndexPath indexPath: NSIndexPath) {
        //dismissViewControllerAnimated(true, completion: nil)
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // the cells you would like the actions to appear needs to be editable
        return true
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        selectedSet = sets[indexPath.row]
        performSegueWithIdentifier("toSpecifiedSet", sender: nil)
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "toCard" {
            print("Segueing to the card screen")
             let card = segue.destinationViewController as! FrontViewController
            card.setName = setName
        }
        else if segue.identifier == "toSpecifiedSet" {
            let fvc = segue.destinationViewController as! cardTableViewController
            fvc.selectedSet = selectedSet
        }
    }
}
