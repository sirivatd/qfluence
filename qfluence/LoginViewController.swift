//
//  LoginViewController.swift
//  qfluence
//
//  Created by Don Sirivat on 1/11/21.
//  Copyright © 2021 Don Sirivat. All rights reserved.
//

import UIKit
import Firebase
import Canvas

class LoginViewController: UIViewController {
    @IBOutlet weak var emailAddressField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var errorText: UITextView!
    @IBOutlet weak var closePopupButton: UIButton!
    @IBOutlet weak var errorPopup: CSAnimationView!
    
    @IBAction func closePopupPressed(_ sender: Any) {
        errorPopup.isHidden = true
    }
    
    @IBAction func loginPressed(_ sender: Any) {
        let emailAddress = emailAddressField.text!
        let password = passwordField.text!
        
        if emailAddress == "" {
            showErrorPopup(error: "Email address can't be blank")
            return
        } else if password == "" {
            showErrorPopup(error: "Password can't be blank")
        }
        
        Auth.auth().signIn(withEmail: emailAddress, password: password) { [weak self] authResult, error in
            guard let strongSelf = self else { return }
            if let error = error {
                let authError = error as NSError
                strongSelf.showErrorPopup(error: authError.localizedDescription)
                    } else {
                            strongSelf.performSegue(withIdentifier: "toMainApp", sender: self)
                    }
            }
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        self.dismiss(animated: true, completion: nil)
    }
}
