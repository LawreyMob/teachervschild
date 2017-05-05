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
            }
            
        })
    }
    
    class func addKidScore(name: String, score: Int, completionHandler: @escaping (_ finished: Bool, _ error: NSError?) -> Void) {
        
        let data = [
            "name": name,
            "score": score
            ] as [String : Any]
        
        HKSClient.sharedInstance().rootRef.child("kids")
            .child(HKSClient.randomString(length: 15)).setValue(data)
        
    }
    
    class func addTeacherScore(name: String, score: Int, completionHandler: @escaping (_ finished: Bool, _ error: NSError?) -> Void) {
        
        let data = [
            "name": name,
            "score": score
        ] as [String : Any]
        
        HKSClient.sharedInstance().rootRef.child("teachers")
            .child(HKSClient.randomString(length: 15)).setValue(data)
        
    }
    
    class func randomString(length: Int) -> String {
        
        let letters : NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        let len = UInt32(letters.length)
        
        var randomString = ""
        
        for _ in 0 ..< length {
            let rand = arc4random_uniform(len)
            var nextChar = letters.character(at: Int(rand))
            randomString += NSString(characters: &nextChar, length: 1) as String
        }
        
        return randomString
    }
    
}
