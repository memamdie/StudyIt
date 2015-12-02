//
//  BackViewController.swift
//  StudyIt
//
//  Created by Isabel Laurenceau on 10/23/15.
//  Copyright © 2015 Isabel Laurenceau. All rights reserved.
//

import UIKit
import Parse

class BackViewController: UIViewController {
    
    @IBOutlet var backText: UITextView!
    var selected: String!
    //var cardID: String!
    var setName: String!
    override func viewDidLoad() {
        super.viewDidLoad()
        print(selected)
        print("BACK")
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func Save(sender: AnyObject) {
        //get objectID
        let query = PFQuery(className:"CardInfo")
        query.getObjectInBackgroundWithId(ID) {
            (object, error) -> Void in
            if error != nil {
                print(error)
            } else {
                if let object = object {
                    print("found")
                    object["backstring"] = self.backText.text
                    if self.imagePicked?.image != nil {
                        let imageData = UIImagePNGRepresentation(self.imagePicked!.image!)
                        object["backpic"] = PFFile(data: imageData!)
                    }
                    object["username"] = (PFUser.currentUser()?.username)!
                    object.saveInBackground()
                }
            }
        }
        print("Saving Back")
//        performSegueWithIdentifier("toIndividualCards", sender: nil)
        performSegueWithIdentifier("BackToCard", sender: nil)
        
    }
    
    //segue set name
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "toIndividualCards"   {
            
            let fvc = segue.destinationViewController as! cardTableViewController
            fvc.selectedSet = setName
        }
        else if segue.identifier == "BackToCard"   {
            
            let fvc = segue.destinationViewController as! SetToCardViewController
            fvc.setName = setName
        }
        
    }
    
    //********************************************************************************************************************//
    @IBOutlet var imagePicked: UIImageView?
    var imagePicker = UIImagePickerController()

    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        print("image has been picked")
        imagePicked!.image = image
        backText.text = ""
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
        imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        imagePicker.allowsEditing = true
        self.presentViewController(imagePicker, animated: true, completion: nil)
        
    }
    
    func PickFromCamera() {
        imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
        imagePicker.allowsEditing = true
        self.presentViewController(imagePicker, animated: true, completion: nil)
        
    }
    
}

