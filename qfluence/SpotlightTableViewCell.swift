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
    @IBOutlet weak var followButton: UIButton!
    
    var spotlightTableViewCellDelegate: SpotlightTableViewCellDelegate?
    
    @IBAction func followPressed(_  sender: UIButton) {
        spotlightTableViewCellDelegate?.didPressFollowButton(sender.tag)
    }
}

protocol SpotlightTableViewCellDelegate {
    func didPressFollowButton(_ tag: Int)
}
