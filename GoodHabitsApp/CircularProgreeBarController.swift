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
        
        let cp = CircularProgressBarView(frame : CGRect(x: 10.0, y: 10.0, width: 100.0, height: 100.0))
        cp.trackColor = UIColor.red
        cp.progressColor = UIColor.yellow
        cp.tag = 101
        self.view.addSubview(cp)
        cp.center = self.view.center
        
        self.perform(#selector(animateProgress), with: nil, afterDelay: 2.0)
        CircularProgress.trackColor = UIColor.white
        CircularProgress.progressColor = UIColor.purple
        CircularProgress.setProgressWithAnimation(duration: 1.0, value: 0.3)
        
    }
    
    @objc func animateProgress(){
        
        let cP = self.view.viewWithTag(101) as! CircularProgressBarView
        cP.setProgressWithAnimation(duration: 1.0, value: 0.7)
        
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
