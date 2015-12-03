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
    var add = true
    var i = 0
    var number = [String]()
    
    override func viewDidLoad() {

        downloadData()
        checkData()
        collection.delegate = self
        
        // Resize size of collection view items in grid so that we achieve 3 boxes across
        let cellWidth = ((UIScreen.mainScreen().bounds.width) - 32 - 30 ) / 4
        let cellLayout = collection.collectionViewLayout as! UICollectionViewFlowLayout
        cellLayout.itemSize = CGSize(width: cellWidth, height: cellWidth)

        super.viewDidLoad()
    }
    
    
    func swiped(gesture: UISwipeGestureRecognizer){
     print("Trying to delete")
        deletes = true
    }
    
    @IBAction func SignOut(sender: AnyObject) {
        PFUser.logOut()
        if (PFUser.currentUser() == nil) {
            performSegueWithIdentifier("setsViewToHome", sender: self)
            print("Logging out of SetsViewController")
        } else {
            print("Error logging out from SetsViewController")
        }
    }
    
    
    func downloadData(){
        let query = PFQuery(className: "CardInfo")
        query.whereKey("username", equalTo: currentUser!.username!)
        query.whereKey("setName", notEqualTo: "")
        do {
            print("be do be do")
            cards = try query.findObjects()
            self.collection.reloadData()
            
            
            for var i = 0; i < cards.count; i++ {
                 print(cards[i]["setName"] as! String)
        }
            
            
            
//            print("Number of sets", cards.count)
//            print("Sets:", cards)
        }
        catch _ {
            print("Error")
        }

    }
    
    func checkData(){
        //if the setname is already in the cards set do not add
        
        
        
        let query = PFQuery(className: "CardInfo")
        query.whereKey("username", equalTo: currentUser!.username!)
        
        
        do {
            cards = try query.findObjects()
            self.collection.reloadData()
            
            //get the setName- cards[i]["setName"] as! String
            for var i = 0; i < cards.count; i++ {
            number.append(cards[i]["setName"] as! String)
            }
            
            
            
            number = Array(Set(number))
            
            print(number)
            
            
            
            
        }
        catch _ {
            print("Error")
        }

        print("Please work", number.count)
        
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //query for current user
        //query for number of sets from user
        //return number of sets from user
    
        
        let query = PFQuery(className: "CardInfo")
        query.whereKey("username", equalTo: currentUser!.username!)
        
        
        do {
            cards = try query.findObjects()
            self.collection.reloadData()
            
            //get the setName- cards[i]["setName"] as! String
            for var i = 0; i < cards.count; i++ {
                number.append(cards[i]["setName"] as! String)
            }
            
            
            
            number = Array(Set(number))

            
        }
        catch _ {
            print("Error")
        }
        
        
//        
//        print("Collection number", cards.count)
//        return cards.count
        
        print("Collection number",  number.count)
        return number.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        var setName : String

        var comment: String
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as! UICollectionViewCell
        
        

        
        
            let cellsize = CGFloat(widthsize)
            var name = UILabel(frame: CGRectMake(0, 0, cellsize, cellsize))
            name.font = UIFont(name:"HelveticaNeue;", size: 30.0)
            name.text = number[indexPath.row]
            name.contentMode = UIViewContentMode.ScaleToFill
            name.textAlignment = NSTextAlignment.Center
        
        
            var pic = UIImage(named: "flashcard.png")
            
            
            var backpic = UIImageView(image: UIImage(named: "flashcard.png"))
            backpic.frame = CGRectMake(0, -5, cellsize, cellsize)
            
            
            
            
            cell.addSubview(backpic)
            cell.addSubview(name)
        

        
        //works but has dupicaltes
//        if let value = cards[indexPath.row]["setName"] as? String {
//            
//            comment = value
//            let cellsize = CGFloat(widthsize)
//            var name = UILabel(frame: CGRectMake(0, 0, cellsize, cellsize))
//            name.font = UIFont(name:"HelveticaNeue;", size: 6.0)
//            name.text = comment
//            name.contentMode = UIViewContentMode.ScaleAspectFit
//            name.textAlignment = NSTextAlignment.Center
//            sets.append(comment)
//            var pic = UIImage(named: "card.png")
//        
//            
//            var backpic = UIImageView(image: UIImage(named: "card.png"))
//            backpic.frame = CGRectMake(0, 0, cellsize, cellsize)
//
//            
//            
//            
//            cell.addSubview(backpic)
//            cell.addSubview(name)
//        }
        

    
        
        //does note work...

//                var pic = UIImage(named: "card.png")
//                var backpic = UIImageView(image: UIImage(named: "card.png"))
//                backpic.frame = CGRectMake(0, 0, cellsize, cellsize)
//            
//                for var i = 0; i < sets.count; i++ {
//      
//                    //dont add to view
//                    if comment == sets[i]{
//                        print("don't add")
//                        add = false
//                    }
//                }
//
//                if add == true {
//                    print("add")
//                    sets.append(comment)
//                    
//                    cell.addSubview(backpic)
//                    cell.addSubview(name)
//                }
        
//         }

        cell.backgroundColor = UIColor.clearColor()
        return cell
    }
    
    
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if deletes == false {
            //get info from card
//            setName = sets[indexPath.row]
            setName = number[indexPath.row]
            print("Passnig: ", setName)

            //segue to selected set-card view
            self.performSegueWithIdentifier("SetToCard", sender: nil)
        }
        
        else {
            
            let alertControl: UIAlertController = UIAlertController(title: "Delete Set?", message:"" , preferredStyle: .Alert)
            let ok = UIAlertAction(title: "Delete", style: .Cancel) {action -> Void in
//                self.deleteSet(self.sets[indexPath.row])
                self.deleteSet(self.number[indexPath.row])
                self.deletes = false
//                self.downloadData()
            }
            let cancel = UIAlertAction(title: "Cancel", style: .Default) {action -> Void in}
            alertControl.addAction(ok)
            alertControl.addAction(cancel)
            self.presentViewController(alertControl, animated: true, completion: nil)
        }
        downloadData()
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
    
    @IBAction func Trash(sender: AnyObject) {
        //makes collections selected to delete
        deletes = true
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

