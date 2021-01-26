//
//  ExploreTableViewCell.swift
//  qfluence
//
//  Created by Don Sirivat on 1/14/21.
//  Copyright © 2021 Don Sirivat. All rights reserved.
//

import UIKit
import AVFoundation

class ExploreTableViewCell: UITableViewCell, ASAutoPlayVideoLayerContainer {
    var cellDelegate: ExploreTableViewCellDelegate?
    var videoURL: String? {
        didSet {
            if let videoURL = videoURL {
                ASVideoPlayerController.sharedVideoPlayer.setupVideoFor(url: videoURL)
            }
            videoLayer.isHidden = videoURL == nil
        }
    }
    
    var videoLayer: AVPlayerLayer = AVPlayerLayer()
    
    @IBOutlet weak var videoPlayerSuperView: UIView!
    @IBOutlet weak var questionText: UITextView!
    @IBOutlet weak var subtitleText: UILabel!
    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var logo: UIImageView!
    @IBOutlet weak var profileButton: UIButton!
    
    @IBAction func profilePressed(_ sender: UIButton) {
        cellDelegate?.didPressButton(sender.tag)
    }
    
    var avPlayer: AVPlayer?
    var avPlayerLayer: AVPlayerLayer?
    var paused: Bool = false
    var videoPlayerItem: AVPlayerItem? = nil {
        didSet {
            avPlayer?.replaceCurrentItem(with: self.videoPlayerItem)
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
//        self.setupMoviePlayer()
        videoLayer.backgroundColor = UIColor.clear.cgColor
        videoLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        videoPlayerSuperView.layer.addSublayer(videoLayer)
        selectionStyle = .none
    }
    
    
    func visibleVideoHeight() -> CGFloat {
        let videoFrameInParentSuperView: CGRect? = self.superview?.superview?.convert(videoPlayerSuperView.frame, from: videoPlayerSuperView)
        guard let videoFrame = videoFrameInParentSuperView,
            let superViewFrame = superview?.frame else {
             return 0
        }
        let visibleVideoFrame = videoFrame.intersection(superViewFrame)
        return visibleVideoFrame.size.height
    }
    
    func configureCell(videoUrl: String?) {
        self.videoURL = videoUrl
    }
    
    override func layoutSubviews() {
        let width: CGFloat = bounds.size.width
        let height: CGFloat = bounds.size.height
        videoLayer.frame = CGRect(x: 0, y: 0, width: width, height: height)
    }
}

protocol ExploreTableViewCellDelegate {
    func didPressButton(_ tag: Int)
}
