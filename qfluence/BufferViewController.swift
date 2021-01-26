//
//  BufferViewController.swift
//  qfluence
//
//  Created by Don Sirivat on 1/24/21.
//  Copyright © 2021 Don Sirivat. All rights reserved.
//

import UIKit
import Firebase

class BufferViewController: UIViewController {
    var handle: AuthStateDidChangeListenerHandle?


    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        handle = Auth.auth().addStateDidChangeListener { (auth, user) in
            if user != nil {
                let ref = Database.database().reference(withPath: "users")
                ref.child(user!.uid).observeSingleEvent(of: .value, with: { (snapshot) in
                    let uid = user!.uid
                    let user = snapshot.value as? NSDictionary
                    
                    let firstName = user!["firstName"] as? String ?? ""
                    let lastName = user!["lastName"] as? String ?? ""
                    let emailAddress = user!["emailAddress"] as? String ?? ""
                    let joinedAt = user!["timeCreated"] as? String ?? ""
                    let follows = user!["follows"] as? [Int] ?? []
                    
                    let foundUser = UserObject(firstName: firstName, lastName: lastName, emailAddress: emailAddress, joinedAt: joinedAt, follows: follows, uid: uid)
                    
                    currentUser = foundUser
                    self.performSegue(withIdentifier: "toMainApp", sender: self)
                })
            } else {
                self.performSegue(withIdentifier: "toLanding", sender: nil)
            }
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        Auth.auth().removeStateDidChangeListener(handle!)
    }
}

