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
        let numberOfRows = subHabit.count / 2
        let numberOfButtons = subHabit.count
        
        for _ in 1...numberOfRows
        {
            px = 0
            if(count < numberOfButtons/2)
            {
                for j in 0...numberOfButtons/2
                {
                    
                    count += 1
                    let Button = UIButton()
                    Button.tag = count
                    Button.frame = CGRect(x: px+(Int(mScrollView.frame.width)/10 - 10), y: py+10, width: (Int(mScrollView.frame.width)/2 - (Int(mScrollView.frame.width)/10)), height: (Int(mScrollView.frame.width)/2 - (Int(mScrollView.frame.width)/10)))
                    Button.backgroundColor = UIColor.lightGray
                    Button.setTitle("\(subHabit[j]) ", for: .normal)
                    Button.addTarget(self, action: #selector(scrollButtonAction), for: .touchUpInside)
                    mScrollView.addSubview(Button)
                    px = px + Int(mScrollView.frame.width) - 200
                    print("WIDTH.........\(mScrollView.frame.width)")
                    print("px........\(px)")
                }
            }
            else{

                 for j in numberOfButtons/2...numberOfButtons-1
                 {
                    count += 1
                    let Button = UIButton()
                    Button.tag = count
                    Button.frame = CGRect(x: px+(Int(mScrollView.frame.width)/10 - 10), y: py+10, width: (Int(mScrollView.frame.width)/2 - (Int(mScrollView.frame.width)/10)), height: (Int(mScrollView.frame.width)/2 - (Int(mScrollView.frame.width)/10)))
                    Button.backgroundColor = UIColor.lightGray
                    Button.setTitle("\(subHabit[j])", for: .normal)
                    Button.addTarget(self, action: #selector(scrollButtonAction), for: .touchUpInside)
                    mScrollView.addSubview(Button)
                    px = px + Int(mScrollView.frame.width) - 200
                    print("Second WIDTH.........\(mScrollView.frame.width)")
                }
            }
            py =  Int(mScrollView.frame.height)-250
        }
         mScrollView.contentSize = CGSize(width: px, height: py)
    }
    
    @objc func scrollButtonAction(sender: UIButton) {
        print("\(sender.tag) is Selected")
        sender.isEnabled = false
        print(sender.currentTitle!)
    self.db.child("Friends").child(String(name)).child("HabitsDone").child("Habit-\(sender.tag)").setValue(sender.currentTitle)
        buttonCount += 1
//        print("Button click count : \(buttonCount)")
    
        if (buttonCount == 1)
        {
            CircularProgress.setProgressWithAnimation(duration: 1.0, value: 0.25, from: from)
            self.db.child("Friends").child(String(name)).child("Progress").setValue("25%")
            from = from + 0.25
        }
        else if (buttonCount == 2)
        {
            CircularProgress.setProgressWithAnimation(duration: 1.0, value: 0.50, from: from)
            self.db.child("Friends").child(String(name)).child("Progress").setValue("50%")
            from = from + 0.50
        }
        else if(buttonCount == 3)
        {
            CircularProgress.setProgressWithAnimation(duration: 1.0, value: 0.75, from: from)
            self.db.child("Friends").child(String(name)).child("Progress").setValue("75%")
            from = from + 0.75
        }
        else if(buttonCount == 4)
        {
            CircularProgress.setProgressWithAnimation(duration: 1.0, value: 1.0, from: from)
            self.db.child("Friends").child(String(name)).child("Progress").setValue("100%")
        }
        let sharedPreferences = UserDefaults.standard
        sharedPreferences.set(self.from, forKey:"From")
    }
}
