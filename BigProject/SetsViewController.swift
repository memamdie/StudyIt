//
//  SetsViewController.swift
//  StudyIt
//
//  Created by Isabel Laurenceau on 11/17/15.
//  Copyright © 2015 Isabel Laurenceau. All rights reserved.
//

import UIKit
import Parse

class SetsViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource{

    @IBOutlet var collection: UICollectionView!
    var currentUser = PFUser.currentUser()
    var cards = [PFObject]()
    var widthsize = ((UIScreen.mainScreen().bounds.width) - 32 - 30 ) / 4
    var sets = [String]()
    var setName: String!
    var selectedSet = ""
    var deletes = false
    override func viewDidLoad() {
        super.viewDidLoad()
        downloadData()
        collection.delegate = self
        // Resize size of collection view items in grid so that we achieve 3 boxes across
        let cellWidth = ((UIScreen.mainScreen().bounds.width) - 32 - 30 ) / 4
        let cellLayout = collection.collectionViewLayout as! UICollectionViewFlowLayout
        cellLayout.itemSize = CGSize(width: cellWidth, height: cellWidth)
        
        
        let swipeLEFT = UISwipeGestureRecognizer(target: self, action: "swiped:")
        swipeLEFT.direction = UISwipeGestureRecognizerDirection.Left
        view.addGestureRecognizer(swipeLEFT)
        
        
        super.viewDidLoad()

    }
    
    
    
    func swiped(gesture: UISwipeGestureRecognizer){
     print("Trying to delete")
        deletes = true
    }
    
    @IBAction func SignOut(sender: AnyObject) {
        let login = ViewController()
        login.signOut("")
    }
    
    
    func downloadData(){
        let query = PFQuery(className: "CardInfo")
        query.whereKey("username", equalTo: currentUser!.username!)
        query.whereKey("setName", notEqualTo: "")
        do {
            print("be do be do")
            cards = try query.findObjects()
            self.collection.reloadData()
            print("Number of sets", cards.count)
//            print("cards", cards)
        }
        catch _ {
            print("Error")
        }

    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //query for current user
        //query for number of sets from user
        //return number of sets from user
        

        print("Collection number", cards.count)
        return cards.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
//        print("be do")
        
        var setName : String

        var comment: String
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as! UICollectionViewCell
        
        if let value = cards[indexPath.row]["setName"] as? String {
            
            comment = value
            let cellsize = CGFloat(widthsize)
            var name = UILabel(frame: CGRectMake(0, 0, cellsize, cellsize))
            name.font = UIFont(name:"HelveticaNeue;", size: 6.0)
            name.text = comment
            name.contentMode = UIViewContentMode.ScaleAspectFit
            name.textAlignment = NSTextAlignment.Center
            sets.append(comment)
            var pic = UIImage(named: "card.png")
        
            
            var backpic = UIImageView(image: UIImage(named: "card.png"))
            backpic.frame = CGRectMake(0, 0, cellsize, cellsize)
            
            cell.addSubview(backpic)
            cell.addSubview(name)
            
         }

        cell.backgroundColor = UIColor.lightGrayColor()
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        //get info from card
        setName = sets[indexPath.row]
        print("Passnig: ", setName)
        
//        deleteSet(setName)
        if deletes {
            print("will be working")
        }
        
        //segue to selected set-card view
        self.performSegueWithIdentifier("SetToCard", sender: nil)
        
    }
    

    
    func collectionView(collectionView: UICollectionView, performAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) {
        
        print("trying to delete")
        setName = sets[indexPath.row]
        deleteSet(setName)
        
        
        //        let delete = UITableViewRowAction(style: .Normal, title: "Delete") { action, index in
        //            print("delete button tapped")
        //            self.deleteSet(self.sets[indexPath.row])
        //            //            self.table.reloadData()
        //
        //        }
        //        delete.backgroundColor = UIColor.redColor()
        //        
        //        return [delete]
    }




    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func addSet(sender: AnyObject) {
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
    
    func deleteSet(setName: String) {
        let query = PFQuery(className: "CardInfo")
        query.whereKey("setName", equalTo: setName)
        do {
            let result = try query.findObjects()
            for r in result {
                r.deleteInBackground()
            }
        }
        catch {}
        downloadData()

    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "toCard" {
            print("Segueing to the card screen")
            let card = segue.destinationViewController as! FrontViewController
            card.setName = setName
        }
        else if segue.identifier == "SetToCard" {
            print("Segueing to the card set screen")
            let card = segue.destinationViewController as! SetToCardViewController
            card.setName = setName
        }

    }

}
