//
//  ViewController.swift
//  GoodHabitsApp
//
//  Created by Foram Panchal on 2019-04-07.
//  Copyright © 2019 Foram Panchal. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class ViewController: UIViewController {

    //MARK: OUTLETS
    @IBOutlet weak var askNameLabel: UILabel!
    @IBOutlet weak var inputName: UITextField!
    
    //Variables
    var inputNameText : String = ""
    let accessCode = arc4random()
   
    var db:DatabaseReference!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.db = Database.database().reference()
        
        
    }
    
    @IBAction func NextButtonClicked(_ sender: Any) {
        self.inputNameText = inputName.text!
        
        print("Access Code : ",accessCode)
        
        let data = ["Access Code" : accessCode,"Name" : inputNameText,"areFriendsConnected" : false] as [String : Any]
//        self.db.child("Friends").child("Access Code").child(String(accessCode)).setValue(data)
        self.db.child("Friends").child(String(inputNameText)).setValue(data)
        let sharedPreferences = UserDefaults.standard
        sharedPreferences.set(self.inputNameText, forKey:"Name")
        sharedPreferences.set(self.accessCode, forKey: "Access Code")
        print("Saved \(self.inputNameText) and \(self.accessCode) to shared preferences!")
        
    }

    
}

