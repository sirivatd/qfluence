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
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}

