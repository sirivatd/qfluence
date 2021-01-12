//
//  InfluencerMainViewController.swift
//  qfluence
//
//  Created by Don Sirivat on 1/10/21.
//  Copyright © 2021 Don Sirivat. All rights reserved.
//

import UIKit
import Firebase
import AVKit

extension InfluencerMainViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "influencerHeader") as! InfluencerHeaderTableViewCell
            if self.selectedInfluencer != nil {
                cell.bioText.text = self.selectedInfluencer!.bioText
                
                let url = URL(string: selectedInfluencer!.imageUrl)
                let data = try? Data(contentsOf: url!)
                
                cell.profilePicture.image = UIImage(data: data!)
            }
        
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "influencerVideo") as! InfluencerVideoTableViewCell
            let questionObject = questionObjects[indexPath.row - 1]
            cell.questionText.text = questionObject.questionText
            
            // render video image
            let url = URL(string: questionObject.imageUrl)
            let data = try? Data(contentsOf: url!)
            
            cell.videoPreview.image = UIImage(data: data!)
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.questionObjects.count + 1
    }
}

extension InfluencerMainViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 205
        } else {
            return 145
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.row != 0 {
            let index = indexPath.row - 1
            let videoUrlString = self.questionObjects[index].videoUrl
            
            let url = URL(string: videoUrlString)
            playerView = AVPlayer(url: url as! URL)
            playerViewController.player = playerView
            
            // present player view controller
            self.present(playerViewController, animated: true) {
                self.playerViewController.player?.play()
            }
        }
    }
}

class InfluencerMainViewController: UIViewController {
    @IBOutlet weak var mainTableView: UITableView!
    var selectedInfluencerId: Int?
    private var questionObjects = [QuestionObject]()
    private var selectedInfluencer: InfluencerObject?
    var playerViewController = AVPlayerViewController()
    var playerView = AVPlayer()
    
    @IBAction func instagramButtonPressed(_ sender: Any) {
        guard let url = URL(string: self.selectedInfluencer!.instagramLink) else { return }
        UIApplication.shared.open(url)
    }
    
    @IBAction func otherLinkPressed(_ sender: Any) {
        guard let url = URL(string: self.selectedInfluencer!.otherLink) else { return }
        UIApplication.shared.open(url)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(loadingIndicator)
        fetchVideos()
        
        NSLayoutConstraint.activate([
            loadingIndicator.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            loadingIndicator.widthAnchor.constraint(equalToConstant: 50),
            loadingIndicator.heightAnchor.constraint(equalTo: self.loadingIndicator.widthAnchor)
            ])
        
        loadingIndicator.isAnimating = true
        mainTableView.isHidden = true
    }
    
    let loadingIndicator: ProgressView = {
        let progress = ProgressView(colors: [.red, .orange, .darkGray], lineWidth: 5)
        progress.translatesAutoresizingMaskIntoConstraints = false
        return progress
    }()
    
    func fetchVideos() {
        let ref = Database.database().reference(withPath: "videos")
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            let videoData = snapshot.value as! [[String : Any]]
            
            for video in videoData {
                let influencerId = video["influencerId"] as! Int
                if influencerId == self.selectedInfluencerId! {
                    let questionText = video["questionText"] as! String
                    let videoUrlString = video["videoUrl"] as! String
                    let imageUrlString = video["imageUrl"] as! String
                    
                    let questionObject = QuestionObject(questionText: questionText, videoUrl: videoUrlString, imageUrl: imageUrlString)
                    
                    self.questionObjects.append(questionObject)
                }
            }
        })
        
        let influencerRef = Database.database().reference(withPath: "influencers").child("\(self.selectedInfluencerId!)")
        influencerRef.observeSingleEvent(of: .value, with: { (snapshot) in
            let influencer = snapshot.value as? NSDictionary
            
            let imageUrlString = influencer!["imageUrl"] as? String ?? ""
            let bioText = influencer!["bioText"] as? String ?? ""
            let category = influencer!["category"] as? String ?? ""
            let email = influencer!["email"] as? String ?? ""
            let firstName = influencer!["firstName"] as? String ?? ""
            let lastName = influencer!["lastName"] as? String ?? ""
            let instagramLink = influencer!["instagramLink"] as? String ?? ""
            let otherLink = influencer!["otherLink"] as? String ?? ""
            let influencerId = influencer!["influencerId"] as! Int
            
            self.selectedInfluencer = InfluencerObject(bioText: bioText, category: category, email: email, firstName: firstName, lastName: lastName, instagramLink: instagramLink, otherLink: otherLink, imageUrl: imageUrlString, influencerId: influencerId)
            
            self.mainTableView.reloadData()
            self.loadingIndicator.removeFromSuperview()
            self.mainTableView.isHidden = false
        })
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toQuestionModal" {
            if let destination = segue.destination as? QuestionViewController {
                destination.selectedInfluencerId = self.selectedInfluencerId!
                destination.questionObjects = self.questionObjects
            }
        }
    }
}
