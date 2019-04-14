//
//  ConnectViewController.swift
//  GoodHabitsApp
//
//  Created by Foram Panchal on 2019-04-07.
//  Copyright © 2019 Foram Panchal. All rights reserved.
//

import UIKit
import FirebaseDatabase
import Firebase

class ConnectViewController: UIViewController {

    @IBOutlet weak var nameLabel: UILabel!
    
    var db:DatabaseReference!
    var handle: DatabaseHandle?
    var generatedCode : String = ""
    var habitsSnapshot = [String:String]()
   // var accessCode:String = ""
    
    var name : String = ""
    var code : String = ""
    var friendName : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.db = Database.database().reference()
        
        let sharedPreferences = UserDefaults.standard
        self.name = sharedPreferences.string(forKey: "Name")!
        
        if (name == nil) {
            name = "Name"
            print("No name found")
        }
        else {
            print("Name: \(name) And Code: \(code)")
            nameLabel.text = "Hello \(name)"
        }
        
        getData()
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func helpFriendClicked(_ sender: Any) {
      
        let alert = UIAlertController(title: "Join a Friend", message: "Enter Friend's name and code",preferredStyle: .alert)
        
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
                    print("\(self.friendName) found")
                    let friends = snapshot.value as? NSDictionary
                    let newFriend = friends!["Name"] as? String
    
                    self.db.child("Friends").child(self.name).child("areFriendsConnected").setValue(true)
                    self.db.child("Friends").child(self.name).child("Connected with").setValue(self.friendName)
                self.db.child("Friends").child(String(self.friendName)).child("areFriendsConnected").setValue(true)
                    self.db.child("Friends").child(String(self.friendName)).child("Connected with").setValue(self.name)
                    
                }
                else
                {
                    print("\(self.friendName) is not found")
//                    let friendNotFoundAlert = UIAlertController(title: "No person found", message: "No person with id \(self.friendName)",preferredStyle: .alert)
//                    friendNotFoundAlert.addAction(UIAlertAction(title: "Try again", style: .default, handler: nil))
                }
            })
        }))
        self.present(alert, animated: true)
    }
}
