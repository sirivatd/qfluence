//
//  ExploreViewController.swift
//  qfluence
//
//  Created by Don Sirivat on 1/14/21.
//  Copyright © 2021 Don Sirivat. All rights reserved.
//

import UIKit
import AVFoundation
import Firebase

struct QuestionObject {
    let questionText: String
    let videoUrl: String
    let imageUrl: String
}

class ExploreViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.videoURLs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "exploreCell") as! ExploreTableViewCell
//        cell.videoPlayerItem = AVPlayerItem.init(url: videoURLs[indexPath.row])
        cell.questionText.text = self.exploreObjects[indexPath.row].questionText
        cell.subtitleText.text = self.exploreObjects[indexPath.row].name
        cell.profilePicture.downloadImageFrom(link: self.exploreObjects[indexPath.row].imageUrl, contentMode: UIView.ContentMode.scaleAspectFill)
//
        cell.profilePicture.layer.borderWidth = 1
        cell.profilePicture.layer.masksToBounds = false
        cell.profilePicture.layer.borderColor = UIColor.clear.cgColor
        cell.profilePicture.layer.cornerRadius = cell.profilePicture.frame.height/2
        cell.profilePicture.clipsToBounds = true
        
        cell.configureCell(videoUrl: videoURLs[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.view.frame.height
       }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
           return 0
    }
    
    
//    func playVideoOnTheCell(cell : ExploreTableViewCell, indexPath : IndexPath){
//        cell.startPlayback()
//    }
//
//    func stopPlayBack(cell : ExploreTableViewCell, indexPath : IndexPath){
//        cell.stopPlayback()
//    }

//    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        print("end = \(indexPath)")
//        if let videoCell = cell as? ExploreTableViewCell {
//            videoCell.stopPlayback()
//        }
//    }
//    
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//           let indexPaths = self.exploreTableView.indexPathsForVisibleRows
//           var cells = [Any]()
//           for ip in indexPaths!{
//               if let videoCell = self.exploreTableView.cellForRow(at: ip) as? ExploreTableViewCell{
//                   cells.append(videoCell)
//               }
//           }
//           let cellCount = cells.count
//           if cellCount == 0 {return}
//           if cellCount == 1{
//               if visibleIP != indexPaths?[0]{
//                   visibleIP = indexPaths?[0]
//               }
//               if let videoCell = cells.last! as? ExploreTableViewCell{
//                   self.playVideoOnTheCell(cell: videoCell, indexPath: (indexPaths?.last)!)
//               }
//           }
//           if cellCount >= 2 {
//               for i in 0..<cellCount{
//                   let cellRect = self.exploreTableView.rectForRow(at: (indexPaths?[i])!)
//                   let intersect = cellRect.intersection(self.exploreTableView.bounds)
//   //                curerntHeight is the height of the cell that
//   //                is visible
//                   let currentHeight = intersect.height
//                   print("\n \(currentHeight)")
//                   let cellHeight = (cells[i] as AnyObject).frame.size.height
//   //                0.95 here denotes how much you want the cell to display
//   //                for it to mark itself as visible,
//   //                .95 denotes 95 percent,
//   //                you can change the values accordingly
//                   if currentHeight > (cellHeight * 0.95){
//                       if visibleIP != indexPaths?[i]{
//                           visibleIP = indexPaths?[i]
//                           if let videoCell = cells[i] as? ExploreTableViewCell{
//                               self.playVideoOnTheCell(cell: videoCell, indexPath: (indexPaths?[i])!)
//                           }
//                       }
//                   }
//                   else{
//                       if aboutToBecomeInvisibleCell != indexPaths?[i].row{
//                           aboutToBecomeInvisibleCell = (indexPaths?[i].row)!
//                           if let videoCell = cells[i] as? ExploreTableViewCell{
//                               self.stopPlayBack(cell: videoCell, indexPath: (indexPaths?[i])!)
//                           }
//
//                       }
//                   }
//               }
//           }
//       }
    
    var visibleIP : IndexPath?
    var aboutToBecomeInvisibleCell = -1
    var avPlayerLayer: AVPlayerLayer!
    var videoURLs = Array<String>()
    var exploreObjects = Array<SearchVideoResult>()
    
    @IBOutlet weak var exploreTableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        fetchVideos()
//        visibleIP = IndexPath.init(row: 0, section: 0)
        self.exploreTableView.isPagingEnabled = true
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.appEnteredFromBackground),
                                               name: UIApplication.willEnterForegroundNotification, object: nil)
    }
    
    func fetchVideos() {
        let videoRef = Database.database().reference(withPath: "videos").queryLimited(toLast: 10)
        videoRef.observeSingleEvent(of: .value, with: { (snapshot) in
            for video in snapshot.children {
                if let snapshot = video as? DataSnapshot {
                    let dict = snapshot.value as? NSDictionary
                    let questionText = dict!["questionText"] as! String
                    let videoUrlString = dict!["videoUrl"] as! String
                    let influencerId = dict!["influencerId"] as! Int
                        
                    self.findInfluencer(influencerId: influencerId, questionText: questionText, videoUrl: videoUrlString)
                }
            }
        })
    }
    
    func findInfluencer(influencerId: Int, questionText: String, videoUrl: String) {
        let ref = Database.database().reference(withPath: "influencers").child("\(influencerId)")
        ref.observeSingleEvent(of: .value, with: {(snapshot) in
            let influencer = snapshot.value as? NSDictionary
            
            let imageUrl = influencer!["imageUrl"] as? String
            let firstName = influencer!["firstName"] as? String
            let lastName = influencer!["lastName"] as? String
            
            var name: String?
            
            if lastName?.lowercased() == "n/a" {
                name = firstName
            } else {
                name = firstName! + " " + lastName!
            }
            
            let exploreObject = SearchVideoResult(imageUrl: imageUrl!, name: name!, videoUrl: videoUrl, questionText: questionText)
            
            self.exploreObjects.append(exploreObject)
            self.videoURLs.append(videoUrl)
            self.exploreTableView.reloadData()
        })
    }
    
    override func viewDidAppear(_ animated: Bool) {
        pausePlayeVideos()
    }
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let videoCell = cell as? ASAutoPlayVideoLayerContainer, let _ = videoCell.videoURL {
            ASVideoPlayerController.sharedVideoPlayer.removeLayerFor(cell: videoCell)
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        pausePlayeVideos()
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            pausePlayeVideos()
        }
    }
    
    func pausePlayeVideos(){
        ASVideoPlayerController.sharedVideoPlayer.pausePlayeVideosFor(tableView: self.exploreTableView)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        ASVideoPlayerController.sharedVideoPlayer.pauseAllVideos(tableView: self.exploreTableView)
    }
    
    @objc func appEnteredFromBackground() {
        ASVideoPlayerController.sharedVideoPlayer.pausePlayeVideosFor(tableView: self.exploreTableView, appEnteredFromBackground: true)
    }
    
//    override func viewWillDisappear(_ animated: Bool) {
//        let indexPaths = self.exploreTableView.indexPathsForVisibleRows
//
//        for i in indexPaths! {
//            let cell = self.exploreTableView.cellForRow(at: i) as? ExploreTableViewCell
//            cell?.stopPlayback()
//        }
//    }
    
//    override func viewWillAppear(_ animated: Bool) {
//        let indexPaths = self.exploreTableView.indexPathsForVisibleRows
//        var cells = [Any]()
//
//        if indexPaths != nil {
//            for ip in indexPaths!{
//                if let videoCell = self.exploreTableView.cellForRow(at: ip) as? ExploreTableViewCell{
//                    cells.append(videoCell)
//                }
//            }
//
//            if let videoCell = cells.first as? ExploreTableViewCell{
//                self.playVideoOnTheCell(cell: videoCell, indexPath: (indexPaths?[0])!)
//            }
//        }
//    }
}
