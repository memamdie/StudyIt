//
//  SetToCardViewController.swift
//  StudyIt
//
//  Created by Isabel Laurenceau on 11/18/15.
//  Copyright © 2015 Isabel Laurenceau. All rights reserved.
//

import UIKit
import Parse

class SetToCardViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet var collection: UICollectionView!
    var currentUser = PFUser.currentUser()
    var cards = [PFObject]()
    var setName: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        downloadData()
        collection.delegate = self
        // Resize size of collection view items in grid so that we achieve 3 boxes across
        let cellWidth = ((UIScreen.mainScreen().bounds.width) - 32 - 30 ) / 4
        let cellLayout = collection.collectionViewLayout as! UICollectionViewFlowLayout
        cellLayout.itemSize = CGSize(width: cellWidth, height: cellWidth)
        super.viewDidLoad()
        
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
                        print("Saved Set Title")
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
        
        
        
//        self.presentViewController(alertControl, animated: true, completion: nil)
        self.performSegueWithIdentifier("newCardFromSet", sender: nil)

//        self.performSegueWithIdentifier("newCardFromSet", sender: nil)
    }
    
    @IBAction func shuffle() {
        downloadData()
        shuffleInPlace()
//        table.reloadData()
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
    
    func downloadData(){
        let query = PFQuery(className: "CardInfo")
        query.whereKey("username", equalTo: currentUser!.username!)
        query.whereKey("setName", equalTo: setName)
        
        
        do {
            print("be do be do")
            cards = try query.findObjects()
            self.collection.reloadData()
            print("Number of sets", cards.count)
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

        var setName : String
        
        var comment: String
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as! UICollectionViewCell
        
        if let value = cards[indexPath.row]["frontstring"] as? String {
            
            comment = value
            var name = UILabel(frame: CGRectMake(0, 0, 50, 50))
            name.font = UIFont(name:"HelveticaNeue;", size: 6.0)
            name.text = comment
            name.contentMode = UIViewContentMode.ScaleAspectFit
            
            var pic = UIImageView(image: UIImage(named: "card.png"))
            cell.addSubview(pic)
            cell.addSubview(name)
            
        }
        
        cell.backgroundColor = UIColor.lightGrayColor()
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        //segue to selected set-card view
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {

        if segue.identifier == "newCardFromSet" {
            print("Segueing to the card set screen")
            let card = segue.destinationViewController as! FrontViewController
            card.setName = setName
        }
        else if segue.identifier == "shuffled"   {
            shuffledCards = cards
            let fvc = segue.destinationViewController as! FrontViewController
            fvc.displayShuffle()
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
}
