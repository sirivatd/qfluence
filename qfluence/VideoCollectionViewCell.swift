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
    
    static let identifer = "VideoCollectionViewCell"
    
    private var model: VideoModel?
    
    // Labels
    private let usernameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.textColor = .white
        return label
    }()
    
    // Buttons
    private let profileButton: UIButton = {
        let profileButton = UIButton()
        return profileButton
    }()
    
    private let likeButton: UIButton = {
        let likeButton = UIButton()
        return likeButton
    }()
    
    private let commentButton: UIButton = {
        let commentButton = UIButton()
        return commentButton
    }()
    
    private let shareButton: UIButton = {
        let shareButton = UIButton()
        return shareButton
    }()
    
    // Delegate
    
    // Subviews
    var player: AVPlayer?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .black
        contentView.clipsToBounds = true
    }
    
    public func configure(with model: VideoModel) {
        self.model = model
        configureVideo()
    }
    
    private func configureVideo() {
        guard let model = model else {
            return
        }

        guard let path = Bundle.main.path(forResource: model.videoFileName, ofType: model.videoFileFormat) else {
            print(model.videoFileName)
            print(model.videoFileFormat)
            print("Cant find video")
            return
        }
        player = AVPlayer(url: URL(fileURLWithPath: path))
        
        let playerView = AVPlayerLayer()
        playerView.player = player
        playerView.frame = contentView.bounds
        playerView.videoGravity = .resizeAspectFill
        
        contentView.layer.addSublayer(playerView)
        player?.volume = 0
        player?.play()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
