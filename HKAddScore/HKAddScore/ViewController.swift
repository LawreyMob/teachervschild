//
//  ViewController.swift
//  HKAddScore
//
//  Created by Lawrence Tan on 5/5/17.
//  Copyright © 2017 Lawrey. All rights reserved.
//

import UIKit
import SCLAlertView

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func addTeacherTapped(_ sender: Any) {
        
        let alertView = SCLAlertView()
        
        let nameTextField = alertView.addTextField("Name")
        let scoreTextField = alertView.addTextField("Score")
        scoreTextField.keyboardType = .phonePad
        
        alertView.addButton("Submit") {
            guard let name = nameTextField.text, let score = scoreTextField.text else {
                return
            }
            
            HKSClient.addTeacherScore(name: name, score: Int(score)!, completionHandler: { (success, nil) in
                
            })
        }
        alertView.showSuccess("Submit Teacher's Score", subTitle: "Please key in the info")
    }
    
    @IBAction func addChildTapped(_ sender: Any) {
        
        let alertView = SCLAlertView()
        
        let nameTextField = alertView.addTextField("Name")
        let scoreTextField = alertView.addTextField("Score")
        scoreTextField.keyboardType = .phonePad
        
        alertView.addButton("Submit") {
            guard let name = nameTextField.text, let score = scoreTextField.text else {
                return
            }
            
            HKSClient.addKidScore(name: name, score: Int(score)!, completionHandler: { (success, nil) in
            
            })
        }
        alertView.showSuccess("Submit Kid's Score", subTitle: "Please key in the info")
    }
    
    

}

