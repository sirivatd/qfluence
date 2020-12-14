//
//  VideoCollectionViewCell.swift
//  qfluence
//
//  Created by Don Sirivat on 12/12/20.
//  Copyright © 2020 Don Sirivat. All rights reserved.
//

import UIKit
import AVFoundation

protocol VideoCollectionViewCellDelegate: AnyObject {
    func didTapLikeButton(with model: VideoModel)
    func didTapProfileButton(with model: VideoModel)
    func didTapShareButton(with model: VideoModel)
    func didTapCommentButton(with model: VideoModel)
}

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
    
    private let questionLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .white
        return label
    }()
    
    // Buttons
    private let profileButton: UIButton = {
        let profileButton = UIButton()
        profileButton.setBackgroundImage(UIImage(named: "profile_button"), for: .normal)
        return profileButton
    }()
    
    private let likeButton: UIButton = {
        let likeButton = UIButton()
        likeButton.setBackgroundImage(UIImage(named: "person.circle"), for: .normal)
        return likeButton
    }()
    
    private let commentButton: UIButton = {
        let commentButton = UIButton()
        commentButton.setBackgroundImage(UIImage(named: "person.circle"), for: .normal)
        return commentButton
    }()
    
    private let shareButton: UIButton = {
        let shareButton = UIButton()
        shareButton.setBackgroundImage(UIImage(named: "person.circle"), for: .normal)
        return shareButton
    }()
    
    // Delegate
    weak var delegate: VideoCollectionViewCellDelegate?
    
    // Subviews
    var player: AVPlayer?
    
    private let videoContainer = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .black
        contentView.clipsToBounds = true
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        questionLabel.text = nil
        usernameLabel.text = nil
    }
    
    public func configure(with model: VideoModel) {
        self.model = model
        configureVideo()
        configureLabels()
        addSubviews()
    }
    
    private func configureLabels() {
        usernameLabel.text = "Tobias Harris"
        questionLabel.text = "What's your favorite food?"
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
        
        videoContainer.layer.addSublayer(playerView)
        player?.volume = 0
        player?.play()
    }
    
    private func addSubviews() {
        contentView.addSubview(videoContainer)
        
        contentView.addSubview(usernameLabel)
        contentView.addSubview(questionLabel)
        
        contentView.addSubview(profileButton)
        contentView.addSubview(likeButton)
        contentView.addSubview(commentButton)
        contentView.addSubview(shareButton)
        
        // Add actions
        likeButton.addTarget(self, action: #selector(didTapLikeButton), for: .touchDown)
        profileButton.addTarget(self, action: #selector(didTapProfileButton), for: .touchDown)
        commentButton.addTarget(self, action: #selector(didTapCommentButton), for: .touchDown)
        shareButton.addTarget(self, action: #selector(didTapShareButton), for: .touchDown)
        
        videoContainer.clipsToBounds = true
        contentView.sendSubviewToBack(videoContainer)
    }
    
    @objc private func didTapLikeButton() {
        guard let model = model else { return }
        delegate?.didTapLikeButton(with: model)
    }
    
    @objc private func didTapShareButton() {
        guard let model = model else { return }
        delegate?.didTapShareButton(with: model)
    }
    
    @objc private func didTapProfileButton() {
        guard let model = model else { return }
        delegate?.didTapProfileButton(with: model)
    }
    
    @objc private func didTapCommentButton() {
        guard let model = model else { return }
        delegate?.didTapCommentButton(with: model)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        videoContainer.frame = contentView.bounds
        
        // Buttons
        let size = contentView.frame.size.width/8
        let width = contentView.frame.width
        let height = contentView.frame.height
        
        shareButton.frame = CGRect(x: width-size, y: height-size, width: size, height: size)
        commentButton.frame = CGRect(x: width-size, y: height-(size*2)-10, width: size, height: size)
        profileButton.frame = CGRect(x: width-size, y: height-(size*3)-10, width: size, height: size)
        likeButton.frame = CGRect(x: width-size, y: height-(size*4)-10, width: size, height: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
