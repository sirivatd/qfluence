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

struct SpotlightObject {
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

class SpotlightViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    @IBOutlet weak var popularCollectionView: UICollectionView!
    @IBOutlet weak var featuredCollectionView: UICollectionView!
    
    private var popularObjects = [SpotlightObject]()
    private var featuredObjects = [SpotlightObject]()
    private var selectedObject: SpotlightObject?
    @IBOutlet weak var animationView: CSAnimationView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        popularCollectionView.dataSource = self
        popularCollectionView.delegate = self
        featuredCollectionView.dataSource = self
        featuredCollectionView.delegate = self
        
        self.view.addSubview(loadingIndicator)
        addObjects()
        
        NSLayoutConstraint.activate([
            loadingIndicator.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            loadingIndicator.widthAnchor.constraint(equalToConstant: 50),
            loadingIndicator.heightAnchor.constraint(equalTo: self.loadingIndicator.widthAnchor)
            ])
        
        loadingIndicator.isAnimating = true
        featuredCollectionView.isHidden = true
    }
    
    let loadingIndicator: ProgressView = {
        let progress = ProgressView(colors: [.red, .orange, .darkGray], lineWidth: 5)
        progress.translatesAutoresizingMaskIntoConstraints = false
        return progress
    }()
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.popularCollectionView {
            return popularObjects.count
        } else {
            return featuredObjects.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.popularCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SpotlightCollectionViewCell", for: indexPath) as! SpotlightCollectionViewCell
            cell.popularImage.image = popularObjects[indexPath.row].image
            cell.popularLabel.text = popularObjects[indexPath.row].label
            
            cell.contentView.layer.cornerRadius = 5.0
            cell.contentView.layer.borderWidth = 0.5
            cell.contentView.layer.borderColor = UIColor.clear.cgColor
            cell.contentView.layer.masksToBounds = true
            cell.layer.shadowColor = UIColor.darkGray.cgColor
            cell.layer.shadowOffset = CGSize(width: 0.5, height: 0.5)
            cell.layer.shadowRadius = 1.0
            cell.layer.shadowOpacity = 0.7
            cell.layer.masksToBounds = false
            cell.layer.shadowPath = UIBezierPath(roundedRect: cell.bounds, cornerRadius: cell.contentView.layer.cornerRadius).cgPath
            
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SpotlightCollectionViewCell", for: indexPath) as! SpotlightCollectionViewCell
            cell.featuredImage.image = featuredObjects[indexPath.row].image
            cell.featuredLabel.text = featuredObjects[indexPath.row].label
            
            cell.contentView.layer.cornerRadius = 5.0
            cell.contentView.layer.borderWidth = 0.5
            cell.contentView.layer.borderColor = UIColor.clear.cgColor
            cell.contentView.layer.masksToBounds = true
            cell.layer.shadowColor = UIColor.darkGray.cgColor
            cell.layer.shadowOffset = CGSize(width: 0.5, height: 0.5)
            cell.layer.shadowRadius = 1.0
            cell.layer.shadowOpacity = 0.7
            cell.layer.masksToBounds = false
            cell.layer.shadowPath = UIBezierPath(roundedRect: cell.bounds, cornerRadius: cell.contentView.layer.cornerRadius).cgPath
            
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        if collectionView == self.popularCollectionView {
            selectedObject = popularObjects[indexPath.row]
        } else {
            selectedObject = featuredObjects[indexPath.row]
        }
        performSegue(withIdentifier: "showInfluencer", sender: self)
    }
    
    func addObjects() {
        // Backfill popular section
        let popularObject = SpotlightObject(image: UIImage(named: "popular_music")!, label: "Music", influencerId: 1)
        let popularObject2 = SpotlightObject(image: UIImage(named: "popular_tech")!, label: "Tech", influencerId: 1)
        let popularObject3 = SpotlightObject(image: UIImage(named: "popular_sports")!, label: "Sports", influencerId: 1)
        let popularObject4 = SpotlightObject(image: UIImage(named: "popular_fashion")!, label: "Fashion", influencerId: 1)
        let popularObject5 = SpotlightObject(image: UIImage(named: "popular_politics")!, label: "Politics", influencerId: 1)

        popularObjects.append(popularObject)
        popularObjects.append(popularObject2)
        popularObjects.append(popularObject3)
        popularObjects.append(popularObject4)
        popularObjects.append(popularObject5)
        
        let ref = Database.database().reference(withPath: "influencers")
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            // This is the snapshot of the data at the moment in the Firebase database
            // To get value from the snapshot, we user snapshot.value
            let influencerData = snapshot.value as! [[String : Any]]
            
            for influencer in influencerData {
                let url = URL(string: influencer["imageUrl"] as! String)
                let data = try? Data(contentsOf: url!)
                let firstName = influencer["firstName"] as! String
                let lastName = influencer["lastName"] as! String
                let influencerName = firstName + " " + lastName
                let featuredObject = SpotlightObject(image: UIImage(data: data!)!, label: influencerName, influencerId: influencer["influencerId"] as! Int)
                self.featuredObjects.append(featuredObject)
            }
            self.featuredCollectionView.reloadData()
            self.featuredCollectionView.isHidden = false
            
            // Remove loading indicator
            self.loadingIndicator.removeFromSuperview()
            self.animationView.startCanvasAnimation()
        })
        print(self.featuredObjects)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? InfluencerMainViewController {
            destination.title = selectedObject?.label
            destination.selectedInfluencerId = selectedObject?.influencerId
        }
    }
}
