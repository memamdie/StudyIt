//
//  ViewController.swift
//  BigProject
//
//  Created by Isabel Laurenceau on 9/29/15.
//  Copyright © 2015 Isabel Laurenceau. All rights reserved.
//
//  ParseUI code came from a tutorial on www.veasoftware.com
//  login/signup customization came from Parse.com documentation

import UIKit
import Parse
import ParseUI

class ViewController: UIViewController, PFLogInViewControllerDelegate, PFSignUpViewControllerDelegate  {
    
    @IBOutlet var collection: UICollectionView!
    var currentUser = PFUser.currentUser()
    var cards = [PFObject]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        downloadData()
        

        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        self.loginSetup()
    }

    func logInViewController(logInController: PFLogInViewController, shouldBeginLogInWithUsername username: String, password: String) -> Bool {
    
        if (!username.isEmpty || !password.isEmpty) {
            return true
        } else {
            return false
        }
    }
    
    func logInViewController(logInController: PFLogInViewController, didLogInUser user: PFUser) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func logInViewController(logInController: PFLogInViewController, didFailToLogInWithError error: NSError?) {
        print("Failed to log in...")
    }
    
     func signUpViewController(signUpController: PFSignUpViewController, didSignUpUser user: PFUser) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func signUpViewController(signUpController: PFSignUpViewController, didFailToSignUpWithError error: NSError?) {
        print("Failed to sign up...")
    }
    
    func signUpViewControllerDidCancelSignUp(signUpController: PFSignUpViewController) {
        print("User dismissed sign up.")
    }
    
    func loginSetup() {
        if (PFUser.currentUser() == nil) {
            let logInViewController = PFLogInViewController()
            
            logInViewController.delegate = self
            
            logInViewController.fields = [PFLogInFields.UsernameAndPassword, PFLogInFields.LogInButton, PFLogInFields.SignUpButton, PFLogInFields.PasswordForgotten]
            
            logInViewController.logInView!.backgroundColor = UIColor.blueColor()
            let logInLogoTitle = UILabel()
            logInLogoTitle.font = UIFont(name: "Georgia", size: 50)
            logInLogoTitle.textColor = UIColor.whiteColor()
            logInLogoTitle.text = "StudyIt"
            
            logInViewController.logInView?.logo = logInLogoTitle

            let signUpViewController = PFSignUpViewController()
            
            signUpViewController.delegate = self
            
            signUpViewController.signUpView!.backgroundColor = UIColor.blueColor()
            
            let signUpLogoTitle = UILabel()
            signUpLogoTitle.font = UIFont(name: "Georgia", size: 50)
            signUpLogoTitle.textColor = UIColor.whiteColor()
            signUpLogoTitle.text = "StudyIt"
            
            signUpViewController.signUpView?.logo = signUpLogoTitle
            
            logInViewController.signUpController = signUpViewController
            
            self.presentViewController(logInViewController, animated: true, completion: nil)
        }
    }
  
    @IBAction func signOut(sender: AnyObject) {
        PFUser.logOut()
        
        self.loginSetup()
    }
    
    
    

    

    
    func downloadData(){      
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
        
        
        
        
        
        
        var comment: String
        //        var imageView:UIImageView = UIImageView()
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as! UICollectionViewCell
        if let value = cards[indexPath.row]["username"] as? String {
            comment = value
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
        
        //        cell.addSubview(imageView)
        return cell
    }
    

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
