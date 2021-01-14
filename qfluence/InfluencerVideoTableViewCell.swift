//
//  InfluencerVideoTableViewCell.swift
//  qfluence
//
//  Created by Don Sirivat on 1/10/21.
//  Copyright © 2021 Don Sirivat. All rights reserved.
//

import UIKit

class InfluencerVideoTableViewCell: UITableViewCell {
    @IBOutlet weak var videoPreview: UIImageView!
    @IBOutlet weak var questionText: UITextView!
    @IBOutlet weak var cellView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        cellView.layer.borderWidth = 1
        cellView.layer.masksToBounds = false
        cellView.layer.borderColor = UIColor.clear.cgColor
        cellView.layer.cornerRadius = 15
        cellView.clipsToBounds = true
        cellView.layer.shadowColor = UIColor.black.cgColor
        cellView.layer.shadowRadius = 10.0
        cellView.layer.shadowOpacity = 1.0
        cellView.layer.shadowOffset = CGSize(width: 8, height: 8)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
