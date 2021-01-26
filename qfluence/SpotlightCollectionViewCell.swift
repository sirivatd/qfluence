//
//  SpotlightCollectionViewCell.swift
//  qfluence
//
//  Created by Don Sirivat on 12/14/20.
//  Copyright © 2020 Don Sirivat. All rights reserved.
//

import UIKit
import ScalingCarousel

class SpotlightCollectionViewCell: ScalingCarouselCell {
    @IBOutlet weak var popularImage: UIImageView!
    @IBOutlet weak var popularLabel: UILabel!
    
    @IBOutlet weak var featuredImage: UIImageView!
    @IBOutlet weak var featuredLabel: UILabel!
    @IBOutlet weak var tintView: UIView!
    @IBOutlet weak var followButton: UIButton!
    
    override func prepareForReuse() {
        if self.featuredLabel != nil {
            self.featuredLabel.text = ""
        }
        if self.featuredImage != nil {
            self.featuredImage.image = nil
        }
        if self.tintView != nil {
            self.tintView.layer.cornerRadius = 10.0
        }
    }
}
