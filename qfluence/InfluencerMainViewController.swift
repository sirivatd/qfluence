//
//  InfluencerMainViewController.swift
//  qfluence
//
//  Created by Don Sirivat on 1/10/21.
//  Copyright © 2021 Don Sirivat. All rights reserved.
//

import UIKit

extension InfluencerMainViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "influencerHeader") as! InfluencerHeaderTableViewCell
            cell.bioText.text = "I'm so popular everybody loves me"
            cell.backgroundColor = UIColor.green
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "influencerVideo") as! InfluencerVideoTableViewCell
            cell.questionText.text = "What achievment are you most proud of?"
            cell.videoPreview.image = UIImage(named: "featured_elon")
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
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
}

class InfluencerMainViewController: UIViewController {
    
    var selectedInfluencerId: Int?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toQuestionModal" {
            if let destination = segue.destination as? QuestionViewController {
                destination.selectedInfluencerId = self.selectedInfluencerId!
            }
        }
    }
}
