//
//  ConnectViewController.swift
//  GoodHabitsApp
//
//  Created by Foram Panchal on 2019-04-07.
//  Copyright © 2019 Foram Panchal. All rights reserved.
//

import UIKit
import FirebaseDatabase
import Firebase

class ConnectViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate{
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var toTextField: UITextField!
    
    
    var currentTextField = UITextField()
    var pickerView = UIPickerView()
   
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var habitLabelTwo: UILabel!
    @IBOutlet weak var habitLabelOne: UILabel!
    
    var db:DatabaseReference!
    var handle: DatabaseHandle?
    
    var generatedCode : String = ""
    var habitsSnapshot = [String:String]()
    var habits : [String] = []
    
    var name : String = ""
    var friendName : String = ""
    var isTimerRunning = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.db = Database.database().reference()
        
        let sharedPreferences = UserDefaults.standard
        if (sharedPreferences.object(forKey: "Friend") == nil)
        {
            print("No name found")
        }
        else
        {
            self.name = sharedPreferences.string(forKey: "Name")!
            nameLabel.text = "\(name)"
        }
        
        
        pickerView.delegate = self
        pickerView.dataSource = self
        toTextField.inputView = pickerView
        getHabits()
    }
    
    func getHabits(){
        self.db?.child("Habits").observe(.value, with: { (snapshot) in
            
            print("Habits are: \(snapshot)")
            let friends = snapshot.value as? NSDictionary
            
            if(snapshot.exists())
            {
                print("\(snapshot.childrenCount) habis found.")
                for (key, value) in friends!{
                    print("Key : \(key) and Value: \(value)")
                    let valueOfKey = key as! String
                    print("Value of key : \(valueOfKey)")
                    self.habits.append(valueOfKey)
                }
                print("Habis from Array of String : \(self.habits)")
                print("SUBHabits...\(self.habits.count)")
                
            }
            
        })
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
            return habits.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
            toTextField.text = habits[row]
            self.view.endEditing(true)
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
            return habits[row]
        
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        print("+++++Begin editing++++++")
        currentTextField = textField
        toTextField.inputView = pickerView
        
    }
    
    @IBAction func startButtonClicked(_ sender: Any) {
        
        var selectedHabit = toTextField.text
        print("Selected: \(selectedHabit!)")
        startButton.setTitle("Reset", for: UIControl.State.normal)
        if(selectedHabit != nil)
        {
            print("Selected habit is: \(selectedHabit!)")
            showToast(message: "Habit Saved")
            var alert = UIAlertController(title: "Habit Saved", message: "Go to Progress to track Habit", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            self.db.child("Friends").child(String(name)).child("Habit").setValue(selectedHabit!)
            
        }
        
        let sharedPreferences = UserDefaults.standard
        sharedPreferences.set(selectedHabit, forKey:"Habit")
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
