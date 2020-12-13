//
//  ViewController.swift
//  qfluence
//
//  Created by Don Sirivat on 12/12/20.
//  Copyright © 2020 Don Sirivat. All rights reserved.
//

import UIKit

struct VideoModel {
    let question: String
    let username: String
    let videoFileName: String
    let videoFileFormat: String
}

class ViewController: UIViewController {
    
    private var collectionView: UICollectionView?

    private var data = [VideoModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for _ in 0..<10 {
            let model = VideoModel(question: "What is your favorite intrument to play?", username: "Tobias Harris", videoFileName: "blah", videoFileFormat: "mp4")
            data.append(model)
        }
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: view.frame.width, height: view.frame.height)
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView?.register(VideoCollectionViewCell.self, forCellWithReuseIdentifier: VideoCollectionViewCell.identifer)
        collectionView?.isPagingEnabled = true
        collectionView?.dataSource = self
        
        view.addSubview(collectionView!)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView?.frame = view.bounds
    }
}

extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let model = data[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: VideoCollectionViewCell.identifer, for: indexPath) as! VideoCollectionViewCell
        
        cell.configure(with: model)
        return cell
    }
}
