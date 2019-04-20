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
    
    @IBOutlet weak var mScrollView: UIScrollView!
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
    
    var buttonCount = 0
    var progress = 0
    var from : Float = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.db = Database.database().reference()
        
        checkSharedPreferences()
        progressBar()
    }
    
    func progressBar() {
        CircularProgress.trackColor = UIColor.white
        CircularProgress.progressColor = UIColor.gray
//        CircularProgress.setProgressWithAnimation(duration: 1.0, value: 0.0, from: from)
        
    }
    
    func checkSharedPreferences()
    {
        let sharedPreferences = UserDefaults.standard
        self.habit = sharedPreferences.string(forKey: "Habit")!
        self.name = sharedPreferences.string(forKey: "Name")!
        self.from = sharedPreferences.float(forKey: "From")
        
        print("From value : \(self.from)")
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
    }
//    @objc func animateProgress(){
//
//        let cP = self.view.viewWithTag(101) as! CircularProgressBarView
//
//        if (progress == 0)
//        {
//            cP.setProgressWithAnimation(duration: 3.0, value: 0.0, from: 0.0)
//        }
//    }
//
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
                self.dynamicButton()
            }
        })
        
    }
    
    func dynamicButton()
    {
        mScrollView.isScrollEnabled = true
        mScrollView.isUserInteractionEnabled = true
        
        var count = 0
        var px = 0
        var py = 0
        
        for _ in 1...subHabit.count
        {
//            print("$$$$$")
            for j in subHabit
            {
                if(count < subHabit.count)
                {
                    count += 1
                    let Button = UIButton()
                    Button.tag = count
                    Button.frame = CGRect(x: px+100, y: py+10, width: 100, height: 45)
                    Button.backgroundColor = UIColor.blue
                    Button.setTitle("\(j) ", for: .normal)
                    Button.addTarget(self, action: #selector(scrollButtonAction), for: .touchUpInside)
                    mScrollView.addSubview(Button)
                    px = px + Int(mScrollView.frame.width)/2 - 30
                }
            }
        }
         mScrollView.contentSize = CGSize(width: px, height: py)
    }
    
    @objc func scrollButtonAction(sender: UIButton) {
        print("\(sender.tag) is Selected")
        sender.isEnabled = false
        buttonCount += 1
//        print("Button click count : \(buttonCount)")
    
        if (buttonCount == 1)
        {
            CircularProgress.setProgressWithAnimation(duration: 1.0, value: 0.33, from: from)
            self.db.child("Friends").child(String(name)).child("Progress").setValue("33%")
            from = from + 0.33
        }
        else if (buttonCount == 2)
        {
            CircularProgress.setProgressWithAnimation(duration: 1.0, value: 0.66, from: from)
            self.db.child("Friends").child(String(name)).child("Progress").setValue("66%")
            from = from + 0.66
        }
        else if(buttonCount == 3)
        {
            CircularProgress.setProgressWithAnimation(duration: 1.0, value: 1.0, from: from)
            self.db.child("Friends").child(String(name)).child("Progress").setValue("Completed - 100%")
        }
        let sharedPreferences = UserDefaults.standard
        sharedPreferences.set(self.from, forKey:"From")
    }
}
