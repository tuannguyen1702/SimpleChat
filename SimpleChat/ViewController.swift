//
//  ViewController.swift
//  SimpleChat
//
//  Created by ivc on 2/17/17.
//  Copyright © 2017 ivc. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewDidAppear(animated: Bool) {
        let isLoggedIn = NSUserDefaults.standardUserDefaults().boolForKey("isLoggedIn");
        if(!isLoggedIn){
            self.performSegueWithIdentifier("loginView", sender: self);
        }
        
    }

    @IBAction func logoutButtonTapped(sender: AnyObject) {
        NSUserDefaults.standardUserDefaults().setBool(false, forKey: "isLoggedIn");
        NSUserDefaults.standardUserDefaults().synchronize();
        
        self.performSegueWithIdentifier("loginView", sender: self);
    }
}

