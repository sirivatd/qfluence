//
//  InfluencerHeaderTableViewCell.swift
//  qfluence
//
//  Created by Don Sirivat on 1/10/21.
//  Copyright © 2021 Don Sirivat. All rights reserved.
//

import UIKit
import Canvas

class InfluencerHeaderTableViewCell: UITableViewCell {
    @IBOutlet weak var instagramButton: UIButton!
    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var bioText: UILabel!
    @IBOutlet weak var tintView: UIView!
    @IBOutlet weak var animationOne: CSAnimationView!
    @IBOutlet weak var animationTwo: CSAnimationView!
    @IBOutlet weak var animationThree: CSAnimationView!
    @IBOutlet weak var panelView: UIView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.layer.borderWidth = 1
        self.layer.masksToBounds = false
        self.layer.borderColor = UIColor.clear.cgColor
        self.layer.cornerRadius = 15
        
        profilePicture.layer.borderWidth = 1
        profilePicture.layer.masksToBounds = false
        profilePicture.layer.borderColor = UIColor.clear.cgColor
        profilePicture.layer.cornerRadius = 15
        tintView.layer.borderWidth = 1
        tintView.layer.masksToBounds = false
        tintView.layer.borderColor = UIColor.clear.cgColor
        tintView.layer.cornerRadius = 15
        
        self.profilePicture.clipsToBounds = true
        self.tintView.clipsToBounds = true
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}

