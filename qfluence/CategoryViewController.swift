//
//  CategoryViewController.swift
//  qfluence
//
//  Created by Don Sirivat on 1/19/21.
//  Copyright © 2021 Don Sirivat. All rights reserved.
//

import UIKit
import Canvas

class CategoryViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.filteredInfluencers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "influencerCell", for: indexPath) as! CategoryInfluencerCollectionViewCell
        
        cell.influencerLabel.text = self.filteredInfluencers[indexPath.row].label
        cell.influencerImage.loadImage(urlSting: self.filteredInfluencers[indexPath.row].imageUrl)
        
        cell.layer.cornerRadius = 15.0
        
        return cell
    }
    
    @IBOutlet weak var viewLabel: UILabel!
    @IBOutlet weak var viewImage: UIImageView!
    @IBOutlet weak var viewSwitch: UISwitch!
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var listView: UICollectionView!
    @IBOutlet weak var animation: CSAnimationView!
    
    var selectedCategory: String?
    var filteredInfluencers = [SpotlightObject]()

    override func viewDidLoad() {
        super.viewDidLoad()

        viewSwitch.addTarget(self, action: #selector(stateChanged), for: .valueChanged)
    }
    
    @objc func stateChanged(switchState: UISwitch) {
        if switchState.isOn {
            self.setupListView()
        } else {
            self.setupGalleryView()
        }
    }
    
    func setupListView() {
        self.viewLabel.text = "List view"
        self.viewImage.image = UIImage(systemName: "list.bullet.rectangle")
        self.backgroundView.backgroundColor = UIColor.secondarySystemBackground
        
        self.listView.isHidden = false
        self.animation.startCanvasAnimation()
    }
    
    func setupGalleryView() {
        self.viewLabel.text = "Gallery view"
        self.viewImage.image = UIImage(systemName: "text.below.photo.fill.rtl")
        self.backgroundView.backgroundColor = UIColor.secondarySystemFill
        
        self.listView.isHidden = true
        self.animation.startCanvasAnimation()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationController?.navigationBar.barTintColor = UIColor.black
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
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
