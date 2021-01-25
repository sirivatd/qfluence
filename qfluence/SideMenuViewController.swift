//
//  SideMenuViewController.swift
//  qfluence
//
//  Created by Don Sirivat on 1/25/21.
//  Copyright © 2021 Don Sirivat. All rights reserved.
//

import UIKit
import Firebase

struct SettingOption {
    let name: String
    let image: UIImage
}

class SideMenuViewController: UITableViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "settingCell") as! SettingOptionTableViewCell
        cell.settingLabel.text = self.settingOptions[indexPath.row].name
        cell.settingImage.image = self.settingOptions[indexPath.row].image
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let option = indexPath.row
        
        switch option {
        case 0:
            self.termsPressed()
        case 1:
            self.contactPressed()
        case 2:
            self.cellularSettingsPressed()
        case 3:
            self.tutorialPressed()
        case 4:
            self.logoutPressed()
        default:
            return
        }
        
        settingTableView.deselectRow(at: indexPath, animated: true)
    }
    
    @IBOutlet weak var settingTableView: UITableView!
    
    
    private var settingOptions = [SettingOption]()

    override func viewDidLoad() {
        super.viewDidLoad()
        setOptions()
        // Do any additional setup after loading the view.
    }
    
    func setOptions() {
        let option1 = SettingOption(name: "Terms and conditions", image: UIImage(systemName: "doc.on.clipboard.fill")!)
        let option2 = SettingOption(name: "Contact", image: UIImage(systemName: "arrow.up.message.fill")!)
        let option3 = SettingOption(name: "Cellular settings", image: UIImage(systemName: "iphone.homebutton")!)
        let option4 = SettingOption(name: "Tutorial", image: UIImage(systemName: "book.fill")!)
        let option5 = SettingOption(name: "Sign out", image: UIImage(systemName: "pip.exit")!)
        
        self.settingOptions.append(option1)
        self.settingOptions.append(option2)
        self.settingOptions.append(option3)
        self.settingOptions.append(option4)
        self.settingOptions.append(option5)
        
        self.settingTableView.reloadData()
    }
    
    func contactPressed() {
        let email = "hello@qfluencer.com"
        if let url = URL(string: "mailto:\(email)") {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }
    
    func termsPressed() {
        guard let url = URL(string: "https://qfluence.herokuapp.com") else { return }
        UIApplication.shared.open(url)
    }
    
    func cellularSettingsPressed() {
        UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
    }

    func logoutPressed() {
        let alert = UIAlertController(title: "Signing Out", message: nil, preferredStyle: .alert)
        alert.message = "Are you sure you want to sign out?"
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))

        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            let firebaseAuth = Auth.auth()
            do {
                try firebaseAuth.signOut()
                self.dismiss(animated: true, completion: nil)
            } catch let signOutError as NSError {
                print("Error signing out: %@", signOutError)
            }
        }))

        self.present(alert, animated: true)
    }
    
    func tutorialPressed() {
        self.performSegue(withIdentifier: "toTutorial", sender: nil)
    }
}