//
//  ProfileViewController.swift
//  qfluence
//
//  Created by Don Sirivat on 1/11/21.
//  Copyright © 2021 Don Sirivat. All rights reserved.
//

import UIKit
import Firebase
import SideMenu

class ProfileViewController: UIViewController {
    @IBOutlet weak var greetingText: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var joinedAtLabel: UILabel!
    @IBOutlet weak var backdropView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateGreeting()
        backdropView.layer.cornerRadius = 10.0
        backdropView.layer.borderWidth = 0.5
        backdropView.layer.borderColor = UIColor.clear.cgColor
        backdropView.layer.masksToBounds = true
    }
    
    func updateGreeting() {
        if currentUser != nil {
            self.nameLabel.text = currentUser!.firstName
            self.joinedAtLabel.text = "Member since " + currentUser!.joinedAt.prefix(10)
        } else {
            self.nameLabel.text = ""
            self.joinedAtLabel.text = "Pick any of the following options"
        }
        
        // update greeting header
        var greeting: String = ""
        let hour = Calendar.current.component(.hour, from: Date())

        switch hour {
        case 6..<12 : greeting = "Good morning,"
        case 12 : greeting = "Good day,"
        case 13..<17 : greeting = "Good afternoon,"
        case 17..<22 : greeting = "Good evening,"
        default: greeting = "Welcome back,"
        }
        
        self.greetingText.text = greeting
    }
}
