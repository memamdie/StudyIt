//
//  FrontViewController.swift
//  StudyIt
//
//  Created by Isabel Laurenceau on 10/23/15.
//  Copyright © 2015 Isabel Laurenceau. All rights reserved.
//

import UIKit
import Parse
var cardname = ""
var ID = ""

class FrontViewController: UIViewController,UIImagePickerControllerDelegate, UINavigationControllerDelegate  {
    var setName: String!
    @IBOutlet var EnteredText: UITextView!
    var side: Bool!
    var nextCard: Bool!
    var tempCard: PFObject!
    override func viewDidLoad() {
        super.viewDidLoad()
        picker.delegate = self
        //        titlealert()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func GetTitle(sender: AnyObject) {
        //get title
        let alertControl: UIAlertController = UIAlertController(title: "Please enter a title", message: "", preferredStyle: .Alert)
        let ok = UIAlertAction(title: "OK", style: .Cancel) { (_) in
            let titlename = alertControl.textFields![0] as UITextField
            cardname = titlename.text!
            
            //save title to parse
            let FriendName = PFObject(className: "CardInfo")
            FriendName.setObject(cardname, forKey: "title")
            FriendName.setObject(self.EnteredText.text, forKey: "frontstring")
            FriendName.setObject((PFUser.currentUser()?.username)!, forKey: "username")
            FriendName.setObject(self.setName, forKey: "setName")
            FriendName.saveInBackgroundWithBlock {
                (success: Bool, error:NSError?) -> Void in
                
                if(success)
                {
                    //We saved our information
                    print("Saved Title")
                    ID = FriendName.objectId!
                    self.performSegueWithIdentifier("FrontToBack", sender: nil)
                }
                else
                {
                    //there was a problem
                    print(error)
                    print("Error: Did Not Save Title")
                }
            }
            
            
        }
        alertControl.addAction(ok)
        alertControl.addTextFieldWithConfigurationHandler { (textField) in
            textField.placeholder = "Title"
            
        }
        self.presentViewController(alertControl, animated: true, completion: nil)

    }
    func displayShuffle() {
        let tap = UITapGestureRecognizer(target: self, action: "doubleTapped")
        tap.numberOfTapsRequired = 2
        view.addGestureRecognizer(tap)
        side = false
        nextCard = false
        for card in cards {
            tempCard = card
            while !nextCard {
                if card["frontstring"] != nil {
                    EnteredText.text = card["frontstring"] as! String
                }
                else {
                    //Display the picture in the entered text somehow
                }
            }
        }
    }
    func doubleTapped() {
        //This means you are looking at the front and you have doubleTapped
        if side == false {
            //so we need to display the back now
            side = true
            if tempCard["backstring"] != nil {
                EnteredText.text = tempCard["backstring"] as! String
            }
            else {
                //Display the picture in the entered text somehow
            }
        }
        else {
            //we need to display the next card
            nextCard = true
        }
    }
    
    //segue title name
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "FrontToBack"   {
            let fvc = segue.destinationViewController as! BackViewController
            fvc.selected = cardname
            //fvc.cardID = ""
            fvc.setName = setName
        }
    }
    
    
    
    
    //********************************************************************************************************************//
    @IBOutlet var Image: UIImageView!
    var picker = UIImagePickerController()
    
    @IBAction func upload(sender: AnyObject) {
        print("in upload")
        picker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        picker.allowsEditing = true
        self.presentViewController(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        print("TRYING TO SAVE TO PARSE")
        //set selectedIMage to image that we picked.
        Image.image = image
        //get rid of picker
        self.dismissViewControllerAnimated(true, completion: nil)
        
        //upload image
        let imagePosts = PFObject(className: "CardInfo")
        
        
        let imageData = UIImagePNGRepresentation(image)
        imagePosts["frontpic"] = PFFile(data: imageData!)
        
        //let naneuser = PFUser.currentUser()!.username
        //imagePosts["username"] = PFUser.currentUser()!.username
        
        //ALSO GET TITLE
        
        imagePosts.saveInBackgroundWithBlock {
            (success: Bool, error:NSError?) -> Void in
            
            if(success)
            {
                //We saved our information
                print("Saved")
                
            }
            else
            {
                //there was a problem
                print("Error")
            }
            
        }
        
    }
    
    
    @IBAction func AddPhoto(sender: AnyObject) {
        
        let alertControl: UIAlertController = UIAlertController(title: "Upload Photo", message: "Upload photo from Camera or Gallery", preferredStyle: .Alert)
        let Camera = UIAlertAction(title: "Take Photo", style: .Default) {action  in self.PickFromCamera()}
        alertControl.addAction(Camera)
        
        let Gallery = UIAlertAction(title: "Choose from Gallery", style: .Default) {action  in self.PickFromGallery()}
        alertControl.addAction(Gallery)
        
        self.presentViewController(alertControl, animated: true, completion: nil)
    }
    
    func PickFromGallery() {
        print("in gal")
        picker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        picker.allowsEditing = true
        self.presentViewController(picker, animated: true, completion: nil)
        
    }
    
    func PickFromCamera() {
        picker.sourceType = UIImagePickerControllerSourceType.Camera
        picker.allowsEditing = true
        self.presentViewController(picker, animated: true, completion: nil)
        
    }
    
}
