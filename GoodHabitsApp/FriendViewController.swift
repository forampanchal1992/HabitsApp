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
    

    @IBOutlet weak var subHabitFriendOneLabel: UILabel!
    @IBOutlet weak var subHabitFriendTwoLabel: UILabel!
    @IBOutlet weak var subHabitFriendThreeLabel: UILabel!
    
    @IBOutlet weak var FriendCircularProgress: FriendProgressBarView!
    
    var db:DatabaseReference!
    var name : String = ""
    var friend : String = ""
    var friendName : String = ""
    @IBOutlet weak var friendNameLabel: UILabel!
    
     var subHabitsArray : [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.db = Database.database().reference()
//        self.connectFriend()
        let sharedPreferences = UserDefaults.standard
        self.name = sharedPreferences.string(forKey: "Name")!
        self.friend = sharedPreferences.string(forKey:"Friend")!
        
        if (friend == nil) {
            friend = "Name"
            print("No name found")
            self.connectFriend()
        }
        else {
            print("Friend: \(self.friend)")
            friendNameLabel.text = "\(self.friend)"
        }
        
        FriendCircularProgress.trackColor = UIColor.white
        FriendCircularProgress.progressColor = UIColor.purple
        FriendCircularProgress.setProgressWithAnimation(duration: 1.0, value: 0.3)
        
    }

    @objc func animateProgress(){
        let cP = self.view.viewWithTag(101) as! CircularProgressBarView
        cP.setProgressWithAnimation(duration: 1.0, value: 0.7)
        
    }
    
    func connectFriend() {
        let alert = UIAlertController(title: "Join a Friend", message: "Enter Friend's name",preferredStyle: .alert)
        
        alert.addTextField { (friendToConnect) in
            friendToConnect.text = ""
            friendToConnect.placeholder = "Enter name here"
        }
        
        alert.addAction(UIAlertAction(title: "Join", style: .default, handler: { [weak alert] (_) in
            let friendToConnect = alert?.textFields![0] // Force unwrapping because we know it exists.
            print("Text field: \(friendToConnect!.text)")
            self.friendName = (friendToConnect?.text)!
            
            self.db?.child("Friends").child(String(self.friendName)).observe(.value, with: { (snapshot) in
                
                print("=============\(snapshot)")
                
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
                    
                }
                else
                {
                    print("\(self.friendName) is not found")                    //                    let friendNotFoundAlert = UIAlertController(title: "No person found", message: "No person with id \(self.friendName)",preferredStyle: .alert)
                    //                    friendNotFoundAlert.addAction(UIAlertAction(title: "Try again", style: .default, handler: nil))
                }
            })
        }))
        self.present(alert, animated: true)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alert.addAction(cancelAction)
    }


}
