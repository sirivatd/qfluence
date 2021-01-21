//
//  ExploreViewController.swift
//  qfluence
//
//  Created by Don Sirivat on 1/14/21.
//  Copyright © 2021 Don Sirivat. All rights reserved.
//

import UIKit
import AVFoundation
import Firebase
import Lottie

struct QuestionObject {
    let questionText: String
    let videoUrl: String
    let imageUrl: String
}

struct ExploreObject {
    let imageUrl: String
    let name: String
    let videoUrl: String
    let questionText: String
    let videoKey: String
    let influencerId: Int
}

class ExploreViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, ExploreTableViewCellDelegate {
    func didPressButton(_ tag: Int) {
        let object = self.exploreObjects[tag]
        self.selectedObject = object

        self.performSegue(withIdentifier: "showInfluencer", sender: nil)
    }
    
    @IBOutlet weak var tutorialView: UIView!
    @IBOutlet weak var animationView: AnimationView!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.exploreObjects.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "exploreCell") as! ExploreTableViewCell
        cell.cellDelegate = self
        cell.profileButton.tag = indexPath.row
        cell.questionText.text = self.exploreObjects[indexPath.row].questionText
        cell.subtitleText.text = self.exploreObjects[indexPath.row].name
        cell.profilePicture.downloadImageFrom(link: self.exploreObjects[indexPath.row].imageUrl, contentMode: UIView.ContentMode.scaleAspectFill)

        cell.profilePicture.layer.borderWidth = 1
        cell.profilePicture.layer.masksToBounds = false
        cell.profilePicture.layer.borderColor = UIColor.clear.cgColor
        cell.profilePicture.layer.cornerRadius = cell.profilePicture.frame.height/2
        cell.profilePicture.clipsToBounds = true
    
        cell.configureCell(videoUrl: self.exploreObjects[indexPath.row].videoUrl)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.view.frame.height
       }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
           return 0
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        // lazy load current set
        if self.totalCount - indexPath.row < 5 {
            // fetch more
            self.exploreObjects = self.exploreObjects + self.allExploreObjects.dropLast(25)
            self.exploreTableView.reloadData()
        }
    }
    
    var visibleIP : IndexPath?
    var aboutToBecomeInvisibleCell = -1
    var avPlayerLayer: AVPlayerLayer!
    var videoURLs = Array<String>()
    var exploreObjects = Array<ExploreObject>()
    var allExploreObjects = Array<ExploreObject>()
    var firstLoad: Bool = true
    var lastKey: String?
    var totalCount: Int = 0
    var selectedObject: ExploreObject?
    
    @IBOutlet weak var exploreTableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        fetchVideos()
                
        self.tutorialView.layer.cornerRadius = 15.0
        self.exploreTableView.contentInsetAdjustmentBehavior = .never
    }
    
    func fetchVideos() {
        let videoRef = Database.database().reference(withPath: "videos").queryLimited(toLast: 500)
        videoRef.observeSingleEvent(of: .value, with: { (snapshot) in
            let firebaseDispatch = DispatchGroup()
            for video in snapshot.children {
                firebaseDispatch.enter()
                if let snapshot = video as? DataSnapshot {
                    let videoKey = snapshot.key
                    let dict = snapshot.value as? NSDictionary
                    let questionText = dict!["questionText"] as! String
                    let videoUrlString = dict!["videoUrl"] as! String
                    let influencerId = dict!["influencerId"] as! Int
                        
                    self.findInfluencer(influencerId: influencerId, questionText: questionText, videoUrl: videoUrlString, videoKey: videoKey, dispatch: firebaseDispatch)
                }
            }
            firebaseDispatch.notify(queue: .main) {
                self.lastKey = self.allExploreObjects.last?.videoKey
                self.totalCount = self.allExploreObjects.count
                self.allExploreObjects = self.allExploreObjects.shuffled()
                self.exploreObjects = Array(self.allExploreObjects.dropLast(25))

                self.exploreTableView.reloadData()
            }
        })
    }
    
    func findInfluencer(influencerId: Int, questionText: String, videoUrl: String, videoKey: String, dispatch: DispatchGroup) {
        let ref = Database.database().reference(withPath: "influencers").child("\(influencerId)")
        ref.observeSingleEvent(of: .value, with: {(snapshot) in
            let influencer = snapshot.value as? NSDictionary
            
            let imageUrl = influencer!["imageUrl"] as? String
            let firstName = influencer!["firstName"] as? String
            let lastName = influencer!["lastName"] as? String
            
            var name: String?
            
            if lastName?.lowercased() == "n/a" {
                name = firstName
            } else {
                name = firstName! + " " + lastName!
            }
                        
            let exploreObject = ExploreObject(imageUrl: imageUrl!, name: name!, videoUrl: videoUrl, questionText: questionText, videoKey: videoKey, influencerId: influencerId)
            self.allExploreObjects.append(exploreObject)
            dispatch.leave()
        })
    }
    
    override func viewDidAppear(_ animated: Bool) {
        pausePlayeVideos()
        ASVideoPlayerController.sharedVideoPlayer.mute = false
        navigationController?.setNavigationBarHidden(true, animated: animated)
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationController?.navigationBar.tintColor = UIColor.red
        
        if firstLoad {
            animationView.contentMode = .scaleAspectFill
            animationView.loopMode = .loop
            animationView.play()
        }
    }
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let videoCell = cell as? ASAutoPlayVideoLayerContainer, let _ = videoCell.videoURL {
            ASVideoPlayerController.sharedVideoPlayer.removeLayerFor(cell: videoCell)
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        pausePlayeVideos()
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            pausePlayeVideos()
        }
        
        if self.tutorialView.isHidden {
            return
        }
        
        self.tutorialView.isHidden = true
        self.firstLoad = false
        ASVideoPlayerController.sharedVideoPlayer.mute = true

        self.performSegue(withIdentifier: "toOptimize", sender: nil)
    }
    
    func pausePlayeVideos(){
        ASVideoPlayerController.sharedVideoPlayer.pausePlayeVideosFor(tableView: self.exploreTableView)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        ASVideoPlayerController.sharedVideoPlayer.pauseAllVideos(tableView: self.exploreTableView)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showInfluencer" {
            if let destination = segue.destination as? InfluencerMainViewController {
                destination.title = self.selectedObject!.name
                destination.selectedInfluencerId = self.selectedObject!.influencerId
            }
        }
    }
}
