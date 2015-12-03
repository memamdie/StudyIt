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
    var widthsize = ((UIScreen.mainScreen().bounds.width) - 32 - 30 ) / 4
    var cards = [PFObject]()
    var cards2 = [PFObject]()
    var setName: String!
    var deletes = false
    var touch1 = true
    var string1 = ""
    var string2 = ""
    var count = 0
    var expected = 0
    var score = 0
    var pair = 0
    var randoms = 0
    var previous = NSIndexPath(forRow: 0, inSection: 0);
    
    
    override func viewDidLoad() {
      
        downloadData()
//        collection.delegate = self
//        collection.allowsMultipleSelection = true
        
        
        // Resize size of collection view items in grid so that we achieve 3 boxes across
        let cellWidth = ((UIScreen.mainScreen().bounds.width) - 32 - 30 ) / 4
        let cellLayout = collection.collectionViewLayout as! UICollectionViewFlowLayout
        cellLayout.itemSize = CGSize(width: cellWidth, height: cellWidth)
        
        cellLayout.sectionInset = UIEdgeInsetsMake(0.0, 0.0,10,0);
        
        cellLayout.minimumLineSpacing = 10
        
        
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
//        query.addAscendingOrder("backstring")
        
        do {
            cards = try query.findObjects()
          
            //            print("sets:", studyset)
            self.collection.reloadData()
            print("Number of sets", cards.count)
        }
        catch _ {
            print("Error")
        }
        
        let query2 = PFQuery(className: "CardInfo")
        query2.whereKey("username", equalTo: currentUser!.username!)
        query2.whereKey("setName", equalTo: setName)
//        query.addAscendingOrder("frontstring")
        
        do {
            cards2 = try query.findObjects()
         
            //            print("sets:", studyset)
            self.collection.reloadData()
            print("Number of sets", cards2.count)
        }
        catch _ {
            print("Error")
        }
        
        shuffle()
        
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
        randoms = cards.count
        return cards.count
    }
    

    
    //Match, collection view of front and back of cards
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        var setName : String
        
        var comment: String
        var comment2: String
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as! UICollectionViewCell
        
        
        
        if indexPath.section == 0 {
            if let value = cards[indexPath.row]["frontstring"] as? String{
       
                comment = value
                
                let cellsize = CGFloat(widthsize)
                
                var name = UILabel(frame: CGRectMake(0, 0, cellsize, cellsize))
                name.font = UIFont(name:"HelveticaNeue;", size: 6.0)
                name.text = comment
                name.contentMode = UIViewContentMode.ScaleToFill
                name.textAlignment = NSTextAlignment.Center
                
                var backpic = UIImageView(image: UIImage(named: "flashcard.png"))
                backpic.frame = CGRectMake(0, 0, cellsize, cellsize)
                
                cell.addSubview(backpic)
                cell.addSubview(name)
                
            }
            
             if let value = cards[indexPath.row]["frontpic"] as? PFFile {
                print("add images")
                let cellsize = CGFloat(widthsize)
                
                var pic = UIImageView(image: UIImage(named: ""))
                pic.frame = CGRectMake(0, 0, cellsize, cellsize)
                
                    value.getDataInBackgroundWithBlock {
                        (imageData: NSData?, error: NSError?) -> Void in
                        pic.image = UIImage(data: imageData!)
                         cell.addSubview(pic)
                    }
                
              
            
                var backpic = UIImageView(image: UIImage(named: "flashcard.png"))
                backpic.frame = CGRectMake(0, 0, cellsize, cellsize)
                
//                cell.addSubview(backpic)
               
                
            }
        }
       
        else if indexPath.section != 0{
            if let back = cards[indexPath.row]["backstring"] as? String{
            
                comment2 = back
                
                let cellsize = CGFloat(widthsize)
                var name2 = UILabel(frame: CGRectMake(0, 0, cellsize, cellsize))
                name2.font = UIFont(name:"HelveticaNeue;", size: 6.0)
                name2.text = comment2
                name2.contentMode = UIViewContentMode.ScaleToFill
                name2.textAlignment = NSTextAlignment.Center

                
                var pic = UIImageView(image: UIImage(named: "card.png"))
                var backpic = UIImageView(image: UIImage(named: "flashcard.png"))
                backpic.frame = CGRectMake(0, 0, cellsize, cellsize)

                cell.addSubview(backpic)
                cell.addSubview(name2)
               
            }
            if let value = cards[indexPath.row]["backpic"] as? PFFile {
                print("add images")
                let cellsize = CGFloat(widthsize)
                
                var pic = UIImageView(image: UIImage(named: ""))
                pic.frame = CGRectMake(0, 0, cellsize, cellsize)
                
                value.getDataInBackgroundWithBlock {
                    (imageData: NSData?, error: NSError?) -> Void in
                    pic.image = UIImage(data: imageData!)
                    cell.addSubview(pic)
                }
                
                
                
                var backpic = UIImageView(image: UIImage(named: "flashcard.png"))
                backpic.frame = CGRectMake(0, 0, cellsize, cellsize)
                
                //                cell.addSubview(backpic)
                
                
            }

        }
        
        cell.backgroundColor = UIColor.clearColor()

        
        return cell
    }
    
    func shuffle() {
        // empty and single-element collections don't shuffle
        if cards.count < 2 { return }
        
        for i in 0..<cards.count - 1 {
            let j = Int(arc4random_uniform(UInt32(cards.count - i))) + i
            guard i != j else { continue }
            swap(&cards[i], &cards[j])
        }
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
        
        
        cell?.layer.borderWidth = 2.0
        cell?.layer.borderColor = UIColor.grayColor().CGColor

        
        
        if touch1 == true{
//            if cell?.selected == true {
            
                string1 = cards[indexPath.row].objectId!
                index1 = indexPath
                previous = indexPath
            
//                var cell2 = collectionView.cellForItemAtIndexPath(indexPath)
//                string1 = ((cards[indexPath.row]["title"] as? String)!
//            }
            
//            else{
//            cell?.backgroundColor = UIColor.clearColor()
//            }
            
            touch1 = false
        }
        
        else if touch1 == false{
//            if cell?.selected == true {
//                cell?.backgroundColor = UIColor.blueColor()
                string2 = cards[indexPath.row].objectId!
                index2 = indexPath
//                 string2 = (cards[indexPath.row]["title"] as? String)!
//            }
//            else{
                cell?.backgroundColor = UIColor.clearColor()
//            }
            touch1 = true
        }
        
        var check = pair % 2
        
        if check == 0 {
            //same objects
            if string1 == string2{
                count = count + 2
                score = score + 1

                var cell2 = collectionView.cellForItemAtIndexPath(previous)
                cell2?.layer.borderColor = UIColor.greenColor().CGColor

                
                cell?.layer.borderWidth = 2.0
                cell?.layer.borderColor = UIColor.greenColor().CGColor
        
                
                //they finished
                if count == expected {
                    
                    let alertControl: UIAlertController = UIAlertController(title: "You finished the game!", message:"" , preferredStyle: .Alert)
                    let seg = UIAlertAction(title: "Go Home", style: .Default) {action -> Void in
                        self.performSegueWithIdentifier("MatchToHome", sender: nil)
                    }
                    alertControl.addAction(seg)
                  
                    self.presentViewController(alertControl, animated: true, completion: nil)
                }
            }
                
            //different objects
            else{
            }
        }
    
        
        
        print("String 1: ", string1)
        print("String 2: ", string2)
        print("pair: ", pair)
        print("check: ", check)
        //get the object id
        print("Object ID", cards[indexPath.row].objectId )
        cell?.selected = false

    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
       if segue.identifier == "MatchToHome" {
            print("Segueing to card screen")
            let card = segue.destinationViewController as! SetToCardViewController
            card.setName = setName
        }
    }
    
    
}