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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        downloadData()
        collection.delegate = self
        // Resize size of collection view items in grid so that we achieve 3 boxes across
        let cellWidth = ((UIScreen.mainScreen().bounds.width) - 32 - 30 ) / 3
        let cellLayout = collection.collectionViewLayout as! UICollectionViewFlowLayout
        cellLayout.itemSize = CGSize(width: cellWidth, height: cellWidth)
        super.viewDidLoad()

    }
    
    func downloadData(){
        let query = PFQuery(className: "CardInfo")
        query.whereKey("username", equalTo: currentUser!.username!)
        
        
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
        
//        return 1
        print(cards.count ,"Number of sets")
        return cards.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        print("be do")
        
        var setName : String
        
        
        
        
        var comment: String
//        var imageView:UIImageView = UIImageView()
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as! UICollectionViewCell
        if let value = cards[indexPath.row]["setName"] as? String {
            comment = value
            var name = UILabel(frame: CGRectMake(0, 0, 200, 200))
            
            
            name.font = UIFont(name:"HelveticaNeue;", size: 6.0)
            name.text = comment
            name.contentMode = UIViewContentMode.ScaleAspectFit
            
            cell.addSubview(name)

        }
        
//        if let img = pictures[indexPath.row]["image"] as? PFFile {
//            let finalImage = pictures[indexPath.row]["image"] as? PFFile
//            finalImage!.getDataInBackgroundWithBlock {
//                (imageData: NSData?, error: NSError?) -> Void in
//                imageView.image = UIImage(data: imageData!)
//            }
//        }
//        imageView.frame = cell.bounds
        cell.backgroundColor = UIColor.lightGrayColor()
        
        
        return cell
    }
    


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}
