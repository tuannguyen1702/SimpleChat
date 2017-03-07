//
//  ViewController.swift
//  SimpleChat
//
//  Created by ivc on 2/17/17.
//  Copyright © 2017 ivc. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var contactTable: UITableView!
    
    var ref: FIRDatabaseReference!
    var users: Dictionary<String, AnyObject>!
    var userLogin: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.ref = FIRDatabase.database().reference()
        
        self.contactTable.delegate =  self
        self.contactTable.dataSource = self
        self.contactTable.registerClass(UITableViewCell.self, forCellReuseIdentifier: "customcell")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        
        
        //self.contactTable.reloadData()
        
        let isLoggedIn = NSUserDefaults.standardUserDefaults().boolForKey("isLoggedIn");
        if(!isLoggedIn){
            self.performSegueWithIdentifier("loginView", sender: self);
        }
        
        let userRef = self.ref.child("Users")
        if(NSUserDefaults.standardUserDefaults().objectForKey("username") != nil)
        {
            userLogin = NSUserDefaults.standardUserDefaults().objectForKey("username") as! String
        }
        
        userRef.observeEventType(.Value, withBlock:{
            (snapshot) in
            
            //self.users = snapshot.value as? NSDictionary
            self.users = snapshot.value as! Dictionary<String, AnyObject>
            if (self.userLogin != nil)
            {
                self.users.removeValueForKey(self.userLogin)
            }
            
            self.contactTable.reloadData()
            
            }) { (error) in
                print(error.localizedDescription)
        }

    }
    
    @IBAction func logoutButtonTapped(sender: AnyObject) {
        NSUserDefaults.standardUserDefaults().setBool(false, forKey: "isLoggedIn");
        NSUserDefaults.standardUserDefaults().setObject(nil, forKey: "username");
        NSUserDefaults.standardUserDefaults().synchronize();
        
//        self.performSegueWithIdentifier("loginView", sender: self);
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (self.users != nil) ? self.users.count : 0;

    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ContactCell", forIndexPath: indexPath)
       
        cell.textLabel?.text =  Array(self.users.values)[indexPath.item]["Name"] as? String
        
        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showDetail" {
            if let indexPath = self.contactTable.indexPathForSelectedRow {
                let user = Array(self.users)[indexPath.row]
                //self.users.indexOf(indexPath.row)
               
               (segue.destinationViewController as! ChattingViewController).user = user
            }
        }
    }
    
}

