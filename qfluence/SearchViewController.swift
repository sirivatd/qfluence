//
//  SearchViewController.swift
//  qfluence
//
//  Created by Don Sirivat on 1/11/21.
//  Copyright © 2021 Don Sirivat. All rights reserved.
//

import UIKit
import Firebase
import Canvas
import ScalingCarousel
import AVKit

struct SearchVideoResult {
    let imageUrl: String
    let name: String
    let videoUrl: String
    let questionText: String
}

class SearchViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.videoCollectionView {
            return self.matchesVideos.count
        } else if collectionView == self.peopleCollectionView {
            return self.matchedInfluencers.count
        } else {
            return self.recentlyAdded.count
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.recentlyAddedView.didScroll()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        if collectionView == self.videoCollectionView {
            // play video
            let videoUrlString = self.matchesVideos[indexPath.row].videoUrl
            
            let url = URL(string: videoUrlString)
            playerView = AVPlayer(url: url as! URL)
            playerViewController.player = playerView
            
            // present player view controller
            self.present(playerViewController, animated: true) {
                self.playerViewController.player?.play()
            }
        } else if collectionView == self.peopleCollectionView {
            // send to influencer page
            self.selectedInfluencer = self.matchedInfluencers[indexPath.row]
            self.performSegue(withIdentifier: "toInfluencer", sender: nil)
        } else {
            // send to influencer page
            self.selectedInfluencer = self.recentlyAdded[indexPath.row]
            self.performSegue(withIdentifier: "toInfluencer", sender: nil)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.videoCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "videoCell", for: indexPath) as! QuestionCollectionViewCell
            cell.questionText.text = self.matchesVideos[indexPath.row].questionText
            cell.profilePicture.downloadImageFrom(link: self.matchesVideos[indexPath.row].imageUrl, contentMode: UIView.ContentMode.scaleAspectFill)
            cell.profilePicture.layer.borderWidth = 1
            cell.profilePicture.layer.masksToBounds = false
            cell.profilePicture.layer.borderColor = UIColor.clear.cgColor
            cell.profilePicture.layer.cornerRadius = cell.profilePicture.frame.height/2
            cell.profilePicture.clipsToBounds = true
            cell.name.text = self.matchesVideos[indexPath.row].name
            
            if indexPath.row % 2 == 0 {
                cell.cellBackground.image = UIImage(named: "q_red_cell_0")
                } else {
                cell.cellBackground.image = UIImage(named: "q_black_cell_0")
                }

            return cell
        } else if collectionView == self.peopleCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "personCell", for: indexPath) as! SpotlightCollectionViewCell
            cell.featuredImage.downloadImageFrom(link: self.matchedInfluencers[indexPath.row].imageUrl, contentMode: UIView.ContentMode.scaleAspectFill)
            cell.featuredLabel.text = self.matchedInfluencers[indexPath.row].label
            cell.contentView.layer.cornerRadius = 5.0
            cell.contentView.layer.borderWidth = 0.5
            cell.contentView.layer.borderColor = UIColor.clear.cgColor
            cell.contentView.layer.masksToBounds = true

            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "recentlyAddedCell", for: indexPath) as! SpotlightCollectionViewCell
            cell.featuredImage.downloadImageFrom(link: self.recentlyAdded[indexPath.row].imageUrl, contentMode: UIView.ContentMode.scaleAspectFill)
            cell.featuredLabel.text = self.recentlyAdded[indexPath.row].label
            cell.contentView.layer.cornerRadius = 10.0
            cell.contentView.layer.borderWidth = 3.0
            cell.contentView.layer.borderColor = UIColor.clear.cgColor
            cell.contentView.layer.masksToBounds = true
            
            cell.featuredImage.layer.cornerRadius = 10.0
            cell.featuredImage.layer.masksToBounds = true
            cell.tintView.layer.cornerRadius = 10.0
            cell.tintView.layer.masksToBounds = true
            
            cell.setNeedsLayout()
            cell.layoutIfNeeded()
            
            return cell
        }
    }
    
    @IBOutlet weak var searchField: UITextField!
    @IBOutlet weak var peopleCollectionView: UICollectionView!
    @IBOutlet weak var videoCollectionView: UICollectionView!
    @IBOutlet weak var recentlyAddedView: ScalingCarouselView!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var peopleLabel: UILabel!
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var peopleCount: AnimatedLabel!
    @IBOutlet weak var questionCount: AnimatedLabel!
    @IBOutlet weak var resultsView: CSAnimationView!
    @IBOutlet var initialView: UIView!
    
    @IBAction func searchPressed(_ sender: Any) {
        self.view.endEditing(true)
        if searchField.text == "" {
            return
        }
        
        self.resultsView.isHidden = true
        self.displayLoading()
        self.processSearch(queryString: searchField.text!)
    }
    
    private var influencers = [SpotlightObject]()
    private var videos = [SearchVideoResult]()
    private var matchedInfluencers = [SpotlightObject]()
    private var matchesVideos = [SearchVideoResult]()
    private var recentlyAdded = [SpotlightObject]()
    var playerViewController = AVPlayerViewController()
    var playerView = AVPlayer()
    var selectedInfluencer: SpotlightObject?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        searchButton.layer.cornerRadius = 10
        searchField.layer.cornerRadius = 10
        resultsView.isHidden = true
        
        fetchData()
        initializeHideKeyboard()
    }
    
    let loadingIndicator: ProgressView = {
        let progress = ProgressView(colors: [.red, .orange, .darkGray], lineWidth: 5)
        progress.translatesAutoresizingMaskIntoConstraints = false
        return progress
    }()
    
    func fetchData() {
        // fetch people
        let influencerRef = Database.database().reference(withPath: "influencers")
        influencerRef.observeSingleEvent(of: .value, with: { (snapshot) in
            let influencerData = snapshot.value as! [[String : Any]]

            for influencer in influencerData {
                let firstName = influencer["firstName"] as! String
                let lastName = influencer["lastName"] as! String
                var influencerName: String?
                if lastName.lowercased() == "n/a" {
                    influencerName = firstName
                } else {
                    influencerName = firstName + " " + lastName
                }
                
                let featuredObject = SpotlightObject(imageUrl: influencer["imageUrl"] as! String, label: influencerName!, influencerId: influencer["influencerId"] as! Int)
                
                self.influencers.append(featuredObject)
                self.recentlyAdded.append(featuredObject)
            }
        })
        
        // fetch videos
        let videoRef = Database.database().reference(withPath: "videos")
        videoRef.observeSingleEvent(of: .value, with: { (snapshot) in
            for video in snapshot.children {
                if let snapshot = video as? DataSnapshot {
                    let dict = snapshot.value as? NSDictionary
                    let influencerId = dict!["influencerId"] as! Int
                    let questionText = dict!["questionText"] as! String
                    let videoUrlString = dict!["videoUrl"] as! String
                    
                    let influencer = self.findInfluencer(influencerId: influencerId)
                    let imageUrlString = influencer.imageUrl
                    let name = influencer.label
                    
                    let videoObject = SearchVideoResult(imageUrl: imageUrlString, name: name, videoUrl: videoUrlString, questionText: questionText)
                    self.videos.append(videoObject)
                }
            }
            self.recentlyAddedView.reloadData()
            self.updateMetricLabels(people: self.influencers.count, questions: self.videos.count)
        })
    }
    
    func findInfluencer(influencerId: Int) -> SpotlightObject {
        let ref = Database.database().reference(withPath: "influencers").child("\(influencerId)")
        let filtered = self.influencers.filter { (influencer) -> Bool in
            influencer.influencerId == influencerId
        }
        
        return filtered.first!
    }
    
    func updateMetricLabels(people: Int, questions: Int) {
        self.peopleCount.countFromZero(to: Float(people))
        self.questionCount.countFromZero(to: Float(questions))
    }
    
    func displayLoading() {
        self.view.addSubview(self.loadingIndicator)
        NSLayoutConstraint.activate([
            loadingIndicator.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            loadingIndicator.widthAnchor.constraint(equalToConstant: 50),
            loadingIndicator.heightAnchor.constraint(equalTo: self.loadingIndicator.widthAnchor)
            ])
        self.loadingIndicator.isAnimating = true
    }
    
    func stopLoading() {
        self.loadingIndicator.removeFromSuperview()
    }
    
    func processSearch(queryString: String) {
        self.matchedInfluencers = self.influencers.filter{ (influencer: SpotlightObject) -> Bool in
            let influencerText = influencer.label.lowercased().removeWhitespace()
            let query = queryString.lowercased().removeWhitespace()
            
            return influencerText.contains(query)
        }
        self.matchesVideos = self.videos.filter { (video: SearchVideoResult) -> Bool in
            return video.questionText.lowercased().contains(queryString.lowercased())
        }
        
        self.initialView.isHidden = true
        self.updateResults()
    }
    
    func updateResults() {
        self.peopleLabel.text = "PEOPLE (\(self.matchedInfluencers.count))"
        self.questionLabel.text = "QUESTIONS (\(self.matchesVideos.count))"
        
        self.loadingIndicator.isHidden = true
        self.peopleCollectionView.reloadData()
        self.videoCollectionView.reloadData()
        
        self.resultsView.isHidden = false
        self.resultsView.startCanvasAnimation()
    }
    
    func initializeHideKeyboard() {
//        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissMyKeyboard))
//        self.view.addGestureRecognizer(tap)
    }
    
    @objc func dismissMyKeyboard() {
        view.endEditing(true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: animated)
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        self.recentlyAddedView.deviceRotated()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toInfluencer" {
            if let destination = segue.destination as? InfluencerMainViewController {
                destination.title = selectedInfluencer!.label
                destination.selectedInfluencerId = selectedInfluencer!.influencerId
            }
        }
    }
}

extension String {
   func replace(string:String, replacement:String) -> String {
       return self.replacingOccurrences(of: string, with: replacement, options: NSString.CompareOptions.literal, range: nil)
   }

   func removeWhitespace() -> String {
       return self.replace(string: " ", replacement: "")
   }
 }
