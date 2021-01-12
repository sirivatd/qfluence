//
//  InfluencerHeaderTableViewCell.swift
//  qfluence
//
//  Created by Don Sirivat on 1/10/21.
//  Copyright © 2021 Don Sirivat. All rights reserved.
//

import UIKit

class InfluencerHeaderTableViewCell: UITableViewCell {
    @IBOutlet weak var instagramButton: UIButton!
    @IBOutlet weak var askQuestionButton: UIButton!
    @IBOutlet weak var bioText: UILabel!
    @IBOutlet weak var profilePicture: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        profilePicture.layer.borderWidth = 1
        profilePicture.layer.masksToBounds = false
        profilePicture.layer.borderColor = UIColor.black.cgColor
        profilePicture.layer.cornerRadius = profilePicture.frame.height/2
        profilePicture.clipsToBounds = true
        
        askQuestionButton.layer.cornerRadius = 5.0
        askQuestionButton.layer.borderWidth = 0.5
        askQuestionButton.layer.borderColor = UIColor.clear.cgColor
        askQuestionButton.layer.masksToBounds = true
        askQuestionButton.layer.shadowColor = UIColor.darkGray.cgColor
        askQuestionButton.layer.shadowOffset = CGSize(width: 0.5, height: 0.5)
        askQuestionButton.layer.shadowRadius = 1.0
        askQuestionButton.layer.shadowOpacity = 0.7
        askQuestionButton.layer.masksToBounds = false
        askQuestionButton.layer.shadowPath = UIBezierPath(roundedRect: askQuestionButton.bounds, cornerRadius: askQuestionButton.layer.cornerRadius).cgPath
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
