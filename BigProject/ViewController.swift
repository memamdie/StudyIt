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
    @IBOutlet var nameLabel: UILabel?
    var currentUser = PFUser.currentUser()
    override func viewDidLoad() {
        super.viewDidLoad()
        nameLabel?.font = nameLabel?.font.fontWithSize(20)
        nameLabel?.text = "Welcome \(currentUser!.username!)!!"
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
    
    // Password requirement
    /*func signUpViewController(signUpController: PFSignUpViewController, shouldBeginSignUp info: [NSObject : AnyObject]!) -> Bool {
    
        if let password = info?["password"] as? String {
            return password.utf16 >= 6
        }
        return false
    }*/
    
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
