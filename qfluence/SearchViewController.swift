//
//  SearchViewController.swift
//  qfluence
//
//  Created by Don Sirivat on 1/11/21.
//  Copyright © 2021 Don Sirivat. All rights reserved.
//

import UIKit
import Firebase

class SearchViewController: UIViewController {
    @IBOutlet weak var searchField: UITextField!
    @IBOutlet weak var peopleCollectionView: UICollectionView!
    @IBOutlet weak var videoCollectionView: UICollectionView!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var peopleLabel: UILabel!
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var metricView: UIView!
    @IBOutlet weak var peopleCount: AnimatedLabel!
    @IBOutlet weak var questionCount: AnimatedLabel!
    
    @IBAction func searchPressed(_ sender: Any) {
    }
    
    private var influencers = [InfluencerObject]()
    private var videos = [QuestionObject]()
    private var matchedInfluencers = [InfluencerObject]()
    private var matchesVideos = [QuestionObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        searchField.leftViewMode = UITextField.ViewMode.always
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        let image = UIImage(named: "icons8-search-60")?.withTintColor(.lightGray)
        imageView.image = image
        searchField.leftView = imageView
        searchButton.layer.cornerRadius = 10
        
        peopleLabel.isHidden = true
        questionLabel.isHidden = true
        peopleCollectionView.isHidden = true
        videoCollectionView.isHidden = true
        
        fetchData()
        initializeHideKeyboard()
    }
    
    func fetchData() {
        // fetch people
        let influencerRef = Database.database().reference(withPath: "influencers")
        influencerRef.observeSingleEvent(of: .value, with: { (snapshot) in
            let influencerData = snapshot.value as! [[String : Any]]

            for influencer in influencerData {
                let imageUrlString = influencer["imageUrl"] as? String ?? ""
                let bioText = influencer["bioText"] as? String ?? ""
                let category = influencer["category"] as? String ?? ""
                let email = influencer["email"] as? String ?? ""
                let firstName = influencer["firstName"] as? String ?? ""
                let lastName = influencer["lastName"] as? String ?? ""
                let instagramLink = influencer["instagramLink"] as? String ?? ""
                let otherLink = influencer["otherLink"] as? String ?? ""
                let influencerId = influencer["influencerId"] as! Int
                
                let influencerObject = InfluencerObject(bioText: bioText, category: category, email: email, firstName: firstName, lastName: lastName, instagramLink: instagramLink, otherLink: otherLink, imageUrl: imageUrlString, influencerId: influencerId)
                self.influencers.append(influencerObject)
            }
        })
        
        // fetch videos
        let videoRef = Database.database().reference(withPath: "videos")
        videoRef.observeSingleEvent(of: .value, with: { (snapshot) in
            let videoData = snapshot.value as! [[String : Any]]
            
            for video in videoData {
                let influencerId = video["influencerId"] as! Int
                let questionText = video["questionText"] as! String
                let videoUrlString = video["videoUrl"] as! String
                let imageUrlString = video["imageUrl"] as! String
                    
                let questionObject = QuestionObject(questionText: questionText, videoUrl: videoUrlString, imageUrl: imageUrlString)
                    
                self.videos.append(questionObject)
            }
            
            print(self.videos)
            print(self.influencers)
            self.updateMetricLabels(people: self.influencers.count, questions: self.videos.count)
        })
    }
    
    func updateMetricLabels(people: Int, questions: Int) {
        self.peopleCount.countFromZero(to: Float(people))
        self.questionCount.countFromZero(to: Float(questions))
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
