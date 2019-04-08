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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.db = Database.database().reference()
        
        let sharedPreferences = UserDefaults.standard
        var name = sharedPreferences.string(forKey: "Name")
        
        if (name == nil) {
            // by default, the strating city is Vancouver
            name = "Name"
            print("Enter your name")
        }
        else {
            print("Name: \(name)")
            nameLabel.text = "Hello \(name!)"
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
        
        let alert = UIAlertController(title: "Wait for friend to join", message: generateCode(), preferredStyle: .alert)
        
//        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: nil))
//        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
        
        self.present(alert, animated: true)
    }
    

    @IBAction func helpFriendClicked(_ sender: Any) {
      
        let alert = UIAlertController(title: "Enter code", message: "Enter a code to join a friend",preferredStyle: .alert)
        
        alert.addTextField { (textField) in
            textField.text = ""
            textField.placeholder = "Enter code here"
        }
        
        // 3. Grab the value from the text field, and print it when the user clicks OK.
        alert.addAction(UIAlertAction(title: "Join", style: .default, handler: { [weak alert] (_) in
            let textField = alert?.textFields![0] // Force unwrapping because we know it exists.
            print("Text field: \(textField!.text)")
        }))
        
        self.present(alert, animated: true)
        
    self.db.child("Quiz").child("quizId").child( "accessCodeToApply" ).child("hasGameStarted").setValue( true )
    }
    
    func generateCode() -> String{
        let accessCode = arc4random()
        print("Access Code : ",accessCode)
        
        self.db.child("Access Code").child(String(accessCode)).setValue(accessCode)
        return String(accessCode)
    }
    
}
