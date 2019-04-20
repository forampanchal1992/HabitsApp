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
    
    var inputNameText : String = ""
    var name : String = ""
    var db:DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.db = Database.database().reference()
        
        let sharedPreferences = UserDefaults.standard
        self.name = (sharedPreferences.string(forKey: "Name") ?? inputNameText)!

        if (name == nil) {
            name = "Name"
            print("No name found")
        }
        else {
            print("Name: \(name)")
            inputName.text = "\(name)"
        }
    }
    
    @IBAction func NextButtonClicked(_ sender: Any) {
        self.inputNameText = inputName.text!
        let data = ["Name" : inputNameText,"areFriendsConnected" : false] as [String : Any]
        self.db.child("Friends").child(String(inputNameText)).setValue(data)
        
        let sharedPreferences = UserDefaults.standard
        sharedPreferences.set(self.inputNameText, forKey:"Name")
        print("Saved \(self.inputNameText) to shared preferences!")
    }

    
}

