//
//  VideoCollectionViewCell.swift
//  qfluence
//
//  Created by Don Sirivat on 12/12/20.
//  Copyright © 2020 Don Sirivat. All rights reserved.
//

import UIKit
import AVFoundation

class VideoCollectionViewCell: UICollectionViewCell {
    
    static let identifer = "What is your personal favorite dish?"
    // Subviews
    var player: AVPlayer?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func configure(with model: VideoModel) {
        contentView.backgroundColor = .red
    }
}
