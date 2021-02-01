//
//  SpotlightViewController.swift
//  qfluence
//
//  Created by Don Sirivat on 12/14/20.
//  Copyright © 2020 Don Sirivat. All rights reserved.
//

import UIKit
import FirebaseDatabase
import Canvas
import Firebase

struct SpotlightObject {
    let imageUrl: String
    let label: String
    let influencerId: Int
    let bioText: String
}

struct CategoryObject {
    let image: UIImage
    let label: String
    let influencerId: Int
}

struct InfluencerObject {
    let bioText: String
    let category: String
    let email: String
    let firstName: String
    let lastName: String
    let instagramLink: String
    let otherLink: String
    let imageUrl: String
    let influencerId: Int
}

extension SpotlightViewController: UITableViewDataSource, SpotlightTableViewCellDelegate {
    func didPressFollowButton(_ tag: Int) {
        // follow or unfollow
        let followedId = self.featuredObjects[tag].influencerId
        if currentUser!.follows.contains(followedId) {
            // unfollow
            let indexToRemove = currentUser?.follows.index(of: followedId)
            currentUser?.follows.remove(at: indexToRemove!)
        } else {
            // follow
            currentUser?.follows.append(followedId)
        }
        
        self.mainTableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.featuredObjects.count + 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 || indexPath.row == self.featuredObjects.count + 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "headerCell")!
            
            return cell
        } else if indexPath.row == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell")!
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "featuredCell") as! SpotlightTableViewCell
            cell.spotlightTableViewCellDelegate = self

            cell.parallaxImage.loadImage(urlSting: self.featuredObjects[indexPath.row - 2].imageUrl)

            cell.featuredLabel.text = self.featuredObjects[indexPath.row-2].label
            cell.bioText.text = self.featuredObjects[indexPath.row-2].bioText
            cell.followButton.setBackgroundImage(UIImage(systemName: "heart"), for: .normal)
            cell.followButton.tag = indexPath.row - 2
            
            if currentUser?.follows != nil {
                let followIds = currentUser!.follows
                let currentId = self.featuredObjects[indexPath.row-2].influencerId
                if followIds.contains(currentId) {
                    cell.followButton.setBackgroundImage(UIImage(systemName: "heart.fill"), for: .normal)
                }
            }
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row > 1 && indexPath.row < self.featuredObjects.count + 1 {
            tableView.deselectRow(at: indexPath, animated: true)
            self.selectedObject = featuredObjects[indexPath.row-2]
            performSegue(withIdentifier: "toInfluencer", sender: self)
        }
    }
}

extension SpotlightViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0   || indexPath.row == self.featuredObjects.count + 1 {
            return 400
        } else if indexPath.row == 1 {
            return 200
        }  else {
            return self.mainTableView.frame.height/2.5
        }
    }
    
    // parallax effect
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if self.originalCellHeight == nil {
            self.originalCellHeight = Float(self.mainTableView.frame.height/2.5)
        }
        
        let indexPath = IndexPath(row: 0, section: 0)
        let cell = self.mainTableView.cellForRow(at: indexPath) as? SpotlightTableViewCell
        
        if cell != nil {
            let y = scrollView.contentOffset.y.magnitude
            let height = max(self.originalCellHeight! - Float(y/2.5), 0)
            cell!.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: CGFloat(Float(height)))
        } else {
//            let offsetY = self.mainTableView.contentOffset.y
//            if let questionCell = self.mainTableView.visibleCells.first as? SpotlightTableViewCell {
//                let x = questionCell.contentView.frame.origin.x
//                let w = questionCell.contentView.bounds.width
//                let h = questionCell.contentView.bounds.height
//                let y = ((offsetY - questionCell.frame.origin.y) / h) * 25
//                questionCell.contentView.frame = CGRect(x: x, y: y, width: w, height: h)
//            }
        }
    }
}

class SpotlightViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
//    @IBOutlet weak var popularCollectionView: UICollectionView!
    @IBOutlet weak var mainTableView: UITableView!
    
    private var categoryObjects = [CategoryObject]()
    private var featuredObjects = [SpotlightObject]()
    private var allFeaturedObjects = [SpotlightObject]()
    private var filteredObjects = [SpotlightObject]()
    private var selectedObject: SpotlightObject?
    private var selectedCategory: CategoryObject?
    @IBOutlet weak var animationView: CSAnimationView!
    
    var originalCellHeight: Float?
    private var ref: DatabaseReference?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(loadingIndicator)
        addObjects()
        
        if isFirstTime == true {
            isFirstTime = false
            self.performSegue(withIdentifier: "toOnboarding", sender: nil)
        }
        
        NSLayoutConstraint.activate([
            loadingIndicator.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            loadingIndicator.widthAnchor.constraint(equalToConstant: 50),
            loadingIndicator.heightAnchor.constraint(equalTo: self.loadingIndicator.widthAnchor)
            ])
        
        loadingIndicator.isAnimating = true
        mainTableView.isHidden = true
        animationView.isHidden = true
    }
    
    let loadingIndicator: ProgressView = {
        let progress = ProgressView(colors: [.red, .orange, .darkGray], lineWidth: 5)
        progress.translatesAutoresizingMaskIntoConstraints = false
        return progress
    }()
    
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: animated)
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categoryObjects.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "individualCatCell", for: indexPath) as! CategoryCollectionViewCell

        cell.categoryLabel.text = self.categoryObjects[indexPath.row].label
        cell.imageView.image = self.categoryObjects[indexPath.row].image

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.selectedCategory = self.categoryObjects[indexPath.row]
        self.performSegue(withIdentifier: "toCategory", sender: nil)
        collectionView.deselectItem(at: indexPath, animated: true)
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return  1
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    func addObjects() {
        // Backfill categories
        let categoryObject = CategoryObject(image: UIImage(named: "film")!, label: "Film", influencerId: 1)
        let categoryObject2 = CategoryObject(image: UIImage(named: "sports")!, label: "Sports", influencerId: 1)
        let categoryObject3 = CategoryObject(image: UIImage(named: "business")!, label: "Business", influencerId: 1)
        let categoryObject4 = CategoryObject(image: UIImage(named: "music")!, label: "Music", influencerId: 1)
        let categoryObject5 = CategoryObject(image: UIImage(named: "animal")!, label: "Animal & Nature", influencerId: 1)
        let categoryObject6 = CategoryObject(image: UIImage(named: "food")!, label: "Food", influencerId: 1)
        let categoryObject7 = CategoryObject(image: UIImage(named: "fashion")!, label: "Fashion & Style", influencerId: 1)
        let categoryObject8 = CategoryObject(image: UIImage(named: "politics")!, label: "Politics", influencerId: 1)
        let categoryObject9 = CategoryObject(image: UIImage(named: "social_media")!, label: "Social media", influencerId: 1)
        let categoryObject10 = CategoryObject(image: UIImage(named: "education")!, label: "Education", influencerId: 1)
        let categoryObject11 = CategoryObject(image: UIImage(named: "medicine")!, label: "Medicine", influencerId: 1)
        let categoryObject12 = CategoryObject(image: UIImage(named: "technology")!, label: "Technology", influencerId: 1)

        categoryObjects.append(categoryObject)
        categoryObjects.append(categoryObject2)
        categoryObjects.append(categoryObject3)
        categoryObjects.append(categoryObject4)
        categoryObjects.append(categoryObject5)
        categoryObjects.append(categoryObject6)
        categoryObjects.append(categoryObject7)
        categoryObjects.append(categoryObject8)
        categoryObjects.append(categoryObject9)
        categoryObjects.append(categoryObject10)
        categoryObjects.append(categoryObject11)
        categoryObjects.append(categoryObject12)

        self.ref = Database.database().reference(withPath: "influencers")
        self.ref!.observeSingleEvent(of: .value, with: { (snapshot) in
            for influencer in snapshot.children {
                if let snapshot = influencer as? DataSnapshot {
                    let dict = snapshot.value as? NSDictionary
                    let firstName = dict!["firstName"] as? String
                    let lastName = dict!["lastName"] as? String
                    let bioText = dict!["category"] as? String
                    
                    // simple name logic
                    var influencerName: String?
                    if lastName?.lowercased() == "n/a" {
                        influencerName = firstName
                    } else {
                        influencerName = firstName! + " " + lastName!
                    }
                    
                    let featuredObject = SpotlightObject(imageUrl: dict!["imageUrl"] as! String, label: influencerName!, influencerId: dict!["influencerId"] as! Int, bioText: bioText!)
                    self.allFeaturedObjects.append(featuredObject)
                }
            }
                
            self.allFeaturedObjects = self.allFeaturedObjects.shuffled()
            self.featuredObjects = Array(self.allFeaturedObjects[0...26])
  
            self.mainTableView.reloadData()
            self.mainTableView.isHidden = false
            self.animationView.isHidden = false
            
            // Remove loading indicator
            self.loadingIndicator.removeFromSuperview()
            self.animationView.startCanvasAnimation()
        })
    }
    
    func saveFollowData() {
        let userId = currentUser?.uid
        let followData = currentUser?.follows
        
        print(followData)
        
        self.ref = Database.database().reference()
        self.ref = ref!.child("users/\(userId!)/follows")
        self.ref?.setValue(followData)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        // save data to Firebase
        saveFollowData()
    }
    
    func filterInfluencers(category: String) -> [SpotlightObject] {
//        let filtered = self.allFeaturedObjects.filter{$0.bioText.lowercased() == self.selectedCategory!.label.lowercased()}
//
//        return filtered
        
        return self.allFeaturedObjects
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toInfluencer" {
            if let destination = segue.destination as? InfluencerMainViewController {
                destination.title = selectedObject?.label
                destination.selectedInfluencerId = selectedObject?.influencerId
            }
        } else if segue.identifier == "toCategory" {
            if let destination = segue.destination as? CategoryViewController {
                destination.title = selectedCategory?.label
                destination.selectedCategory = selectedCategory?.label
                destination.filteredInfluencers = self.filterInfluencers(category: selectedCategory!.label)
            }
        }
    }
}
