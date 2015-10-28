//
//  SignUpViewController.swift
//  StudyIt
//
//  Created by My Ling Nguyen on 10/27/15.
//

import UIKit
import Parse

class SignUpViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet var username: UITextField!
    @IBOutlet var password: UITextField!
    @IBOutlet var email: UITextField!
    @IBOutlet var errorMessage: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func createAccount(sender: AnyObject) {
        errorMessage.text = ""
        if username.text != "" && email.text != "" && password.text != "" {
            let user = PFUser()
            user.username = username.text
            user.password = password.text
            user.email = email.text
            
            user.signUpInBackgroundWithBlock { (succeeded: Bool, error: NSError?) -> Void in
                if let error = error {
                    let errorString = error.userInfo["error"] as? NSString
                    self.errorMessage.text = "\(errorString)"
                    print(errorString)
                } else {
                    print("You're in.")
                    self.performSegueWithIdentifier("signupToHome", sender: self)
                }
            }
        } else {
            errorMessage.text = "Fill in all the fields"
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool // called when 'return' key pressed.
    {
        textField.resignFirstResponder()
        return true;
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}