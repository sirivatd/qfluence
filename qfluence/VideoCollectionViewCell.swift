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
        label.font = UIFont(name: "Avenir Next", size: 17)
        return label
    }()
    
    private let questionLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.textColor = .white
        label.font = UIFont(name: "AvenirNext-Bold", size: 25)
        
        return label
    }()
    
    // Buttons
    private let profileButton: UIButton = {
        let profileButton = UIButton()
        profileButton.setBackgroundImage(UIImage(named: "icons8-user-30"), for: .normal)
        return profileButton
    }()
    
    private let likeButton: UIButton = {
        let likeButton = UIButton()
        likeButton.setBackgroundImage(UIImage(named: "icons8-facebook-like-30"), for: .normal)
        return likeButton
    }()
    
    private let commentButton: UIButton = {
        let commentButton = UIButton()
        commentButton.setBackgroundImage(UIImage(named: "icons8-chat-bubble-30"), for: .normal)
        return commentButton
    }()
    
    private let shareButton: UIButton = {
        let shareButton = UIButton()
        shareButton.setBackgroundImage(UIImage(named: "icons8-share-30"), for: .normal)
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
        let url = URL(string: "https://firebasestorage.googleapis.com/v0/b/qfluence.appspot.com/o/Any%20advice%20for%20getting%20into%20the%20beauty%20business.mp4?alt=media&token=39cba640-3409-49e2-9496-af50e237372e")
        player = AVPlayer(url: url!)
        
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
        let size = contentView.frame.size.width/11
        let width = contentView.frame.width
        let height = contentView.frame.height
        
        shareButton.frame = CGRect(x: width-size-15, y: size+50, width: size, height: size)
        commentButton.frame = CGRect(x: width-size-15, y: size*2+70, width: size, height: size)
        profileButton.frame = CGRect(x: width-size-15, y: size*3+90, width: size, height: size)
        likeButton.frame = CGRect(x: width-size-15, y: size*4+110, width: size, height: size)
        
        // Labels
        questionLabel.frame = CGRect(x: 10, y: height-200, width: width-size-10, height: 50)
        usernameLabel.frame = CGRect(x: 10, y: height-225, width: width-size-10, height: 50)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
