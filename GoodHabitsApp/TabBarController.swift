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
        self.friend = sharedPreferences.string(forKey:"Friend")!
        
        if (friend == nil) {
            friend = "Name"
            print("No name found")
        }
        else
        {
            print("friend +++++ \(friend)")
            checkProgressDone()
        }
    }
    
    func checkProgressDone()
    {
        self.db?.child("Friends").child(String(friend)).observe(.value, with: { (snapshot) in
            
            if (snapshot.exists())
            {
                let snap = snapshot.value as! NSDictionary
                if snapshot.hasChild("isFriendDone")
                {
                    
                    let isFriendDone = snap["isFriendDone"] as! Bool
                    if (isFriendDone == true)
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
