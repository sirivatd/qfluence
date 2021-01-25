//
//  SettingOptionTableViewCell.swift
//  qfluence
//
//  Created by Don Sirivat on 1/25/21.
//  Copyright © 2021 Don Sirivat. All rights reserved.
//

import UIKit

class SettingOptionTableViewCell: UITableViewCell {
    @IBOutlet weak var settingImage: UIImageView!
    @IBOutlet weak var settingLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
