//
//  CircularProgreeBarController.swift
//  GoodHabitsApp
//
//  Created by Foram Panchal on 2019-04-14.
//  Copyright © 2019 Foram Panchal. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class CircularProgreeBarController: UIViewController {
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var subHabitOneLabel: UILabel!
    @IBOutlet weak var subHabitTwoLabel: UILabel!
    @IBOutlet weak var subHabitThreeLabel: UILabel!
    
    var db:DatabaseReference!
    
    var habit : String = ""
    var name : String = ""
    var subHabitsArray : [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.db = Database.database().reference()
        
        let sharedPreferences = UserDefaults.standard
        self.habit = sharedPreferences.string(forKey: "Habit")!
        self.name = sharedPreferences.string(forKey: "Name")!
        
        if (habit == nil || name == nil) {
            habit = "Habit"
            name = "Name"
            print("No name or habit found")
        }
        else {
            print("Habit: \(habit))")
            nameLabel.text = "\(name) your habit is to \(habit)"
            getHabitData()
        }
        
        // Do any additional setup after loading the view.
    }
    
    func getHabitData()
    {
        self.db?.child("Habits").observe(.value, with: { (snapshot) in
            
            print("Sub-Habits are: \(snapshot.value)")
            let subHabits = snapshot.value as? NSDictionary
            
            if(snapshot.exists())
            {
                print("\(snapshot.childrenCount) habis found.")
                for (key, value) in subHabits!{
                    print("Key : \(key) and Value: \(value)")
                    let valueOfKey = value as! NSArray
                    
                    for v in valueOfKey
                    {
                        print("Value ::::: \(v)")
                    }
                }
            }
        })
    }

}
