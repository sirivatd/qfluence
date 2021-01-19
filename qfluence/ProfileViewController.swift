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
    @IBOutlet weak var tutorialButton: UIButton!
    @IBOutlet weak var darkModeButton: UIButton!
    @IBOutlet weak var termsButton: UIButton!
    @IBOutlet weak var contactButton: UIButton!
    
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
        
        setupButtons()
    }
    
    func setupButtons() {
        self.tutorialButton.layer.shadowColor = UIColor.black.cgColor
        self.tutorialButton.layer.shadowOpacity = 1
        self.tutorialButton.layer.shadowOffset = .zero
        self.tutorialButton.layer.shadowRadius = 10
        self.tutorialButton.layer.shadowPath = UIBezierPath(rect: self.tutorialButton.bounds).cgPath
        self.tutorialButton.layer.cornerRadius = 10.0
        
        self.contactButton.layer.shadowColor = UIColor.black.cgColor
        self.contactButton.layer.shadowOpacity = 1
        self.contactButton.layer.shadowOffset = .zero
        self.contactButton.layer.shadowRadius = 10
        self.contactButton.layer.shadowPath = UIBezierPath(rect: self.contactButton.bounds).cgPath
        self.contactButton.layer.cornerRadius = 10.0
        
        self.darkModeButton.layer.shadowColor = UIColor.black.cgColor
        self.darkModeButton.layer.shadowOpacity = 1
        self.darkModeButton.layer.shadowOffset = .zero
        self.darkModeButton.layer.shadowRadius = 10
        self.darkModeButton.layer.shadowPath = UIBezierPath(rect: self.darkModeButton.bounds).cgPath
        self.darkModeButton.layer.cornerRadius = 10.0
        
        self.termsButton.layer.shadowColor = UIColor.black.cgColor
        self.termsButton.layer.shadowOpacity = 1
        self.termsButton.layer.shadowOffset = .zero
        self.termsButton.layer.shadowRadius = 10
        self.termsButton.layer.shadowPath = UIBezierPath(rect: self.termsButton.bounds).cgPath
        self.termsButton.layer.cornerRadius = 10.0
    }
}
