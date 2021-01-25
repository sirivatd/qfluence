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
    @IBOutlet weak var playIcon: UIImageView!
    
    var isPaused: Bool = false
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.exploreObjects.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.isPaused {
            ASVideoPlayerController.sharedVideoPlayer.pausePlayeVideosFor(tableView: self.exploreTableView)
            self.playIcon.isHidden = true
        } else {
            ASVideoPlayerController.sharedVideoPlayer.pauseAllVideos(tableView: self.exploreTableView)
            self.playIcon.isHidden = false
        }
        self.isPaused = !self.isPaused
    }
        
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "exploreCell") as! ExploreTableViewCell
        cell.cellDelegate = self
        cell.profileButton.tag = indexPath.row
        cell.questionText.text = self.exploreObjects[indexPath.row].questionText
        cell.subtitleText.text = self.exploreObjects[indexPath.row].name
        cell.profilePicture.loadImage(urlSting: self.exploreObjects[indexPath.row].imageUrl)

        cell.profilePicture.layer.borderWidth = 2.5
        cell.profilePicture.image = UIImage(named: "q_default_pro_pic")
        cell.profilePicture.layer.masksToBounds = false
        cell.profilePicture.layer.borderColor = UIColor.red.cgColor
        cell.profilePicture.layer.cornerRadius = cell.profilePicture.frame.height/2
        cell.profilePicture.clipsToBounds = true
        
        cell.profilePicture.layer.shadowColor = UIColor.black.cgColor
        cell.profilePicture.layer.shadowOffset = CGSize(width: 0.5, height: 0.5)
        cell.profilePicture.layer.shadowRadius = 1.0
        cell.profilePicture.layer.shadowOpacity = 0.7
        cell.profilePicture.layer.shadowPath = UIBezierPath(roundedRect: cell.profilePicture.bounds, cornerRadius: cell.profilePicture.layer.cornerRadius).cgPath
    
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
        if !self.firstLoad && self.exploreObjects.count - indexPath.row == 7                                                                     {
            // fetch more
            print("Fetching")
            self.exploreTableView.estimatedRowHeight = 0;
            self.exploreTableView.estimatedSectionHeaderHeight = 0;
            self.exploreTableView.estimatedSectionFooterHeight = 0;
//            self.fetchVideos(lastKey: self.exploreObjects.last!.videoKey)
            self.exploreObjects.append(contentsOf: self.allExploreObjects.dropLast(10))
        }

        // lazy load current set
    }
        
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let videoCell = cell as? ASAutoPlayVideoLayerContainer, let _ = videoCell.videoURL {
            ASVideoPlayerController.sharedVideoPlayer.removeLayerFor(cell: videoCell)
        }
    }
    
    var visibleIP : IndexPath?
    var aboutToBecomeInvisibleCell = -1
    var avPlayerLayer: AVPlayerLayer!
    var videoURLs = Array<String>()
    var exploreObjects = Array<ExploreObject>()
    var allExploreObjects = Array<ExploreObject>()
    var lastKey: String?
    var totalCount: Int = 0
    var selectedObject: ExploreObject?
    
    let videoRef = Database.database().reference(withPath: "videos")
    let ref = Database.database().reference(withPath: "influencers")
    var firstLoad: Bool = true
    
    @IBOutlet weak var exploreTableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        fetchVideos()
                
        self.tutorialView.layer.cornerRadius = 15.0
        self.exploreTableView.contentInsetAdjustmentBehavior = .never
    }
    
    func fetchVideos(lastKey: String = "") {
        var query: DatabaseQuery?
//        if lastKey == "" {
//            query = self.videoRef.queryOrderedByKey().queryLimited(toLast: 10)
//        } else {
//            query = self.videoRef.queryOrderedByKey().queryEnding(atValue: lastKey).queryLimited(toFirst: 10)
//        }
        query = self.videoRef.queryOrderedByKey().queryLimited(toFirst: 200)

        query!.observeSingleEvent(of: .value, with: { (snapshot) in
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
//                self.lastKey = self.allExploreObjects.last?.videoKey
//                self.totalCount = self.allExploreObjects.count
                self.allExploreObjects = self.allExploreObjects.shuffled()
////                self.exploreObjects = Array(self.allExploreObjects.dropLast(30))
                self.exploreObjects = self.allExploreObjects.dropLast(10)
                
                self.exploreTableView.reloadData()
                self.firstLoad = false
            }
        })
    }
    
    func findInfluencer(influencerId: Int, questionText: String, videoUrl: String, videoKey: String, dispatch: DispatchGroup) {
        let tempRef = ref.child("\(influencerId)")
        tempRef.observeSingleEvent(of: .value, with: {(snapshot) in
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
            self.totalCount += 1
            self.allExploreObjects.append(exploreObject)
            dispatch.leave()
        })
    }
    
    override func viewDidAppear(_ animated: Bool) {
        pausePlayeVideos()
        self.isPaused = false
        self.playIcon.isHidden = true
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
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        pausePlayeVideos()
        self.playIcon.isHidden = true
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            pausePlayeVideos()
            self.playIcon.isHidden = true
        }
        
        if self.tutorialView.isHidden {
            return
        }
        
        self.tutorialView.isHidden = true
//        self.firstLoad = false
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
