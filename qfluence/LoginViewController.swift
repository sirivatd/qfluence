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
    @IBOutlet weak var errorPopup: CSAnimationView!
    @IBOutlet weak var buttonView: CSAnimationView!
    
    var timer = Timer()
    
    @IBAction func loginPressed(_ sender: Any) {
        view.endEditing(true)
        let emailAddress = emailAddressField.text!
        let password = passwordField.text!
        
        if emailAddress == "" {
            showErrorPopup(error: "Email address can't be left blank")
            self.buttonView.startCanvasAnimation()
            self.timer = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(self.dismissErrorMessage), userInfo: nil, repeats: false)
            
            return
        } else if password == "" {
            showErrorPopup(error: "Password can't be left blank")
            self.buttonView.startCanvasAnimation()
            self.timer = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(self.dismissErrorMessage), userInfo: nil, repeats: false)
        }
        
        Auth.auth().signIn(withEmail: emailAddress, password: password) { [weak self] authResult, error in
            guard let strongSelf = self else { return }
            if let error = error {
                let authError = error as NSError
                strongSelf.showErrorPopup(error: authError.localizedDescription)
                strongSelf.buttonView.startCanvasAnimation()
                strongSelf.timer = Timer.scheduledTimer(timeInterval: 3, target: strongSelf, selector: #selector(strongSelf.dismissErrorMessage), userInfo: nil, repeats: false)
                } else {
                    let uid = authResult?.user.uid
                    let ref = Database.database().reference(withPath: "users")
                    ref.child(uid!).observeSingleEvent(of: .value, with: { (snapshot) in
                        let user = snapshot.value as? NSDictionary
                        
                        let firstName = user!["firstName"] as? String ?? ""
                        let lastName = user!["lastName"] as? String ?? ""
                        let emailAddress = user!["emailAddress"] as? String ?? ""
                        let joinedAt = user!["timeCreated"] as? String ?? ""
                        let follows = user!["follows"] as? [Int] ?? []
                        
                        currentUser = UserObject(firstName: firstName, lastName: lastName, emailAddress: emailAddress, joinedAt: joinedAt, follows: follows, uid: uid!)
                        strongSelf.performSegue(withIdentifier: "toMainApp", sender: self)
                    })
            }
        }
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
