//
//  StudyViewController.swift
//  StudyIt
//
//  Created by Isabel Laurenceau on 11/25/15.
//  Copyright © 2015 Isabel Laurenceau. All rights reserved.
//

import UIKit
import Parse

class StudyViewController: UIViewController {
    
    @IBOutlet var text: UITextView!
    @IBOutlet var imageView: UIImageView?
    var currentUser = PFUser.currentUser()
    var cards = [PFObject]()
    var setName: String!
    var studyset = [PFObject]()
    var i = 0
    var front = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(studyset)
        study()
        text.editable = false
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func study(){
//            print(studyset[i]["frontstring"])
        if studyset[i]["frontstring"] as? String != "" {
            text.text = studyset[i]["frontstring"] as! String
        }
        else {
            text.text = ""
            if let finalImage = studyset[i]["frontpic"] as? PFFile {
                finalImage.getDataInBackgroundWithBlock {
                    (imageData: NSData?, error: NSError?) -> Void in
                    self.imageView?.image = UIImage(data: imageData!)
                }
            }
        }
    }

    @IBAction func Next(sender: AnyObject) {
        //Inside this function we want to show the front of the next card
        if i < (studyset.count - 1) {
            self.i++
        }
        else{
            i = 0
        }
        //check to see if the front is a string
        if studyset[i]["frontstring"] as? String != "" {
            text.text = studyset[i]["frontstring"] as! String
        }
            //if its not a string show the picture
        else {
            text.text = ""
            if let finalImage = studyset[i]["frontpic"] as? PFFile {
                finalImage.getDataInBackgroundWithBlock {
                    (imageData: NSData?, error: NSError?) -> Void in
                    self.imageView!.image = UIImage(data: imageData!)
                }
            }
        }
        front = true
    }
    
    
    @IBAction func BackOfCard(sender: AnyObject) {
        if front == true{
            if studyset[i]["backstring"] as? String != "" {
                text.text = studyset[i]["backstring"] as? String
            }
            else {
                text.text = ""
                if let finalImage = studyset[i]["backpic"] as? PFFile {
                    finalImage.getDataInBackgroundWithBlock {
                        (imageData: NSData?, error: NSError?) -> Void in
                        self.imageView!.image = UIImage(data: imageData!)
                    }
                }
            }
            front = false
        }
        
        else {
            if studyset[i]["frontstring"] as? String != "" {
                text.text = studyset[i]["frontstring"] as! String
            }
            else {
                text.text = ""
                if let finalImage = studyset[i]["frontpic"] as? PFFile {
                    finalImage.getDataInBackgroundWithBlock {
                        (imageData: NSData?, error: NSError?) -> Void in
                        self.imageView?.image = UIImage(data: imageData!)
                    }
                }
            }
            front = true
        }
    }
    

}
