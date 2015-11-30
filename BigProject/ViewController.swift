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
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        self.loginSetup()
    }

    func logInViewController(logInController: PFLogInViewController, shouldBeginLogInWithUsername username: String, password: String) -> Bool {
    
        if (!username.isEmpty && !password.isEmpty) {
            return true // Begin login process
        }
        
        let title = NSLocalizedString("Missing Information", comment: "")
        let message = NSLocalizedString("Make sure you fill out all of the information!", comment: "")
        let cancelButtonTitle = NSLocalizedString("OK", comment: "")
        UIAlertView(title: title, message: message, delegate: nil, cancelButtonTitle: cancelButtonTitle).show()
        
        return false // Interrupt login process
    }
    
    func logInViewController(logInController: PFLogInViewController, didLogInUser user: PFUser) {
        self.performSegueWithIdentifier("Home", sender: nil)
        self.dismissViewControllerAnimated(true, completion: nil)
        self.performSegueWithIdentifier("Home", sender: nil)
    }
    
    func logInViewController(logInController: PFLogInViewController, didFailToLogInWithError error: NSError?) {
        if let description = error?.localizedDescription {
            let cancelButtonTitle = NSLocalizedString("OK", comment: "")
            UIAlertView(title: "Invalid login paramenter, please try again", message: nil, delegate: nil, cancelButtonTitle: cancelButtonTitle).show()
        }
        print("Failed to log in...\(description)")
        print("\(description)")
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
            
            logInViewController.logInView!.backgroundColor = UIColor(red: 0, green: 122/255.0, blue: 1.0, alpha: 1.0)
            let logInLogoTitle = UILabel()
            logInLogoTitle.font = UIFont(name: "Georgia", size: 50)
            logInLogoTitle.textColor = UIColor.whiteColor()
            logInLogoTitle.text = "StudyIt"
            
            logInViewController.logInView?.logo = logInLogoTitle

            let signUpViewController = PFSignUpViewController()
            
            signUpViewController.delegate = self
            
            signUpViewController.signUpView!.backgroundColor = UIColor(red: 0, green: 122/255.0, blue: 1.0, alpha: 1.0)
            
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "Home" {
            print("Going Home")
        }
    }

}
