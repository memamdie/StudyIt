//
//  LoginViewController.swift
//  StudyIt
//
//  Created by My Ling Nguyen on 10/27/15.
//

import UIKit
import Parse

//var currentUser = PFUser.currentUser()

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet var username: UITextField!
    @IBOutlet var password: UITextField!
    @IBOutlet var errorMessage: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func login(sender: AnyObject) {
        errorMessage.text = ""
        if username.text != "" && password.text != "" {
            PFUser.logInWithUsernameInBackground(username.text!, password:password.text!) {
                (user: PFUser?, error: NSError?) -> Void in
                if user != nil {
                    print("You logged in")
                    //currentUser = PFUser.currentUser()
                    dispatch_async(dispatch_get_main_queue(), {
                        self.performSegueWithIdentifier("signinToHome", sender: self)
                    })
                }
                else {
                    self.errorMessage.text = error?.description
                    print(error?.description)
                }
            }
        } else {
            errorMessage.text = "Please fill both fields"
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}


