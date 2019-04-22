//
//  ScoreBoardController.swift
//  GoodHabitsApp
//
//  Created by Himauli Patel on 2019-04-20.
//  Copyright © 2019 Foram Panchal. All rights reserved.
//

import UIKit

import FirebaseDatabase
import Firebase


class ScoreBoardController: UIViewController {

    @IBOutlet weak var ScoreLabel: UILabel!
    @IBOutlet weak var FriendScoreLabel: UILabel!
    
    var db:DatabaseReference!
    var friend : String = ""
    var name : String = ""
    
    let sharedPreferences = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.db = Database.database().reference()
        
        checkSharedPreferences()

        // Do any additional setup after loading the view.
    }
    
    func checkSharedPreferences()
    {
        
        if (sharedPreferences.object(forKey: "Friend") == nil || sharedPreferences.object(forKey: "Name") == nil) {
            print("No name or friend found")
        }
        else {
            self.friend = sharedPreferences.string(forKey: "Friend")!
            self.name = sharedPreferences.string(forKey: "Name")!
            print("Friend: \(friend))")
//            ScoreLabel.text = name
//            FriendScoreLabel.text = friend
            getScore()
            getFriendScore()
        }
    }
    func getScore()
    {
    
        self.db?.child("Friends").child(String(name)).observe(.value, with: { (snapshot) in
            
            if (snapshot.exists())
            {
                let snap = snapshot.value as! NSDictionary
                let myScore = snap["Score"] as! Int
                self.ScoreLabel.text = "You have \(myScore) points"
            }
        })
    }
    
    func getFriendScore()
    {
        self.db?.child("Friends").child(String(friend)).observe(.value, with: { (snapshot) in
            
            if (snapshot.exists())
            {
                let snap = snapshot.value as! NSDictionary
                print("Score ----- \(snap["Score"])")
                let myScore = snap["Score"] as! Int
                
                self.FriendScoreLabel.text = "\(self.friend) has \(myScore) points"
            }
        })
    }
    
}
