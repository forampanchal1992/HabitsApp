//
//  ViewController.swift
//  GoodHabitsApp
//
//  Created by Foram Panchal on 2019-04-07.
//  Copyright © 2019 Foram Panchal. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class ViewController: UIViewController {

    //MARK: OUTLETS
    @IBOutlet weak var askNameLabel: UILabel!
    @IBOutlet weak var inputName: UITextField!
    
    var inputNameText : String = ""
    var name : String = ""
    var db:DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.db = Database.database().reference()
        
        let sharedPreferences = UserDefaults.standard
        self.name = (sharedPreferences.string(forKey: "Name") ?? inputNameText)!

        if (name == nil) {
            name = "Name"
            print("No name found")
        }
        else {
            print("Name: \(name)")
            inputName.text = "\(name)"
        }
        
//        competition()
    }
    
    @IBAction func NextButtonClicked(_ sender: Any) {
        
//        self.view.endEditing(true)
//        let data = ["Name" : inputNameText,"areFriendsConnected" : false] as [String : Any]
//        self.db.child("Friends").child(String(inputNameText)).setValue(data)
        
        self.inputNameText = self.inputName.text!
        let data = ["Name" : self.inputNameText,"areFriendsConnected" : false] as [String : Any]
        self.db.child("Friends").child(String(self.inputNameText)).setValue(data)
        showToast(message: "\(self.inputNameText) saved")
        let sharedPreferences = UserDefaults.standard
        sharedPreferences.set(self.inputNameText, forKey:"Name")
        print("Saved \(self.inputNameText) to shared preferences!")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true);
        
        self.db?.child("Friends").child(String(inputName.text!)).observe(.value, with: { (snapshot) in
            
            if (snapshot.exists())
            {
                var alert = UIAlertController(title: "User name exists", message: "Choose a different user name", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
            
        })
    }
    
    func competition()
    {
        self.db?.child("Friends").child(String(name)).observe(.value, with: { (snapshot) in
            
            if (snapshot.exists())
            {
                 let snap = snapshot.value as! NSDictionary
                if snapshot.hasChild("isFriendDone")
                {
                    
                    let isFriendDone = snap["isFriendDone"] as! Bool
                    if (isFriendDone == true)
                    {
                        print("Friend is done")
                        
                        var alert = UIAlertController(title: "Friend is done", message: "Friend is done with all the tasks", preferredStyle: UIAlertController.Style.alert)
                        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                    }
                }
               
            }
        })
    }

    func showToast(message : String) {
        
        let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - 75, y: self.view.frame.size.height-150, width: 150, height: 35))
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastLabel.textColor = UIColor.white
        toastLabel.backgroundColor = UIColor.darkGray
        toastLabel.textAlignment = .center;
        toastLabel.font = UIFont(name: "Montserrat-Light", size: 12.0)
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10;
        toastLabel.clipsToBounds  =  true
        self.view.addSubview(toastLabel)
        UIView.animate(withDuration: 3.0, delay: 0.1, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }
    
}

