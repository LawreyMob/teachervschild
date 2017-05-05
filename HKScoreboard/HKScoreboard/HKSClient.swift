//
//  HKSClient.swift
//  HKScoreboard
//
//  Created by Lawrence Tan on 5/5/17.
//  Copyright © 2017 Lawrey. All rights reserved.
//

import Foundation
import FirebaseDatabase
import Firebase

struct Person {
    
    var name: String
    var score: Int
    
}

class HKSClient : NSObject {
    
    // MARK: Properties
    var rootRef = FIRDatabase.database().reference()
    var kids = [Person]()
    var teachers = [Person]()
    
    /* Shared session */
    var session: URLSession
    
    var count: Int = 0
    
    // MARK: Initializers
    
    override init() {
        session = URLSession.shared
        super.init()
    }
    
    // MARK: Shared Instance
    
    class func sharedInstance() -> HKSClient {
        
        struct Singleton {
            static let sharedInstance = HKSClient()
        }
        
        return Singleton.sharedInstance
    }
    
    class func getKidsFromServer(_ completionHandler: (_ hasResult: Bool, _ error: NSError?) -> Void) {
        // observeEventType is called whenever anything changes in the Firebase - new scores.
        // It's also called here in viewDidLoad().
        // It's always listening.
        
        HKSClient.sharedInstance().rootRef.child("kids").observe(.value, with: { snapshot in
            
            // The snapshot is a current look at our jokes data.
            
            hksClient.kids.removeAll()
            
            if let snapshots = snapshot.children.allObjects as? [FIRDataSnapshot] {
                
                for snap in snapshots {
                    
                    // Make our trainers array for the tableView.
                    
                    if let postDictionary = snap.value as? Dictionary<String, AnyObject> {
                        if let score = (postDictionary["score"] as? Int), let name = postDictionary["name"] {
                            let HKkid = Person(name: name as! String, score: score)
                            hksClient.kids.append(HKkid)
                        }
                    }
                }
                
                hksClient.kids.sort(by: {$0.score > $1.score})
                NotificationCenter.default.post(name: Notification.Name(rawValue: kHighscoreUpdatedNotification), object: nil)
                
            }
            
        })
    }
    
    class func getTeachersFromServer(_ completionHandler: (_ hasResult: Bool, _ error: NSError?) -> Void) {
        // observeEventType is called whenever anything changes in the Firebase - new scores.
        // It's also called here in viewDidLoad().
        // It's always listening.
        
        HKSClient.sharedInstance().rootRef.child("teachers").observe(.value, with: { snapshot in
            
            // The snapshot is a current look at our jokes data.
            
            hksClient.teachers.removeAll()
            
            if let snapshots = snapshot.children.allObjects as? [FIRDataSnapshot] {
                
                for snap in snapshots {
                    
                    // Make our trainers array for the tableView.
                    
                    if let postDictionary = snap.value as? Dictionary<String, AnyObject> {
                        if let score = (postDictionary["score"] as? Int), let name = postDictionary["name"] {
                            let teacher = Person(name: name as! String, score: score)
                            hksClient.teachers.append(teacher)
                        }
                    }
                }
                
                hksClient.teachers.sort(by: {$0.score > $1.score})
                NotificationCenter.default.post(name: Notification.Name(rawValue: kHighscoreUpdatedNotification), object: nil)
                
            }
            
        })
    }
    
}
