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

class SearchViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.videoCollectionView {
            return self.matchesVideos.count
        } else {
            return self.matchedInfluencers.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.videoCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "videoCell", for: indexPath) as! QuestionCollectionViewCell
            cell.questionText.text = self.matchesVideos[indexPath.row].questionText
            cell.contentView.layer.cornerRadius = 5.0
            cell.contentView.layer.borderWidth = 0.5
            cell.contentView.layer.borderColor = UIColor.clear.cgColor
            cell.contentView.layer.masksToBounds = true
            cell.layer.shadowColor = UIColor.darkGray.cgColor
            cell.layer.shadowOffset = CGSize(width: 0.5, height: 0.5)
            cell.layer.shadowRadius = 1.0
            cell.layer.shadowOpacity = 0.7
            cell.layer.masksToBounds = false
            cell.layer.shadowPath = UIBezierPath(roundedRect: cell.bounds, cornerRadius: cell.contentView.layer.cornerRadius).cgPath

            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "personCell", for: indexPath) as! SpotlightCollectionViewCell
            print(self.matchedInfluencers)
            cell.featuredImage.image = self.matchedInfluencers[indexPath.row].image
            cell.featuredLabel.text = self.matchedInfluencers[indexPath.row].label
            cell.contentView.layer.cornerRadius = 5.0
            cell.contentView.layer.borderWidth = 0.5
            cell.contentView.layer.borderColor = UIColor.clear.cgColor
            cell.contentView.layer.masksToBounds = true
            cell.layer.shadowColor = UIColor.darkGray.cgColor
            cell.layer.shadowOffset = CGSize(width: 0.5, height: 0.5)
            cell.layer.shadowRadius = 1.0
            cell.layer.shadowOpacity = 0.7
            cell.layer.masksToBounds = false
            cell.layer.shadowPath = UIBezierPath(roundedRect: cell.bounds, cornerRadius: cell.contentView.layer.cornerRadius).cgPath

            return cell
        }
    }
    
    @IBOutlet weak var searchField: UITextField!
    @IBOutlet weak var peopleCollectionView: UICollectionView!
    @IBOutlet weak var videoCollectionView: UICollectionView!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var peopleLabel: UILabel!
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var metricView: UIView!
    @IBOutlet weak var peopleCount: AnimatedLabel!
    @IBOutlet weak var questionCount: AnimatedLabel!
    @IBOutlet weak var resultsView: CSAnimationView!
    
    @IBAction func searchPressed(_ sender: Any) {
        self.view.endEditing(true)
        if searchField.text == "" {
            return
        }
        
        self.resultsView.isHidden = true
        self.metricView.isHidden = true
        self.displayLoading()
        self.processSearch(queryString: searchField.text!)
    }
    
    private var influencers = [SpotlightObject]()
    private var videos = [QuestionObject]()
    private var matchedInfluencers = [SpotlightObject]()
    private var matchesVideos = [QuestionObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        searchField.leftViewMode = UITextField.ViewMode.always
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        let image = UIImage(named: "icons8-search-60")?.withTintColor(.lightGray)
        imageView.image = image
        searchField.leftView = imageView
        searchButton.layer.cornerRadius = 10
        
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
                let url = URL(string: influencer["imageUrl"] as! String)
                let data = try? Data(contentsOf: url!)
                let firstName = influencer["firstName"] as! String
                let lastName = influencer["lastName"] as! String
                let influencerName = firstName + " " + lastName
                let featuredObject = SpotlightObject(image: UIImage(data: data!)!, label: influencerName, influencerId: influencer["influencerId"] as! Int)
                
                self.influencers.append(featuredObject)
            }
        })
        
        // fetch videos
        let videoRef = Database.database().reference(withPath: "videos")
        videoRef.observeSingleEvent(of: .value, with: { (snapshot) in
            let videoData = snapshot.value as! [[String : Any]]
            
            for video in videoData {
                let questionText = video["questionText"] as! String
                let videoUrlString = video["videoUrl"] as! String
                let imageUrlString = video["imageUrl"] as! String
                    
                let questionObject = QuestionObject(questionText: questionText, videoUrl: videoUrlString, imageUrl: imageUrlString)
                    
                self.videos.append(questionObject)
            }

            self.updateMetricLabels(people: self.influencers.count, questions: self.videos.count)
        })
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
        for influencer in self.influencers {
            let searchString = influencer.label
            if searchString.contains(queryString) {
                self.matchedInfluencers.append(influencer)
            }
        }
        
        for video in self.videos {
            let searchString = video.questionText
            if searchString.contains(queryString) {
                self.matchesVideos.append(video)
            }
        }
        
        self.updateResults()
    }
    
    func updateResults() {
        self.peopleLabel.text = "People (\(self.matchedInfluencers.count) matches)"
        self.questionLabel.text = "Questions (\(self.matchesVideos.count) matches)"
        
        self.loadingIndicator.isHidden = true
        self.peopleCollectionView.reloadData()
        self.videoCollectionView.reloadData()
        
        self.resultsView.isHidden = false
        self.resultsView.startCanvasAnimation()
    }
    
    func initializeHideKeyboard() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissMyKeyboard))
        self.view.addGestureRecognizer(tap)
    }
    
    @objc func dismissMyKeyboard() {
        view.endEditing(true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: animated)
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
}
