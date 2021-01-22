//
//  SpotlightTableViewCell.swift
//  qfluence
//
//  Created by Don Sirivat on 1/21/21.
//  Copyright © 2021 Don Sirivat. All rights reserved.
//

import UIKit
import LNParallaxTVCell

class SpotlightTableViewCell: LNParallaxTVCell {
    @IBOutlet weak var featuredLabel: UILabel!
    @IBOutlet weak var tintView: UIView!
    @IBOutlet weak var bioText: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        self.parallaxImage.image = nil
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
