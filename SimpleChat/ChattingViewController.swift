

//
//  ChattingViewController.swift
//  SimpleChat
//
//  Created by ivc on 2/24/17.
//  Copyright © 2017 ivc. All rights reserved.
//

import UIKit
import Firebase
import JSQMessagesViewController


class ChattingViewController:JSQMessagesViewController {
    
    var user: (String, AnyObject)!
    var msgRef: FIRDatabaseReference!
    var listMes: FIRDatabaseReference!
    var messages = [JSQMessage]()
    var userLogin: String!
    var userReceiver: String!
    var roomName: String!

    
    let incomingBubble = JSQMessagesBubbleImageFactory().incomingMessagesBubbleImageWithColor(UIColor(red: 10/255, green: 180/255, blue: 230/255, alpha: 1.0))
    let outgoingBubble = JSQMessagesBubbleImageFactory().outgoingMessagesBubbleImageWithColor(UIColor.lightGrayColor())
    
    //lazy var outgoingBubbleImageView: JSQMessagesBubbleImage = self.setupOutgoingBubble()
    //lazy var incomingBubbleImageView: JSQMessagesBubbleImage = self.setupIncomingBubble()


    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.msgRef = FIRDatabase.database().reference().child("Messages")
        self.userLogin = NSUserDefaults.standardUserDefaults().objectForKey("username") as! String;
        self.userReceiver = self.user.0
        
        self.setup()
        self.addDemoMessages()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func reloadMessagesView() {
        self.collectionView?.reloadData()
    }
    
    func addDemoMessages() {
        /*for i in 1...10 {
            let sender = (i%2 == 0) ? "Server" : self.senderId
            let messageContent = "Message nr. \(i)"
            let message = JSQMessage(senderId: sender, displayName: sender, text: messageContent)
            self.messages += [message]
        }*/
        //self.msgRef = FIRDatabase.database().reference()
        //let messageQuery = self.msgRef
        self.roomName = "\(self.userLogin)_\(self.userReceiver)"
        
        self.msgRef.observeSingleEventOfType(.Value, withBlock: { (snapshot) in
            if !snapshot.hasChild(self.roomName)
            {
                self.roomName = "\(self.userReceiver)_\(self.userLogin)"
            }
            
            self.listMes = self.msgRef.child(self.roomName);
            
            self.listMes.observeEventType(.Value, withBlock:{
                (snapshot) in
                if (snapshot.childrenCount > 0){
                    let messageContentArr = snapshot.value as! Dictionary<String, AnyObject>
                    self.messages = [JSQMessage]()
                    messageContentArr.forEach({ (messageContent: (String, AnyObject)) in
                        
                    var sender = "Server"
                    if messageContent.1["SenderId"] != nil{
                        sender = (messageContent.1["SenderId"] as? String != self.userLogin) ? "Server" : self.senderId
                    }
                    let message = JSQMessage(senderId: sender, displayName: "Test", text: messageContent.1["Message"] as! String)
                    self.messages += [message]
                    
                    })
                    self.reloadMessagesView()
                }
                
                }) { (error) in
                    print(error.localizedDescription)
            }

            
        })
        
        
    }
    
    func setup() {
        self.senderId = UIDevice.currentDevice().identifierForVendor?.UUIDString
        self.senderDisplayName = UIDevice.currentDevice().identifierForVendor?.UUIDString
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.messages.count
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, messageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageData! {
        let data = self.messages[indexPath.row]
        return data
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, didDeleteMessageAtIndexPath indexPath: NSIndexPath!) {
        self.messages.removeAtIndex(indexPath.row)
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageBubbleImageDataSource! {
        let data = messages[indexPath.row]
        switch(data.senderId) {
        case self.senderId:
            return self.outgoingBubble
        default:
            return self.incomingBubble
        }
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, avatarImageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageAvatarImageDataSource! {
        return nil
    }
    
    override func didPressSendButton(button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: NSDate!) {
        
        
        //let message = JSQMessage(senderId: senderId, senderDisplayName: senderDisplayName, date: date, text: text)
        //self.messages += [message]
        
        let newMes = self.listMes.childByAutoId()
        
        let mesText = text as String!
        
        let mesItem = [ // 2
            "SenderId": self.userLogin!,
            "Message": mesText!        ]
        newMes.setValue(mesItem) // 3
        
        self.finishSendingMessage()
    }
    
    override func didPressAccessoryButton(sender: UIButton!) {
        
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

