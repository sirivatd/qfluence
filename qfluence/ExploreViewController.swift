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

class ExploreViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.videoURLs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.exploreTableView.dequeueReusableCell(withIdentifier: "exploreCell") as! ExploreTableViewCell
        cell.videoPlayerItem = AVPlayerItem.init(url: videoURLs[indexPath.row])
        cell.questionText.text = self.exploreObjects[indexPath.row].questionText
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.view.frame.height
       }

       func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
           return 0
       }
    
    func playVideoOnTheCell(cell : ExploreTableViewCell, indexPath : IndexPath){
        cell.startPlayback()
    }

    func stopPlayBack(cell : ExploreTableViewCell, indexPath : IndexPath){
        cell.stopPlayback()
    }

    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        print("end = \(indexPath)")
        if let videoCell = cell as? ExploreTableViewCell {
            videoCell.stopPlayback()
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
           let indexPaths = self.exploreTableView.indexPathsForVisibleRows
           var cells = [Any]()
           for ip in indexPaths!{
               if let videoCell = self.exploreTableView.cellForRow(at: ip) as? ExploreTableViewCell{
                   cells.append(videoCell)
               }
           }
           let cellCount = cells.count
           if cellCount == 0 {return}
           if cellCount == 1{
               if visibleIP != indexPaths?[0]{
                   visibleIP = indexPaths?[0]
               }
               if let videoCell = cells.last! as? ExploreTableViewCell{
                   self.playVideoOnTheCell(cell: videoCell, indexPath: (indexPaths?.last)!)
               }
           }
           if cellCount >= 2 {
               for i in 0..<cellCount{
                   let cellRect = self.exploreTableView.rectForRow(at: (indexPaths?[i])!)
                   let intersect = cellRect.intersection(self.exploreTableView.bounds)
   //                curerntHeight is the height of the cell that
   //                is visible
                   let currentHeight = intersect.height
                   print("\n \(currentHeight)")
                   let cellHeight = (cells[i] as AnyObject).frame.size.height
   //                0.95 here denotes how much you want the cell to display
   //                for it to mark itself as visible,
   //                .95 denotes 95 percent,
   //                you can change the values accordingly
                   if currentHeight > (cellHeight * 0.95){
                       if visibleIP != indexPaths?[i]{
                           visibleIP = indexPaths?[i]
                           print ("visible = \(indexPaths?[i])")
                           if let videoCell = cells[i] as? ExploreTableViewCell{
                               self.playVideoOnTheCell(cell: videoCell, indexPath: (indexPaths?[i])!)
                           }
                       }
                   }
                   else{
                       if aboutToBecomeInvisibleCell != indexPaths?[i].row{
                           aboutToBecomeInvisibleCell = (indexPaths?[i].row)!
                           if let videoCell = cells[i] as? ExploreTableViewCell{
                               self.stopPlayBack(cell: videoCell, indexPath: (indexPaths?[i])!)
                           }

                       }
                   }
               }
           }
       }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        if scrollView == self.exploreTableView {
            let cellHeight = CGFloat(self.view.frame.height)
                let y          = targetContentOffset.pointee.y + scrollView.contentInset.top + (cellHeight / 2)
                let cellIndex  = floor(y / cellHeight)
                targetContentOffset.pointee.y = cellIndex * cellHeight - scrollView.contentInset.top
            }
        }
    
    var visibleIP : IndexPath?
    var aboutToBecomeInvisibleCell = -1
    var avPlayerLayer: AVPlayerLayer!
    var videoURLs = Array<URL>()
    var exploreObjects = Array<QuestionObject>()
    
    @IBOutlet weak var exploreTableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        fetchVideos()
        visibleIP = IndexPath.init(row: 0, section: 0)

        // Do any additional setup after loading the view.
    }
    
    func fetchVideos() {
        let videoRef = Database.database().reference(withPath: "videos")
        videoRef.observeSingleEvent(of: .value, with: { (snapshot) in
            var videoData = snapshot.value as! [[String : Any]]
            videoData.shuffle()
            videoData = Array(videoData[0..<10])
            
            for video in videoData {
                let questionText = video["questionText"] as! String
                let videoUrlString = video["videoUrl"] as! String
                let imageUrlString = video["imageUrl"] as! String
                    
                let questionObject = QuestionObject(questionText: questionText, videoUrl: videoUrlString, imageUrl: imageUrlString)
                    
                self.exploreObjects.append(questionObject)
                self.videoURLs.append(URL(string: videoUrlString)!)
            }
            
            self.exploreTableView.reloadData()
        })
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        for i in 0...self.exploreObjects.count-1 {
            let cell = self.exploreTableView.cellForRow(at: IndexPath.init(row: i, section: 0)) as? ExploreTableViewCell
            cell?.stopPlayback()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let indexPaths = self.exploreTableView.indexPathsForVisibleRows
        var cells = [Any]()
        
        if indexPaths != nil {
            for ip in indexPaths!{
                if let videoCell = self.exploreTableView.cellForRow(at: ip) as? ExploreTableViewCell{
                    cells.append(videoCell)
                }
            }
            
            if let videoCell = cells.first as? ExploreTableViewCell{
                self.playVideoOnTheCell(cell: videoCell, indexPath: (indexPaths?[0])!)
            }
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
