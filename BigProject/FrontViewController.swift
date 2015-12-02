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
//            if self.imagePicked?.image != nil {
//                let imageData = UIImagePNGRepresentation(self.imagePicked!.image!)
//                FriendName["frontpic"] = PFFile(data: imageData!)
//            }
//            FriendName.setObject(self.imagePicked!, forKey: "frontpic")
            FriendName.saveInBackgroundWithBlock {
                (success: Bool, error:NSError?) -> Void in
                
                if(success)
                {
                    //We saved our information
                    print("Saved Title")
//                    ID = FriendName.objectId!
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
    //segue title name
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "FrontToBack"   {
            let fvc = segue.destinationViewController as! BackViewController
            
            fvc.selected = cardname
            //fvc.cardID = ""
            fvc.setName = setName
            print("front to back")
        }
    }
    
    
    //********************************************************************************************************************//
    @IBOutlet var imagePicked: UIImageView?
    var picker = UIImagePickerController()
    
//    @IBAction func upload(sender: AnyObject) {
//        print("in upload")
//        picker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
//        picker.allowsEditing = true
//        self.presentViewController(picker, animated: true, completion: nil)
//    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        
        imagePicked!.image = image
        EnteredText.text = ""
        self.dismissViewControllerAnimated(true, completion: nil)
        
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
