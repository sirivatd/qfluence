//
//  LandingViewController.swift
//  qfluence
//
//  Created by Don Sirivat on 1/11/21.
//  Copyright © 2021 Don Sirivat. All rights reserved.
//

import UIKit

class LandingViewController: UIViewController {
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loginButton.layer.cornerRadius = 5.0
        loginButton.layer.borderWidth = 0.5
        loginButton.layer.borderColor = UIColor.clear.cgColor
        loginButton.layer.masksToBounds = true
        loginButton.layer.shadowColor = UIColor.darkGray.cgColor
        loginButton.layer.shadowOffset = CGSize(width: 0.5, height: 0.5)
        loginButton.layer.shadowRadius = 1.0
        loginButton.layer.shadowOpacity = 0.7
        loginButton.layer.masksToBounds = false
        loginButton.layer.shadowPath = UIBezierPath(roundedRect: loginButton.bounds, cornerRadius: loginButton.layer.cornerRadius).cgPath
        
        signUpButton.layer.cornerRadius = 5.0
        signUpButton.layer.borderWidth = 0.5
        signUpButton.layer.borderColor = UIColor.clear.cgColor
        signUpButton.layer.masksToBounds = true
        signUpButton.layer.shadowColor = UIColor.darkGray.cgColor
        signUpButton.layer.shadowOffset = CGSize(width: 0.5, height: 0.5)
        signUpButton.layer.shadowRadius = 1.0
        signUpButton.layer.shadowOpacity = 0.7
        signUpButton.layer.masksToBounds = false
        signUpButton.layer.shadowPath = UIBezierPath(roundedRect: signUpButton.bounds, cornerRadius: signUpButton.layer.cornerRadius).cgPath
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
