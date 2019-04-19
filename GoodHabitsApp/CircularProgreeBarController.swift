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
        
        var buttonY: CGFloat = 20  // our Starting Offset, could be 0
        for villain in subHabit {
            print("TEst button.....")
            
            
            let villainButton = UIButton(frame: CGRect(x: 100, y: buttonY, width: 250, height: 30))
            buttonY = buttonY + 250  // we are going to space these UIButtons 50px apart
            
            villainButton.layer.cornerRadius = 10  // get some fancy pantsy rounding
            villainButton.backgroundColor = UIColor.darkGray
            villainButton.setTitle("Button for Villain: \(villain)", for: UIControl.State.normal) // We are going to use the item name as the Button Title here.
            villainButton.titleLabel?.text = "\(villain)"
            villainButton.addTarget(self, action: "villainButtonPressed:", for: UIControl.Event.touchUpInside)
            
            self.view.addSubview(villainButton)  // myView in this case is the view you want these buttons added
        }
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
