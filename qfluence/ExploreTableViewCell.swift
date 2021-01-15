//
//  ExploreTableViewCell.swift
//  qfluence
//
//  Created by Don Sirivat on 1/14/21.
//  Copyright © 2021 Don Sirivat. All rights reserved.
//

import UIKit
import AVFoundation

class ExploreTableViewCell: UITableViewCell {
    @IBOutlet weak var videoPlayerSuperView: UIView!
    @IBOutlet weak var questionText: UITextView!
    @IBOutlet weak var subtitleText: UILabel!
    
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
        // Initialization code
        self.setupMoviePlayer()
    }
    
    func setupMoviePlayer() {
        self.avPlayer = AVPlayer.init(playerItem: self.videoPlayerItem)
        avPlayerLayer = AVPlayerLayer(player: avPlayer)
        avPlayerLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
        avPlayer?.volume = 3
        avPlayer?.actionAtItemEnd = .none
        
        avPlayerLayer?.frame = self.frame
        
        self.backgroundColor = .red
        self.videoPlayerSuperView.layer.insertSublayer(avPlayerLayer!, at: 0)
        NotificationCenter.default.addObserver(self,
                                                    selector: #selector(self.playerItemDidReachEnd(notification:)),
                                                    name: NSNotification.Name.AVPlayerItemDidPlayToEndTime,
                                                    object: avPlayer?.currentItem)
    }
    
    func stopPlayback(){
         self.avPlayer?.pause()
     }

     func startPlayback(){
         self.avPlayer?.play()
     }
    
    @objc func playerItemDidReachEnd(notification: Notification) {
        let p: AVPlayerItem = notification.object as! AVPlayerItem
        p.seek(to: CMTime.zero)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

}
