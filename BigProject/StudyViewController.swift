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
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func study(){
        //iterate through array
        //how to get front string print(studyset[1]["frontstring"])
//        for i = 0; i < studyset.count; i++ {
            //when they press back go to back of notecard
            //when they press next go to next notecard
//            text.text = studyset[i] as! String
            text.text = studyset[i]["frontstring"] as! String
//        }
        
    }

    @IBAction func Next(sender: AnyObject) {
        if i < (studyset.count - 1) {
            self.i++
            text.text = studyset[i]["frontstring"] as! String
        }
        else{
            i = 0
            text.text = studyset[i]["frontstring"] as! String
            //do nothing
        }
        front = true
    }
    
    
    @IBAction func BackOfCard(sender: AnyObject) {
        if front == true{
//        for var i = 0; i < studyset.count; i++ {
            //when they press back go to back of notecard
            //when they press next go to next notecard
            text.text = studyset[i]["backstring"] as? String
            front = false
//        }
        }
        else if front == false{
            text.text = studyset[i]["frontstring"] as? String
            front = true
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
