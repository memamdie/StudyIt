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
        study()
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
                    self.imageView!.image = UIImage(data: imageData!)
                }
            }
        }
    }

    @IBAction func Next(sender: AnyObject) {
        
        if i < (studyset.count - 1) {
            self.i++
        }
        else{
            i = 0
        }
        if studyset[i]["frontstring"] as? String != "" {
            text.text = studyset[i]["frontstring"] as! String
        }
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
        
        if studyset[i]["backstring"] as? String != "" {
            text.text = studyset[i]["backstring"] as! String
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

    }
    
}
