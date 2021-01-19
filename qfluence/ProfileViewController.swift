//
//  ProfileViewController.swift
//  qfluence
//
//  Created by Don Sirivat on 1/11/21.
//  Copyright © 2021 Don Sirivat. All rights reserved.
//

import UIKit
import Firebase

class ProfileViewController: UIViewController {
    @IBOutlet weak var greetingText: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var joinedAtLabel: UILabel!
    @IBOutlet weak var backdropView: UIView!
    @IBOutlet weak var logoutButton: UIButton!
    
    @IBAction func contactPressed(_ sender: Any) {
    }
    
    @IBAction func termsPressed(_ sender: Any) {
    }
    @IBAction func darkModePressed(_ sender: Any) {
    }
    @IBAction func influencerPressed(_ sender: Any) {
    }
    @IBAction func logoutPressed(_ sender: Any) {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            self.dismiss(animated: true, completion: nil)
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backdropView.layer.cornerRadius = 10.0
        backdropView.layer.borderWidth = 0.5
        backdropView.layer.borderColor = UIColor.clear.cgColor
        backdropView.layer.masksToBounds = true
        
        logoutButton.layer.cornerRadius = 5.0
        logoutButton.layer.borderWidth = 0.5
        logoutButton.layer.borderColor = UIColor.clear.cgColor
        logoutButton.layer.masksToBounds = true
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
