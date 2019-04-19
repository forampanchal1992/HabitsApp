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
    
    @IBOutlet weak var CircularProgress: CircularProgressBarView!
    
    var db:DatabaseReference!
    
    var habit : String = ""
    var name : String = ""
    var subHabitsArray : [String] = []
    var subHabit : [String] = []
    
    var progress = 0
    
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
    
        CircularProgress.trackColor = UIColor.white
        CircularProgress.progressColor = UIColor.purple
        CircularProgress.setProgressWithAnimation(duration: 1.0, value: 0.3)
        
    }
    
    @objc func animateProgress(){
        
        let cP = self.view.viewWithTag(101) as! CircularProgressBarView
        
        if (progress == 0)
        {
            cP.setProgressWithAnimation(duration: 3.0, value: 0.9)
        }
    }
    
    func nullToNil(value : Any?) -> Any? {
        if value is NSNull {
            return nil
        } else {
            return value
        }
    }
    
    func getHabitData()
    {
        self.db?.child("Habits").child(String(habit)).observe(.value, with: { (snapshot) in
            
            print("Sub-Habits are: \(snapshot.value!)")
            let subHabits = snapshot.value as? NSMutableArray
            
            if(snapshot.exists())
            {
                print("\(snapshot.childrenCount) habis found.")
                
                for key in subHabits!
                {
                    let sub = self.nullToNil(value: key)
                    
                    if(sub != nil)
                    {
                        self.subHabit.append(sub as! String)
                    }
                }
                print("********")
                print("Subhabits : \(self.subHabit)")
            }
        })
    }
}
