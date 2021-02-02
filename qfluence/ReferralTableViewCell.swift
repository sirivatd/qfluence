//
//  ReferralTableViewCell.swift
//  qfluence
//
//  Created by Don Sirivat on 2/1/21.
//  Copyright © 2021 Don Sirivat. All rights reserved.
//

import UIKit

class ReferralTableViewCell: UITableViewCell {

    @IBOutlet weak var becomeAQfluencer: UIButton!
    
    @IBAction func actionPressed(_ sender: Any) {
        let email = "hello@qfluencer.com"
        if let url = URL(string: "mailto:\(email)") {
          UIApplication.shared.openURL(url)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
