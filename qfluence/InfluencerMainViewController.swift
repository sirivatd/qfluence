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
                cell.profilePicture.downloadImageFrom(link: selectedInfluencer!.imageUrl, contentMode: UIView.ContentMode.scaleAspectFill)
                
                cell.bioText.text = selectedInfluencer!.bioText
                
                if self.firstLoad {
                    self.firstLoad = false
                    
                    cell.animationOne.startCanvasAnimation()
                    cell.animationTwo.startCanvasAnimation()
                    cell.animationThree.startCanvasAnimation()
                }
            }
        
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "influencerVideo") as! InfluencerVideoTableViewCell
            let questionObject = questionObjects[indexPath.row - 1]
            cell.questionText.text = questionObject.questionText

            if indexPath.row % 4 == 0 {
                cell.parallaxImage.image = UIImage(named: "q_black_cell_0")
            } else if indexPath.row % 4 == 1 {
                cell.parallaxImage.image = UIImage(named: "q_orange_cell_0")
            } else if indexPath.row % 4 == 2 {
                cell.parallaxImage.image = UIImage(named: "q_black_cell_0")
            } else {
                cell.parallaxImage.image = UIImage(named: "q_red_cell_0")
            }
            
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
            return self.view.frame.height - 200
        } else {
            return 155
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
    
    // parallax effect
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if self.originalCellHeight == nil {
            let indexPath = IndexPath(row: 0, section: 0)
            let cell = self.mainTableView.cellForRow(at: indexPath) as? InfluencerHeaderTableViewCell
            
            self.originalCellHeight = Float(cell!.frame.height)
        }
        
        let indexPath = IndexPath(row: 0, section: 0)
        let cell = self.mainTableView.cellForRow(at: indexPath) as? InfluencerHeaderTableViewCell
        
        if cell != nil {
            let y = scrollView.contentOffset.y.magnitude
            let height = max(self.originalCellHeight! - Float(y/3), 0)
            cell!.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: CGFloat(Float(height)))
        } else {
            let offsetY = self.mainTableView.contentOffset.y
            if let questionCell = self.mainTableView.visibleCells.first as? InfluencerVideoTableViewCell {
                let x = questionCell.videoPreview.frame.origin.x
                let w = questionCell.videoPreview.bounds.width
                let h = questionCell.videoPreview.bounds.height
                let y = ((offsetY - questionCell.frame.origin.y) / h) * 25
                
                questionCell.videoPreview.frame = CGRect(x: x, y: y, width: w, height: h)
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
    var firstLoad: Bool = true
    var originalCellHeight: Float?
    
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
        navigationController?.navigationBar.barTintColor = UIColor.black
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]

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
        let videoRef = Database.database().reference(withPath: "videos")
        videoRef.observeSingleEvent(of: .value, with: { (snapshot) in
            for video in snapshot.children {
                if let snapshot = video as? DataSnapshot {
                    let dict = snapshot.value as? NSDictionary
                    let influencerId = dict!["influencerId"] as? Int
                    if influencerId == nil {
                        print(snapshot.key)
                    }
                    
                        
                    if self.selectedInfluencerId != influencerId {
                        continue
                    }
                    
                    let questionText = dict!["questionText"] as! String
                    let videoUrlString = dict!["videoUrl"] as! String
                    let imageUrlString = dict!["imageUrl"] as! String
                    
                    let questionObject = QuestionObject(questionText: questionText, videoUrl: videoUrlString, imageUrl: imageUrlString)
                        
                    self.questionObjects.append(questionObject)
                }
            }
            self.mainTableView.reloadData()
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
}
