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
    
    override func prepareForReuse() {
        if self.featuredImage != nil {
            self.featuredImage.image = nil
        }
    }
}
