//
//  FollowTableViewCell.swift
//  qfluence
//
//  Created by Don Sirivat on 1/25/21.
//  Copyright © 2021 Don Sirivat. All rights reserved.
//

import UIKit

class FollowTableViewCell: UITableViewCell {
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var subtitle: UILabel!
    @IBOutlet weak var profilePicture: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.contentView.layer.cornerRadius = 15.0
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
