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
    @IBOutlet weak var accessCodeLabel: UILabel!
    
    var db:DatabaseReference!
    var handle: DatabaseHandle?
    var generatedCode : String = ""
   // var accessCode:String = ""
    
    var name : String = ""
    var code : String = ""
    let accessCode = arc4random()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.db = Database.database().reference()
        
        let sharedPreferences = UserDefaults.standard
        self.name = sharedPreferences.string(forKey: "Name")!
        self.code = sharedPreferences.string(forKey: "Access Code")!
        
        if (name == nil) {
            name = "Name"
            print("Enter your name")
        }
        else {
            print("Name: \(name) And Code: \(code)")
            nameLabel.text = "Hello \(name)"
            accessCodeLabel.text = "Access Code : \(code)"
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func askFriend(_ sender: Any) {
        
        let alert = UIAlertController(title: "Wait for friend to join", message: "generateCode()", preferredStyle: .alert)
         self.db.child("Friends").child("Access Code").child(String(accessCode)).child("Name1").setValue(name)
        
        handle = db?.child("Friends").child("Access Code").child(String(accessCode)).child("areFriendsConnected").observe(.value, with: { (snapshot) in
            
//            print("Snapshot: \(snapshot)")
            
            let checker:Bool!
            checker = snapshot.value as! Bool
            
            print("Checker: \(checker!)")
            
            if (checker == true)
            {
                // navigate to next page
            }
        })
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: nil))
//        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
        
        self.present(alert, animated: false)
    }
    

    @IBAction func helpFriendClicked(_ sender: Any) {
      
        var inputCode : String = ""
        
        let alert = UIAlertController(title: "Join a Friend", message: "Enter Friend's name and code",preferredStyle: .alert)
        
        alert.addTextField { (textField) in
            textField.text = ""
            textField.placeholder = "Enter name here"
        }
        
        alert.addAction(UIAlertAction(title: "Join", style: .default, handler: { [weak alert] (_) in
            let textField = alert?.textFields![0] // Force unwrapping because we know it exists.
            print("Text field: \(textField!.text)")
            inputCode = (textField?.text)!
            
            self.db?.child("Friends").child(String(inputCode)).observe(.value, with: { (snapshot) in
                
                print("=============\(snapshot)")
                
                let friends = snapshot.value as? NSDictionary
                let newFriend = friends!["Name"] as? String
                
                if (newFriend == inputCode)
                {
                    
                    self.db.child("Friends").child(self.name).child("areFriendsConnected").setValue(true)
                    self.db.child("Friends").child(self.name).child("Connected with").setValue(inputCode)
                    self.db.child("Friends").child(String(inputCode)).child("areFriendsConnected").setValue(true)
                    self.db.child("Friends").child(String(inputCode)).child("Connected with").setValue(self.name)
                }
                
            })
            
        }))
        
        
        self.present(alert, animated: true)
       
    }
    
}
