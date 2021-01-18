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

class TextField: UITextField {

    let padding = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 5)

    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }

    override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }

    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
}

class SignUpViewController: UIViewController {
    var handle: AuthStateDidChangeListenerHandle?
    
    @IBOutlet weak var firstNameField: UITextField!
    @IBOutlet weak var lastNameField: UITextField!
    @IBOutlet weak var emailAddressField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var confirmPasswordField: UITextField!
    @IBOutlet weak var errorPopup: CSAnimationView!
    @IBOutlet weak var errorText: UITextView!
    @IBOutlet weak var buttonView: CSAnimationView!
    
    var timer = Timer()
    
    @IBAction func signUpPressed(_ sender: Any) {
        view.endEditing(true)

        let firstName = firstNameField.text!
        let lastName = lastNameField.text!
        let emailAddress = emailAddressField.text!
        let password = passwordField.text!
        let confirmPassword = confirmPasswordField.text!
        
        // Client side error handling
        if firstName == "" {
            showErrorPopup(error: "First name can't be left blank")
            self.buttonView.startCanvasAnimation()
            self.timer = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(self.dismissErrorMessage), userInfo: nil, repeats: false)
            return
        } else if lastName == "" {
            showErrorPopup(error: "Last name can't be left blank")
            self.buttonView.startCanvasAnimation()
            self.timer = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(self.dismissErrorMessage), userInfo: nil, repeats: false)
            return
        } else if emailAddress == "" {
            showErrorPopup(error: "Email address can't be left blank")
            self.buttonView.startCanvasAnimation()
            self.timer = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(self.dismissErrorMessage), userInfo: nil, repeats: false)
            return
        } else if password == "" {
            showErrorPopup(error: "Password can't be left blank")
            self.buttonView.startCanvasAnimation()
            self.timer = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(self.dismissErrorMessage), userInfo: nil, repeats: false)
            return
        } else if confirmPassword == "" {
            showErrorPopup(error: "Confirm password can't be left blank")
            self.buttonView.startCanvasAnimation()
            self.timer = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(self.dismissErrorMessage), userInfo: nil, repeats: false)
            return
        }
        
        if password != confirmPassword {
            showErrorPopup(error: "Please double check your passwords match and try again")
            self.buttonView.startCanvasAnimation()
            self.timer = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(self.dismissErrorMessage), userInfo: nil, repeats: false)
            return
        }
        
        Auth.auth().createUser(withEmail: emailAddress, password: password, completion: { authResult, error in
            guard let user = authResult?.user, error == nil else {
                self.showErrorPopup(error: error!.localizedDescription)
                self.buttonView.startCanvasAnimation()
                self.timer = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(self.dismissErrorMessage), userInfo: nil, repeats: false)
                return
            }
            print("\(user.email!) created")
            self.performSegue(withIdentifier: "toMainApp", sender: self)
        })
    }
    
    @objc func dismissErrorMessage() {
        self.errorPopup.isHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        errorPopup.isHidden = true
        initializeHideKeyboard()

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
    
    func initializeHideKeyboard() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissMyKeyboard))
        self.view.addGestureRecognizer(tap)
    }
    
    @objc func dismissMyKeyboard() {
        view.endEditing(true)
    }
}
