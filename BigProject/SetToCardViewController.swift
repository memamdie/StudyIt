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

    var widthsize = ((UIScreen.mainScreen().bounds.width) - 32 - 30 ) / 4
    @IBOutlet var collection: UICollectionView!
    var currentUser = PFUser.currentUser()
    var cards = [PFObject]()
    var setName: String!
    var studyset = [PFObject]()
    var deletes = false
    var index = 0
    
    @IBOutlet var shufflebutton: UIButton!
    @IBOutlet var studybutton: UIButton!
    @IBOutlet var matchbutton: UIButton!
    @IBOutlet var navTitle: UINavigationItem!
    
    override func viewDidLoad() {
        downloadData()
        collection.delegate = self
        navTitle.title = setName
        // Resize size of collection view items in grid so that we achieve 3 boxes across
        let cellWidth = ((UIScreen.mainScreen().bounds.width) - 32 - 30 ) / 4
        let cellLayout = collection.collectionViewLayout as! UICollectionViewFlowLayout
        cellLayout.itemSize = CGSize(width: cellWidth, height: cellWidth)
        
        shufflebutton.layer.cornerRadius = 10
        studybutton.layer.cornerRadius = 10
        matchbutton.layer.cornerRadius = 10
        super.viewDidLoad()
        
    }
    
    
    @IBAction func newCard(sender: AnyObject) {
        self.performSegueWithIdentifier("newCardFromSet", sender: nil)
    }
    
    @IBAction func shuffle() {
        downloadData()
        shuffleInPlace()
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
            cards = try query.findObjects()
            studyset = try query.findObjects()
            print("sets:", studyset)
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
        var imageView:UIImageView = UIImageView()
        var comment: String
        var cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath)
        
        if let value = cards[indexPath.row]["frontstring"] as? String {
            let cellsize = CGFloat(widthsize)
            if value != "" {
                comment = value
                let name = UILabel(frame: CGRectMake(0, 0, cellsize, cellsize))
                name.font = UIFont(name:"HelveticaNeue;", size: 6.0)
                name.text = comment
                name.contentMode = UIViewContentMode.ScaleAspectFit
                name.textAlignment = NSTextAlignment.Center

                let pic = UIImageView(image: UIImage(named: "flashcard.png"))
                pic.frame = CGRectMake(0, -5, cellsize, cellsize)

                cell.addSubview(pic)
                cell.addSubview(name)
            }
            else {
                if let finalImage = cards[indexPath.row]["frontpic"] as? PFFile {
                    finalImage.getDataInBackgroundWithBlock {
                        (imageData: NSData?, error: NSError?) -> Void in
                        imageView.image = UIImage(data: imageData!)
                    }
                }
                imageView.frame = cell.bounds
                cell.addSubview(imageView)
            }
        }
        
        cell.backgroundColor = UIColor.clearColor()
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        //segue to study
        if deletes == false {
             index = indexPath.row
            self.performSegueWithIdentifier("Study", sender: nil)
        }
        
        //delete card
        else {
            let alertControl: UIAlertController = UIAlertController(title: "Delete Card?", message:"" , preferredStyle: .Alert)
            let ok = UIAlertAction(title: "Delete", style: .Cancel) {action -> Void in
                self.deleteCard(self.cards[indexPath.row])
                self.deletes = false
                self.downloadData()
            }
            let cancel = UIAlertAction(title: "Cancel", style: .Default) {action -> Void in}
            alertControl.addAction(ok)
            alertControl.addAction(cancel)
            self.presentViewController(alertControl, animated: true, completion: nil)
            collection.reloadData()
        }
    }
    
    @IBAction func Trash(sender: AnyObject) {
        //makes collections selected to delete
        deletes = true
    }
    
    func deleteCard(cardObj: PFObject) {
        cardObj.deleteInBackground()
    }

    @IBAction func StudyIt(sender: AnyObject) {
        self.performSegueWithIdentifier("Study", sender: nil)
    }
    
    
    @IBAction func logOut(sender: UIBarButtonItem) {
        PFUser.logOut()
        if (PFUser.currentUser() == nil) {
            performSegueWithIdentifier("cardToHome", sender: self)
            print("Logging out of SetToCardViewController")
        } else {
            print("Error logging out from SetToCardViewController")
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {

        if segue.identifier == "newCardFromSet" {
            print("Segueing to the card set screen")
            let card = segue.destinationViewController as! FrontViewController
            card.setName = setName
        }
        else if segue.identifier == "Study" {
            print("Segueing to the card set screen")
            let svc = segue.destinationViewController as! StudyViewController
            svc.studyset = studyset
            svc.i = index
        }
        else if segue.identifier == "shuffled"   {
            let fvc = segue.destinationViewController as! StudyViewController
            fvc.studyset = cards
            fvc.i = index
        }
        else if segue.identifier == "Match" {
            print("Segueing to match screen")
            let card = segue.destinationViewController as! MatchViewController
            card.setName = setName
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
