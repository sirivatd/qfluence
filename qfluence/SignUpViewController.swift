//
//  SignUpViewController.swift
//  qfluence
//
//  Created by Don Sirivat on 1/11/21.
//  Copyright © 2021 Don Sirivat. All rights reserved.
//

import UIKit
import Firebase
import Canvas

class SignUpViewController: UIViewController {
    var handle: AuthStateDidChangeListenerHandle?
    
    @IBOutlet weak var firstNameField: UITextField!
    @IBOutlet weak var lastNameField: UITextField!
    @IBOutlet weak var emailAddressField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var confirmPasswordField: UITextField!
    @IBOutlet weak var errorPopup: CSAnimationView!
    @IBOutlet weak var closePopupButton: UIButton!
    @IBOutlet weak var errorText: UITextView!
    
    @IBAction func closePopupPressed(_ sender: Any) {
        errorPopup.isHidden = true
    }
    
    @IBAction func signUpPressed(_ sender: Any) {
        print("Sign up pressed")
        let firstName = firstNameField.text!
        let lastName = lastNameField.text!
        let emailAddress = emailAddressField.text!
        let password = passwordField.text!
        let confirmPassword = confirmPasswordField.text!
        
        // Client side error handling
        if firstName == "" {
            showErrorPopup(error: "First name can't be blank")
            return
        } else if lastName == "" {
            showErrorPopup(error: "Last name can't be blank")
            return
        } else if emailAddress == "" {
            showErrorPopup(error: "Email address can't be blank")
            return
        } else if password == "" {
            showErrorPopup(error: "Password can't be blank")
            return
        } else if confirmPassword == "" {
            showErrorPopup(error: "Confirm password can't be blank")
            return
        }
        
        if password != confirmPassword {
            showErrorPopup(error: "Passwords don't match")
            return
        }
        
        Auth.auth().createUser(withEmail: emailAddress, password: password, completion: { authResult, error in
            guard let user = authResult?.user, error == nil else {
                self.showErrorPopup(error: error!.localizedDescription)
                return
            }
            print("\(user.email!) created")
            self.performSegue(withIdentifier: "toMainApp", sender: self)
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        errorPopup.isHidden = true
        
        closePopupButton.layer.cornerRadius = 5.0
        closePopupButton.layer.borderWidth = 0.5
        closePopupButton.layer.borderColor = UIColor.clear.cgColor
        closePopupButton.layer.masksToBounds = true
        closePopupButton.layer.shadowColor = UIColor.darkGray.cgColor
        closePopupButton.layer.shadowOffset = CGSize(width: 0.5, height: 0.5)
        closePopupButton.layer.shadowRadius = 1.0
        closePopupButton.layer.shadowOpacity = 0.7
        closePopupButton.layer.masksToBounds = false
        closePopupButton.layer.shadowPath = UIBezierPath(roundedRect: closePopupButton.bounds, cornerRadius: closePopupButton.layer.cornerRadius).cgPath
        
        errorPopup.layer.cornerRadius = 5.0
        errorPopup.layer.borderWidth = 0.5
        errorPopup.layer.borderColor = UIColor.clear.cgColor
        errorPopup.layer.masksToBounds = true
        errorPopup.layer.shadowColor = UIColor.darkGray.cgColor
        errorPopup.layer.shadowOffset = CGSize(width: 0.5, height: 0.5)
        errorPopup.layer.shadowRadius = 1.0
        errorPopup.layer.shadowOpacity = 0.7
        errorPopup.layer.masksToBounds = false
        errorPopup.layer.shadowPath = UIBezierPath(roundedRect: errorPopup.bounds, cornerRadius: errorPopup.layer.cornerRadius).cgPath
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(sender: NSNotification) {
         self.view.frame.origin.y = -150 // Move view 150 points upward
    }

    @objc func keyboardWillHide(sender: NSNotification) {
         self.view.frame.origin.y = 0 // Move view to original position
    }
    
    func showErrorPopup(error: String) {
        errorText.text = error
        errorPopup.isHidden = false
        errorPopup.startCanvasAnimation()
    }
}
