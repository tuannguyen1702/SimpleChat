//
//  LoginViewController.swift
//  SimpleChat
//
//  Created by ivc on 2/17/17.
//  Copyright © 2017 ivc. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    var userRef: FIRDatabaseReference!

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func loginButtonTapped(sender: AnyObject) {
        
        let email = emailTextField.text!;
        let password = passwordTextField.text!;
        
        
        let emailStored = NSUserDefaults.standardUserDefaults().stringForKey("email");
        
        let passwordStored = NSUserDefaults.standardUserDefaults().stringForKey("password");
        
        if(email == emailStored)
        {
            if(password == passwordStored)
            {
                NSUserDefaults.standardUserDefaults().setBool(true, forKey: "isLoggedIn");
                NSUserDefaults.standardUserDefaults().setObject(email, forKey: "username");
                NSUserDefaults.standardUserDefaults().synchronize();
                self.dismissViewControllerAnimated(true, completion: nil);
            }
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
