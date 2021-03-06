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
import Dispatch

class CircularProgreeBarController: UIViewController {
    
    @IBOutlet weak var mScrollView: UIScrollView!
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var timerLabel: UILabel!
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
    var to : Float = 0.0
    var score : Int = 0
    
    var seconds = 50 //86400

    var timer:Timer?
    var isTimerRunning = false
    var counter = 0
    let sharedPreferences = UserDefaults.standard
   
    override func viewDidLoad() {
        super.viewDidLoad()
        self.db = Database.database().reference()
        
        //checkSharedPreferences()
        progressBar()
        
    }
    override func viewDidAppear(_ animated: Bool) {
        checkSharedPreferences()
    }
    func progressBar() {
        
        CircularProgress.trackColor = UIColor.lightGray
        CircularProgress.progressColor = UIColor.init(displayP3Red: 255, green: 0, blue: 0, alpha: 0.90)
        
    }
    
    func checkSharedPreferences()
    {
        if (sharedPreferences.object(forKey: "From") == nil)
        {
            print("No value")
        }
        else
        {
            self.from = sharedPreferences.float(forKey: "From")
            print("From value from sharedpreferences ---------> \(from)")
            
            if (from == 1.0)
            {
                CircularProgress.setProgressWithAnimation(duration: 1.0, value: 0, from: 0)
            }
            else{
                CircularProgress.setProgressWithAnimation(duration: 1.0, value: from, from: 0)
            }
            
        }
        if (sharedPreferences.object(forKey: "Habit") == nil || sharedPreferences.object(forKey: "Name") == nil) {
            habit = "Habit"
            name = "Name"
            print("No name or habit found")
        }
        else {
            self.habit = sharedPreferences.string(forKey: "Habit")!
            self.name = sharedPreferences.string(forKey: "Name")!
            print("Habit: \(habit))")
            nameLabel.text = "\(name) your habit is to \(habit)"
            getHabitData()
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
                print("\(snapshot.childrenCount) habits found.")
                for key in subHabits!
                {
                    let sub = self.nullToNil(value: key)
                    
                    print(">>>>>>>>>>>\(self.subHabit.count)")
                    if(sub != nil)
                    {
                        if (self.subHabit.count > 3)
                        {
                            self.subHabit.remove(at: 0)
                        }
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
        let wd = Int(mScrollView.frame.width)/2
        let ht = Int(mScrollView.frame.height)/2 - 50
//        print("<<<<<<<<<,,\(numberOfRows)")
//        print("<<<<<<<<<<<< \(numberOfButtons) llll")
        for _ in 1...numberOfRows
        {
            px = 0
            if(count < numberOfButtons/2)
            {
                for j in 0...numberOfButtons/2
                {
                    
//                    print("Widht \(wd) &&&& height \(ht)")
                    count += 1
                    let Button = UIButton()
                    Button.tag = count
                    Button.layer.cornerRadius = 10
                    Button.layer.borderWidth = 3
                    Button.layer.borderColor = UIColor.black.cgColor
                    Button.frame = CGRect(x: px, y: py, width: wd, height: ht)
                    Button.backgroundColor = UIColor.init(displayP3Red: 0.0, green: 128.0, blue: 135.0, alpha: 0.50)
                    Button.setTitle("\(subHabit[j]) ", for: .normal)
                    Button.addTarget(self, action: #selector(HabitButtons), for: .touchUpInside)
                    mScrollView.addSubview(Button)
                    px = px + wd
                    
                }
            }
            else{
                
                 for j in numberOfButtons/2...numberOfButtons-1
                 {
                    count += 1
                    let Button = UIButton()
                     //Button.removeFromSuperview()
                    Button.tag = count
                    Button.layer.cornerRadius = 10
                    Button.layer.borderWidth = 3
                    Button.layer.borderColor = UIColor.black.cgColor
                    Button.frame = CGRect(x: px, y: py, width: wd, height: ht)
                    Button.backgroundColor = UIColor.init(displayP3Red: 0.0, green: 128.0, blue: 135.0, alpha: 0.50)
                    Button.setTitle("\(subHabit[j])", for: .normal)
                    Button.addTarget(self, action: #selector(HabitButtons), for: .touchUpInside)
                    mScrollView.addSubview(Button)
                   
                    px = px + wd
                    print("Second WIDTH.........\(mScrollView.frame.width)")
                }
            }
            py =  Int(mScrollView.frame.height)-250
        }
         mScrollView.contentSize = CGSize(width: px, height: py)
    }
    
    @objc func HabitButtons(sender: UIButton) {
        
        print("\(sender.tag) is Selected")
        sender.isEnabled = false
        sender.alpha = 0.50
        sender.isHidden = true
        let title = sender.currentTitle
        sharedPreferences.set(title, forKey: "Title")
        let sec = 86400
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(sec)) {
            sender.isEnabled = true
            sender.alpha = 1.0
            sender.isHidden = false
            
        }
        
        print(sender.currentTitle!)
    self.db.child("Friends").child(String(name)).child("HabitsDone").child("Habit-\(sender.tag)").setValue(sender.currentTitle)
        buttonCount += 1
        updateScore()
        
    }
    
    func updateScore()
    {
        print("From value ----> \(from)")
        print("=========")
        if (from == 1.0)
        {
            self.counter = counter + 1
            self.db.child("Friends").child(String(name)).child("timesDoneHabit").setValue(self.counter)
            self.from = 0.0
            updateScore()
        }
        else
        {
            CircularProgress.setProgressWithAnimation(duration: 1.0, value: from+0.25, from: from)
            score = score + 5
            print("Score ---> \(score)")
            self.db.child("Friends").child(String(name)).child("Score").setValue(score)
            from = from + 0.25
            let progress = from * 100
            self.db.child("Friends").child(String(name)).child("Progress").setValue("\(progress)%")
            self.db.child("Friends").child(String(name)).child("timesDoneHabit").setValue(self.counter)
        }
        
        sharedPreferences.set(self.from, forKey:"From")
        print("######")
        print("\(self.from)")
        
    }
}
