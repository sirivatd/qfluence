//
//  InfluencerVideoTableViewCell.swift
//  qfluence
//
//  Created by Don Sirivat on 1/10/21.
//  Copyright © 2021 Don Sirivat. All rights reserved.
//

import UIKit

class InfluencerVideoTableViewCell: UITableViewCell {
    @IBOutlet weak var questionText: UILabel!
    @IBOutlet weak var videoPreview: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        videoPreview.layer.borderWidth = 1
        videoPreview.layer.masksToBounds = false
        videoPreview.layer.borderColor = UIColor.clear.cgColor
        videoPreview.layer.cornerRadius = videoPreview.frame.height / 2
        videoPreview.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
