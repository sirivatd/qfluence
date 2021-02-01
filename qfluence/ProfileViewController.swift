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

class ProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.likedObjects.count + 4
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0:
            // Greeting cell
            return 225
        case 1:
            // Other info cell
            return 5
        case 2:
            // Follows header cell
            return 55
        case currentUser!.follows.count + 3:
            // Referral cell
            return 350
        default:
            // Follow cell
            return 115
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            // Greeting cell
            let cell = tableView.dequeueReusableCell(withIdentifier: "greetingCell", for: indexPath)
            cell.backgroundColor = .clear
            
            return cell
        case 1:
            // Other info cell
            let cell = tableView.dequeueReusableCell(withIdentifier: "otherInfoCell", for: indexPath)
            cell.backgroundColor = .clear

            return cell
        case 2:
            // Likes header cell
            let cell = tableView.dequeueReusableCell(withIdentifier: "headerCell", for: indexPath) as! FollowingHeaderTableViewCell
            cell.headerLabel.text = "FOLLOWING (\(currentUser!.follows.count))"
            cell.backgroundColor = .clear

            return cell
        case self.likedObjects.count + 3:
            // Referral cell
            let cell = tableView.dequeueReusableCell(withIdentifier: "referralCell", for: indexPath) as! ReferralTableViewCell
            cell.becomeAQfluencer.layer.cornerRadius = 15.0
            cell.becomeAQfluencer.layer.borderWidth = 0.5
            cell.becomeAQfluencer.layer.borderColor = UIColor.clear.cgColor
            cell.becomeAQfluencer.layer.masksToBounds = true
            cell.becomeAQfluencer.layer.shadowColor = UIColor.darkGray.cgColor
            cell.becomeAQfluencer.layer.shadowOffset = CGSize(width: 0.5, height: 0.5)
            cell.becomeAQfluencer.layer.shadowRadius = 1.0
            cell.becomeAQfluencer.layer.shadowOpacity = 0.7
            cell.becomeAQfluencer.layer.masksToBounds = false
            cell.becomeAQfluencer.layer.shadowPath = UIBezierPath(roundedRect: cell.becomeAQfluencer.bounds, cornerRadius: cell.becomeAQfluencer.layer.cornerRadius).cgPath
            cell.backgroundColor = .clear


            return cell
        default:
            // Follow cell
            let cell = tableView.dequeueReusableCell(withIdentifier: "followCell", for: indexPath) as! FollowTableViewCell
            cell.name.text = self.likedObjects[indexPath.row-3].label
            cell.profilePicture.loadImage(urlSting: self.likedObjects[indexPath.row-3].imageUrl)
            cell.profilePicture.layer.cornerRadius = cell.profilePicture.frame.width / 2            
            cell.subtitle.text = self.likedObjects[indexPath.row-3].bioText
            cell.backgroundColor = .clear

            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            return
        case 1:
            return
        case 2:
            return
        case self.likedObjects.count + 3:
            // did press referral cell
            return
        default:
            // Follow cell
            self.selectedObject = self.likedObjects[indexPath.row - 3]
            self.performSegue(withIdentifier: "toInfluencer", sender: self)
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
    
    @IBOutlet weak var mainView: UITableView!
    
    private var likedObjects: [SpotlightObject] = []
    private var ref: DatabaseReference?
    private var backgroundRef: DatabaseReference?
    private var selectedObject: SpotlightObject?
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        updateGreeting()
//        addBlurEffect()
        fetchFollows()
    }
    
    @objc func onMenuButtonPressed(sender: UIButton) {
        
    }
    
    func fetchFollows() {
        self.backgroundRef = Database.database().reference(withPath: "users").child(
            currentUser!.uid)
        self.backgroundRef!.observe(DataEventType.value, with: { (snapshot) in
            self.likedObjects = []
            if let user = snapshot.value as? NSDictionary {
                let follows = user["follows"] as? [Int] ?? []
                for id in follows {
                    self.queryAndAppendInfluencer(id: id)
                }
            }
        });
    }
    
    func addBlurEffect() {
        let bounds = self.navigationController?.navigationBar.bounds
        self.navigationController?.view.backgroundColor = .black
        let visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .light))
        visualEffectView.frame = bounds ?? CGRect.zero
        visualEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.navigationController?.navigationBar.addSubview(visualEffectView)

        // Here you can add visual effects to any UIView control.
        // Replace custom view with navigation bar in the above code to add effects to the custom view.
    }
    
    func queryAndAppendInfluencer(id: Int) {
        self.ref = Database.database().reference(withPath: "influencers").child("\(id)")
        self.ref!.observeSingleEvent(of: .value, with: { (snapshot) in
            if let influencer = snapshot.value as? NSDictionary {
                let imageUrlString = influencer["imageUrl"] as? String ?? ""
                let bioText = influencer["bioText"] as? String ?? ""
                let category = influencer["category"] as? String ?? ""
                let email = influencer["email"] as? String ?? ""
                let firstName = influencer["firstName"] as? String ?? ""
                let lastName = influencer["lastName"] as? String ?? ""
                let instagramLink = influencer["instagramLink"] as? String ?? ""
                let otherLink = influencer["otherLink"] as? String ?? ""
                let influencerId = influencer["influencerId"] as! Int
                
                var name: String?
                if lastName.lowercased() == "n/a" {
                    name = firstName
                } else {
                    name = firstName + " " + lastName
                }
     
                let newObject: SpotlightObject = SpotlightObject(imageUrl: imageUrlString, label: name!, influencerId: id, bioText: bioText)
                self.likedObjects.append(newObject)
            }

//            currentUser?.follows = self.likedObjects.map{$0.influencerId}
            self.mainView.reloadData()
        });
    }
    
    func updateGreeting() {
//        if currentUser != nil {
//            self.nameLabel.text = currentUser!.firstName
//            self.joinedAtLabel.text = "Member since " + currentUser!.joinedAt.prefix(10)
//        } else {
//            self.nameLabel.text = ""
//            self.joinedAtLabel.text = "Pick any of the following options"
//        }
//
//        // update greeting header
//        var greeting: String = ""
//        let hour = Calendar.current.component(.hour, from: Date())
//
//        switch hour {
//        case 6..<12 : greeting = "Good morning,"
//        case 12 : greeting = "Good day,"
//        case 13..<17 : greeting = "Good afternoon,"
//        case 17..<22 : greeting = "Good evening,"
//        default: greeting = "Welcome back,"
//        }
//
//        self.greetingText.text = greeting
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toInfluencer" {
            if let destination = segue.destination as? InfluencerMainViewController {
                destination.title = self.selectedObject?.label
                destination.selectedInfluencerId = self.selectedObject?.influencerId
            }
        }
        if segue.identifier == "toMenu" {
            if let destination = segue.destination as? SideMenuViewController {
                destination.vc = self
            }
        }
    }
}
