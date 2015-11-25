//
//  cardTableViewController.swift
//  StudyIt
//
//  Created by Michelle Emamdie on 11/4/15.
//  Copyright © 2015 Isabel Laurenceau. All rights reserved.
//

import UIKit
import Parse

var cards = [PFObject]()
class cardTableViewController: UIViewController, UITableViewDelegate {
    var arr:[String] = []
    var selectedSet = ""
    @IBOutlet var table: UITableView!
    //var selectedCard = PFObject()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        downloadCards()
        table.reloadData()
        // Do any additional setup after loading the view.
    }
    @IBAction func shuffle() {
        downloadCards()
        shuffleInPlace()
        table.reloadData()
        self.performSegueWithIdentifier("shuffled", sender: nil)
    }
    func shuffleInPlace() {
        // empty and single-element collections don't shuffle
        if cards.count < 2 { return }
        
        for i in 0..<cards.count - 1 {
            let j = Int(arc4random_uniform(UInt32(cards.count - i))) + i
            guard i != j else { continue }
            swap(&cards[i], &cards[j])
        }
    }
    
    @IBAction func newCard(sender: AnyObject) {
        let alertControl: UIAlertController = UIAlertController(title: "Start by naming your card", message: "", preferredStyle: .Alert)
        let ok = UIAlertAction(title: "OK", style: .Cancel) { action -> Void in
            let titlename = alertControl.textFields![0] as UITextField
            let cardName = titlename.text!
            if cardName != "" {
                //save title to parse
                let FriendName = PFObject(className: "CardInfo")
                FriendName.setObject(cardName, forKey: "title")
                
                FriendName.saveInBackgroundWithBlock {
                    (success: Bool, error:NSError?) -> Void in
                    
                    if(success) {
                        //We saved our information
                        print("Saved card Title")
                    }
                    else
                    {
                        //there was a problem
                        print((error?.description)! + "\n")
                        print("Error: Did Not Save Title")
                    }
                }
            }
            
            
        }
        alertControl.addAction(ok)
        alertControl.addTextFieldWithConfigurationHandler { (textField) in
            textField.placeholder = "Card Title"
        }
        
        
        self.presentViewController(alertControl, animated: true, completion: nil)
        performSegueWithIdentifier("newCardFromSet", sender: nil)
        downloadCards()
    }
   
   
    
    
    
    func downloadCards() {
        let query = PFQuery(className: "CardInfo")
        query.whereKey("setName", equalTo: selectedSet)
        do {
            //this will return all the cards in the set
            cards = try query.findObjects()
        }
        catch{}
    }
    
    func deleteCard(cardObj: PFObject) {
//       let location =  cards.indexOf(cardObj)
        cardObj.deleteInBackground()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cards.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) ->UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "Cell")
        cell.textLabel!.text = cards[indexPath.row]["title"] as? String
        return cell
    }
    
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        
        let delete = UITableViewRowAction(style: .Normal, title: "Delete") { action, index in
            print("delete button tapped")
            self.deleteCard(cards[indexPath.row])
        }
        delete.backgroundColor = UIColor.redColor()
        //            return [delete]
        //        }
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
        //selectedCard = cards[indexPath.row]
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "shuffled"   {
            let fvc = segue.destinationViewController as! FrontViewController
            fvc.displayShuffle()
        }
    }
}
