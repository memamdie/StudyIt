//
//  MatchViewController.swift
//  StudyIt
//
//  Created by Isabel Laurenceau on 11/27/15.
//  Copyright © 2015 Isabel Laurenceau. All rights reserved.
//

import UIKit
import Parse

class MatchViewController: UIViewController {
    
    @IBOutlet var collection: UICollectionView!
    var currentUser = PFUser.currentUser()
    var cards = [PFObject]()
    var setName: String!
    var deletes = false
    var touch1 = true
    var string1 = ""
    var string2 = ""
    var count = 0
    var expected = 0
    var score = 0
    var pair = 0
    
    override func viewDidLoad() {
      
        downloadData()
//        collection.delegate = self
        collection.allowsMultipleSelection = true
        
        
        // Resize size of collection view items in grid so that we achieve 3 boxes across
        let cellWidth = ((UIScreen.mainScreen().bounds.width) - 32 - 30 ) / 4
        let cellLayout = collection.collectionViewLayout as! UICollectionViewFlowLayout
        cellLayout.itemSize = CGSize(width: cellWidth, height: cellWidth)
        super.viewDidLoad()

    }
    
    @IBAction func logOut(sender: UIBarButtonItem) {
        PFUser.logOut()
        if (PFUser.currentUser() == nil) {
            performSegueWithIdentifier("matchToHome", sender: self)
            print("Logging out of MatchViewController")
        } else {
            print("Error logging out from MatchViewController")
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func downloadData(){
        let query = PFQuery(className: "CardInfo")
        query.whereKey("username", equalTo: currentUser!.username!)
        query.whereKey("setName", equalTo: setName)
        
        
        do {
            cards = try query.findObjects()
          
            //            print("sets:", studyset)
            self.collection.reloadData()
            print("Number of sets", cards.count)
        }
        catch _ {
            print("Error")
        }
        
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //query for current user
        //query for number of sets from user
        //return number of sets from user
        
        print("View number", cards.count)
        expected = cards.count * 2
        return cards.count
    }
    
    //Match, collection view of front and back of cards
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        var setName : String
        
        var comment: String
        var comment2: String
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as! UICollectionViewCell
        
        
        if indexPath.section == 0 {
            if let value = cards[indexPath.row]["frontstring"] as? String {
       
                comment = value
                var name = UILabel(frame: CGRectMake(0, 0, 50, 50))
                name.font = UIFont(name:"HelveticaNeue;", size: 6.0)
                name.text = comment
                name.contentMode = UIViewContentMode.ScaleAspectFit
        
                var pic = UIImageView(image: UIImage(named: "card.png"))
//                cell.addSubview(pic)
                cell.addSubview(name)
            }
        }
            
        else if indexPath.section != 0{
            if let back = cards[indexPath.row]["backstring"] as? String{
            
                comment2 = back
                var name2 = UILabel(frame: CGRectMake(0, 0, 50, 50))
                name2.font = UIFont(name:"HelveticaNeue;", size: 6.0)
                name2.text = comment2
                name2.contentMode = UIViewContentMode.ScaleAspectFit
                var pic = UIImageView(image: UIImage(named: "card.png"))
//                cell.addSubview(pic)
                cell.addSubview(name2)
            }
        }
        
        cell.backgroundColor = UIColor.lightGrayColor()
        
     
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        //In did selects cell(
        //Make every first selection one color and every second collection another.
        //If they have the same object ID make cell go gray, if not pop up that it was wrong and lower the score.
        //Once score is 20% of collection count game over. )
        pair++
        var index1 = indexPath
        var index2: NSIndexPath
        
        var cell = collectionView.cellForItemAtIndexPath(indexPath)
        
        
        cell?.layer.borderWidth = 4.0
        cell?.layer.borderColor = UIColor.grayColor().CGColor

        
        
        if touch1 == true{
            if cell?.selected == true {
                
                string1 = cards[indexPath.row].objectId!
              index1 = indexPath
//                var cell2 = collectionView.cellForItemAtIndexPath(indexPath)
//                string1 = ((cards[indexPath.row]["title"] as? String)!
            }
            else{
            cell?.backgroundColor = UIColor.clearColor()
            }
            touch1 = false
        }
        
        else if touch1 == false{
            if cell?.selected == true {
//                cell?.backgroundColor = UIColor.blueColor()
                string2 = cards[indexPath.row].objectId!
              index2 = indexPath
//                 string2 = (cards[indexPath.row]["title"] as? String)!
            }
            else{
                cell?.backgroundColor = UIColor.clearColor()
            }
            touch1 = true
        }
        
        if pair != 1 {
            if string1 == string2{
                
    //            cell?.backgroundColor = UIColor.blackColor()
                 var cell2 = collectionView.cellForItemAtIndexPath(index1)
    //            cell2?.backgroundColor = UIColor.blackColor()
                
                count = count + 2
                cell?.layer.borderWidth = 4.0
                cell?.layer.borderColor = UIColor.greenColor().CGColor
                
                score = score + 1
                
                //they finished
                if count == expected {
                print("done with matches")
                    let alertControl: UIAlertController = UIAlertController(title: "You finished the game!", message:"" , preferredStyle: .Alert)
                    let seg = UIAlertAction(title: "Go Home", style: .Default) {action -> Void in
                        self.performSegueWithIdentifier("MatchToHome", sender: nil)
                    }
                    alertControl.addAction(seg)
                  
                    self.presentViewController(alertControl, animated: true, completion: nil)
                }
            }
           
        }
    
        
        
        print("String 1: ", string1)
        print("String 2: ", string2)
        print("pair: ", pair)
        //get the object id
        print("Object ID", cards[indexPath.row].objectId )
        
        if pair == 1{
            pair = 2
        }
        
        if pair == 2{
            
            pair = 1
        }
    }
}