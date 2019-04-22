//
//  TabBarController.swift
//  GoodHabitsApp
//
//  Created by Himauli Patel on 2019-04-20.
//  Copyright © 2019 Foram Panchal. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class TabBarController: UITabBarController {

    var db:DatabaseReference!
    var friend : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.db = Database.database().reference()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let sharedPreferences = UserDefaults.standard
      
        if (sharedPreferences.object(forKey: "Friend") == nil)
        {
            print("Empty =========")
        }
        else
        {
            print("Not Empty=========")
            self.friend = sharedPreferences.string(forKey:"Friend")!
            checkProgressDone()
        }

    }
    
    func checkProgressDone()
    {
        self.db?.child("Friends").child(String(friend)).observe(.value, with: { (snapshot) in
            
            if (snapshot.exists())
            {
                let snap = snapshot.value as! NSDictionary
                if snapshot.hasChild("Progress")
                {
                    
                    let progress = snap["Progress"] as! String
                    if (progress == "100.0%")
                    {
                        self.tabBar.items![4].badgeValue = "1"
                    }
                    else
                    {
                        print("Not Done")
                    }
                }
                
            }
        })
    }

}
