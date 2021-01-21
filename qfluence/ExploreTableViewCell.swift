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
    
//    func setupMoviePlayer() {
//        self.avPlayer = AVPlayer.init(playerItem: self.videoPlayerItem)
//        avPlayerLayer = AVPlayerLayer(player: avPlayer)
//        avPlayerLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
//        avPlayer?.volume = 5
//        avPlayer?.actionAtItemEnd = .none
//
//        avPlayerLayer?.frame = self.videoPlayerSuperView.layer.bounds
//        self.videoPlayerSuperView.layer.insertSublayer(avPlayerLayer!, at: 0)
//
//        NotificationCenter.default.addObserver(self,
//                                                    selector: #selector(self.playerItemDidReachEnd(notification:)),
//                                                    name: NSNotification.Name.AVPlayerItemDidPlayToEndTime,
//                                                    object: avPlayer?.currentItem)
//    }
    
//    func stopPlayback(){
//         self.avPlayer?.pause()
//     }
//
//     func startPlayback(){
//         self.avPlayer?.play()
//     }
//
//    @objc func playerItemDidReachEnd(notification: Notification) {
//        let p: AVPlayerItem = notification.object as! AVPlayerItem
//        p.seek(to: CMTime.zero)
//    }
//
//    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//        // Configure the view for the selected state
//    }
//
//    override func layoutSubviews() {
//        self.avPlayerLayer?.frame = self.bounds
//    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let width: CGFloat = bounds.size.width
        let height: CGFloat = bounds.size.height
        videoLayer.frame = CGRect(x: 0, y: 0, width: width, height: height)
    }
}
