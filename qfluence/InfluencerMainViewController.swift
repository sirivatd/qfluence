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
            return 250
        } else {
            return 200
        }
    }
}

class InfluencerMainViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
