//
//  QuestionViewController.swift
//  qfluence
//
//  Created by Don Sirivat on 1/10/21.
//  Copyright © 2021 Don Sirivat. All rights reserved.
//

import UIKit
import FirebaseDatabase
import AVKit

struct QuestionObject {
    let questionText: String
    let videoUrl: String
    let imageUrl: String
}

class QuestionViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var playerViewController = AVPlayerViewController()
    var playerView = AVPlayer()
    var questionObjects: [QuestionObject]?
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return questionObjects!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "questionCell") as! QuestionTableViewCell
        cell.questionTextView.text = questionObjects![indexPath.row].questionText
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let videoUrl = questionObjects![indexPath.row].videoUrl
        
        let url = URL(string: videoUrl)
        playerView = AVPlayer(url: url as! URL)
        playerViewController.player = playerView
        
        // present player view controller
        self.present(playerViewController, animated: true) {
            self.playerViewController.player?.play()
        }
    }
    
    @IBOutlet weak var popupView: UIView!
    @IBOutlet weak var questionTableView: UITableView!
    
    @IBAction func closePressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    var selectedInfluencerId: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        popupView.layer.borderWidth = 1
        popupView.layer.masksToBounds = false
        popupView.layer.borderColor = UIColor.clear.cgColor
        popupView.layer.cornerRadius = 15
        
        populateQuestionObjects()
    }
    
    func populateQuestionObjects() {
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
                }
            }
            self.questionTableView.reloadData()
        })
    }
}
