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
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
}
