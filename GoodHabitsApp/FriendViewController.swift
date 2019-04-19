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
    var friendName : String = ""
    @IBOutlet weak var friendNameLabel: UILabel!
    
     var subHabitsArray : [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.db = Database.database().reference()
        
        let sharedPreferences = UserDefaults.standard
        self.name = sharedPreferences.string(forKey: "Name")!
        
        self.db?.child("Friends").child(String(name)).observe(.value, with:
        {(snapshot) in
//            print("ConnectedWith : \(snapshot)")
            
            if(snapshot.hasChild("connectedWith"))
            {
                print("Connected with \(snapshot)")
                let friend = snapshot.value(forKey: "connectedWith")
                print("Friend is --> \(friend as! String)")
            }
            else
            {
                print("Connecting........")
                self.connectFriend()
//                let friend = snapshot.value(forKey: "connectedWith")
//                print("Friend is --> \(friend as! String)")
            }
        })
//        let cp = CircularProgressBarView(frame : CGRect(x: 10.0, y: 10.0, width: 100.0, height: 100.0))
//        cp.trackColor = UIColor.red
//        cp.progressColor = UIColor.yellow
//        cp.tag = 101
//        self.view.addSubview(cp)
//        cp.center = self.view.center
//
//        self.perform(#selector(animateProgress), with: nil, afterDelay: 2.0)
        
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
                self.friendNameLabel.text = self.friendName
                if(snapshot.exists())
                {
                    print("\(self.friendName) found")
                    //                    let friends = snapshot.value as? NSDictionary
                    //                    let newFriend = friends!["Name"] as? String
                    
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
