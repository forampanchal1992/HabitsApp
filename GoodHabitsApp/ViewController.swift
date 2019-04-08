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
   
    var db:DatabaseReference!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.db = Database.database().reference()
        
        
    }
    
    @IBAction func NextButtonClicked(_ sender: Any) {
        self.inputNameText = inputName.text!
        
        let sharedPreferences = UserDefaults.standard
        sharedPreferences.set(self.inputNameText, forKey:"Name")
        //print("Saved \(self.inputNameText) to shared preferences!")
        
    }

   
}

