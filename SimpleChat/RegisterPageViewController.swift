//
//  RegisterPageViewController.swift
//  SimpleChat
//
//  Created by ivc on 2/17/17.
//  Copyright © 2017 ivc. All rights reserved.
//

import UIKit

class RegisterPageViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func registerButtonTapped(sender: AnyObject) {
        let email = emailTextField.text!;
        let password = passwordTextField.text!;
        let confirmPassword = confirmPasswordTextField.text!;
        
        
        if(email.isEmpty || password.isEmpty || confirmPassword.isEmpty)
        {
            displayMyAlertMessage("All fields are required");
            return;
        }
        
        if(password != confirmPassword){
            displayMyAlertMessage("Passwords do not match");
            return;
        }
        
        NSUserDefaults.standardUserDefaults().setObject(email, forKey: "email");
        NSUserDefaults.standardUserDefaults().setObject(password, forKey: "password");
        
        NSUserDefaults.standardUserDefaults().synchronize();
        
        let myAlert = UIAlertController(title: "Alert", message:"Registration is success.", preferredStyle: UIAlertControllerStyle.Alert);
        
        let okAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default){ action in self.dismissViewControllerAnimated(true, completion: nil);
        }
        
        myAlert.addAction(okAction);
        self.presentViewController(myAlert, animated: true, completion: nil);
    }
    
    func displayMyAlertMessage(messageText:String)
    {
        let myAlert = UIAlertController(title: "Alert", message:messageText, preferredStyle: UIAlertControllerStyle.Alert);
        
        let okAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil)
        
        myAlert.addAction(okAction);
        
        self.presentViewController(myAlert, animated: true, completion: nil);
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
