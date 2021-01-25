//
//  CategoryViewController.swift
//  qfluence
//
//  Created by Don Sirivat on 1/19/21.
//  Copyright © 2021 Don Sirivat. All rights reserved.
//

import UIKit
import Canvas
import ScalingCarousel

class CategoryViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.filteredInfluencers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.listView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "influencerCell", for: indexPath) as! CategoryInfluencerCollectionViewCell
            
            cell.influencerLabel.text = self.filteredInfluencers[indexPath.row].label
            cell.influencerImage.loadImage(urlSting: self.filteredInfluencers[indexPath.row].imageUrl)
            
            cell.layer.cornerRadius = 15.0
            
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "galleryCell", for: indexPath) as! SpotlightCollectionViewCell
            
            cell.featuredImage.loadImage(urlSting: self.filteredInfluencers[indexPath.row].imageUrl)
            cell.featuredLabel.text = self.filteredInfluencers[indexPath.row].label
            cell.contentView.layer.cornerRadius = 10.0
            cell.contentView.layer.borderWidth = 3.0
            cell.contentView.layer.borderColor = UIColor.clear.cgColor
            cell.contentView.layer.masksToBounds = true
            
            cell.featuredImage.layer.cornerRadius = 10.0
            cell.featuredImage.layer.masksToBounds = true
            
            cell.setNeedsLayout()
            cell.layoutIfNeeded()
            
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.selectedInfluencer = self.filteredInfluencers[indexPath.row]
        self.performSegue(withIdentifier: "toInfluencer", sender: nil)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == self.galleryView {
            self.galleryView.didScroll()
        }
    }
    
    @IBOutlet weak var viewLabel: UILabel!
    @IBOutlet weak var viewImage: UIImageView!
    @IBOutlet weak var viewSwitch: UISwitch!
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var listView: UICollectionView!
    @IBOutlet weak var animation: CSAnimationView!
    @IBOutlet weak var galleryView: ScalingCarouselView!
    
    var selectedCategory: String?
    var selectedInfluencer: SpotlightObject?
    var filteredInfluencers = [SpotlightObject]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.galleryView.isHidden = true
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
        self.galleryView.isHidden = true
        self.animation.startCanvasAnimation()
    }
    
    func setupGalleryView() {
        self.viewLabel.text = "Gallery view"
        self.viewImage.image = UIImage(systemName: "text.below.photo.fill.rtl")
        self.backgroundView.backgroundColor = UIColor.secondarySystemFill
        
        self.listView.isHidden = true
        self.galleryView.isHidden = false
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

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toInfluencer" {
            if let destination = segue.destination as? InfluencerMainViewController {
                destination.title = selectedInfluencer!.label
                destination.selectedInfluencerId = selectedInfluencer!.influencerId
            }
        }
    }
}
