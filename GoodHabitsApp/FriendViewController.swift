//
//  FriendViewController.swift
//  GoodHabitsApp
//
//  Created by Himauli Patel on 2019-04-14.
//  Copyright © 2019 Foram Panchal. All rights reserved.
//

import UIKit
import FirebaseDatabase
import Firebase

class FriendViewController: UIViewController {
    
    @IBOutlet weak var FriendCircularProgress: FriendProgressBarView!
    
    var db:DatabaseReference!
    var name : String = ""
    var friend : String = ""
    var friendName : String = ""
    var from : Float = 0.0
    var progress : String = ""
    @IBOutlet weak var friendNameLabel: UILabel!
    
    @IBOutlet weak var percentageLabel: UILabel!
    var subHabitsArray : [String] = []
    let sharedPreferences = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBarItem.badgeValue = nil
        
        self.db = Database.database().reference()
        self.name = sharedPreferences.string(forKey: "Name")!
        
//        getFriendData()
        if (sharedPreferences.object(forKey: "Friend") == nil)
        {
            print("Empty =========")
            checkFriendFromFirebase()
            self.connectFriend()
        }
        else
        {
            print("Not Empty=========")
            self.friend = sharedPreferences.string(forKey:"Friend")!
            print("Friend: \(self.friend)")
            friendNameLabel.text = "\(self.friend)"
            getFriendData()
        }
        
        checkFriendFromFirebase()
    }
    
    @IBAction func joinFriendClicked(_ sender: Any) {
        connectFriend()
    }
    
    func checkFriendFromFirebase()
    {
        self.db?.child("Friends").child(String(self.name)).observe(.value, with: { (snapshot) in
            if(snapshot.exists())
            {
                let snap = snapshot.value as! NSDictionary
                let friendConnected = snap["Connected with"] as! String
                if (friendConnected != nil)
                {
                    self.friendNameLabel.text = friendConnected
                }
                
            }
        })
    }
    
    func checkSharedPreferences()
    {
        
        if (sharedPreferences.object(forKey: "Name") == nil)
        {
            print("Name empty =====")
            if (sharedPreferences.object(forKey: "Friend") == nil)
            {
                print("Empty =========")
                checkFriendFromFirebase()
                self.connectFriend()
            }
            else
            {
                print("Not Empty=========")
                self.friend = sharedPreferences.string(forKey:"Friend")!
                print("Friend: \(self.friend)")
                friendNameLabel.text = "\(self.friend)"
                getFriendData()
            }
        }
    }
    func progressBar()
    {
        FriendCircularProgress.trackColor = UIColor.lightGray
        FriendCircularProgress.progressColor = UIColor.init(displayP3Red: 255, green: 0, blue: 0, alpha: 0.50)
        //        FriendCircularProgress.setProgressWithAnimation(duration: 1.0, value: 0.0, from: from)
    }
    
    func connectFriend() {
        let alert = UIAlertController(title: "Join a Friend", message: "Enter Friend's name",preferredStyle: .alert)
        
        alert.addTextField { (friendToConnect) in
            friendToConnect.text = ""
            friendToConnect.placeholder = "Enter name here"
        }
        
        alert.addAction(UIAlertAction(title: "Join", style: .default, handler: { [weak alert] (_) in
            let friendToConnect = alert?.textFields![0]
            self.friendName = (friendToConnect?.text)!
            
            self.db?.child("Friends").child(String(self.friendName)).observe(.value, with: { (snapshot) in
                if(snapshot.exists())
                {
                    self.friendNameLabel.text = self.friendName
                    
                    let sharedPreferences = UserDefaults.standard
                    sharedPreferences.set(self.friendName, forKey:"Friend")
                    
                    print("\(self.friendName) found")
                    
                    self.db.child("Friends").child(self.name).child("areFriendsConnected").setValue(true)
                    self.db.child("Friends").child(self.name).child("Connected with").setValue(self.friendName)
                self.db.child("Friends").child(String(self.friendName)).child("areFriendsConnected").setValue(true)
                    self.db.child("Friends").child(String(self.friendName)).child("Connected with").setValue(self.name)
                
                    self.progressBar()
                    
                }
                else
                {
                    self.friendNameLabel.text = "No friend Connected"
                    print("\(self.friendName) is not found")                    //                    let friendNotFoundAlert = UIAlertController(title: "No person found", message: "No person with id \(self.friendName)",preferredStyle: .alert)
                    //                    friendNotFoundAlert.addAction(UIAlertAction(title: "Try again", style: .default, handler: nil))
                }
            })
        }))
        self.present(alert, animated: true)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alert.addAction(cancelAction)
    }
    
    func getFriendData() {
        print("Exist")
        self.db?.child("Friends").child(String(name)).observe(.value, with: { (snapshot) in
            
            if (snapshot.exists())
            {
                print("Exist 1")
                let snap = snapshot.value as! NSDictionary
                 if snapshot.hasChild("Connected with")
                 {
                    print("Exist 2")
                    let connectedFriend = snap["Connected with"] as! String
                    if (connectedFriend != nil)
                    {
                        print("Exist 3")
                        self.db?.child("Friends").child(String(connectedFriend)).observe(.value, with: { (snapshot) in
                            
                            if (snapshot.exists())
                            {
                                print("Exist 4")
                                print("^^^^^^^\(snapshot)")
                                let friendSnap = snapshot.value as! NSDictionary
                                let friendHabit = friendSnap["Habit"] as! String
                                self.friendNameLabel.text = "\(connectedFriend)'s habit is: \(friendHabit)"
                                if snapshot.hasChild("Progress")
                                {
                                    let friendProgress = friendSnap["Progress"] as! String
                                    
                                    if (friendProgress == "25.0%")
                                    {
                                        print("Progress: \(friendProgress)")
                                        self.progressBar()
                                        self.FriendCircularProgress.setProgressWithAnimation(duration: 1.0, value: 0.25, from: 0.0)
                                        self.percentageLabel.text = friendProgress
                                    }
                                    else if (friendProgress == "50.0%")
                                    {
                                        print("Progress: \(friendProgress)")
                                        self.progressBar()
                                        self.FriendCircularProgress.setProgressWithAnimation(duration: 1.0, value: 0.50, from: 0.25)
                                        self.percentageLabel.text = friendProgress
                                    }
                                    else if (friendProgress == "75.0%")
                                    {
                                        print("Progress: \(friendProgress)")
                                        self.progressBar()
                                        self.FriendCircularProgress.setProgressWithAnimation(duration: 1.0, value: 0.75, from: 0.50)
                                        self.percentageLabel.text = friendProgress
                                    }
                                    else if (friendProgress == "100.0%")
                                    {
                                        print("Progress: \(friendProgress)")
                                        self.progressBar()
                                        self.FriendCircularProgress.setProgressWithAnimation(duration: 1.0, value: 1.0, from: 0.75)
                                        self.percentageLabel.text = friendProgress
                                        self.db?.child("Friends").child(String(self.name)).child("isFriendDone").setValue(true)
                                    }
                                }
                            }
                        })
                    }
                }
              
                else
                {
                    self.connectFriend()
                }
            }
        })
    }
}
