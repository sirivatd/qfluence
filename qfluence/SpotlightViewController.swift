//
//  SpotlightViewController.swift
//  qfluence
//
//  Created by Don Sirivat on 12/14/20.
//  Copyright © 2020 Don Sirivat. All rights reserved.
//

import UIKit
import FirebaseDatabase

struct SpotlightObject {
    let image: UIImage
    let label: String
}

class SpotlightViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    @IBOutlet weak var popularCollectionView: UICollectionView!
    @IBOutlet weak var featuredCollectionView: UICollectionView!
    
    private var popularObjects = [SpotlightObject]()
    private var featuredObjects = [SpotlightObject]()
    private var selectedObject: SpotlightObject?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        popularCollectionView.dataSource = self
        popularCollectionView.delegate = self
        featuredCollectionView.dataSource = self
        featuredCollectionView.delegate = self
        
        addObjects()
    }
    
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
        let popularObject = SpotlightObject(image: UIImage(named: "popular_music")!, label: "Music")
        let popularObject2 = SpotlightObject(image: UIImage(named: "popular_tech")!, label: "Tech")
        let popularObject3 = SpotlightObject(image: UIImage(named: "popular_sports")!, label: "Sports")
        let popularObject4 = SpotlightObject(image: UIImage(named: "popular_fashion")!, label: "Fashion")
        let popularObject5 = SpotlightObject(image: UIImage(named: "popular_politics")!, label: "Politics")

        
        popularObjects.append(popularObject)
        popularObjects.append(popularObject2)
        popularObjects.append(popularObject3)
        popularObjects.append(popularObject4)
        popularObjects.append(popularObject5)
        
        // Backfill featured section
        let feauturedObject = SpotlightObject(image: UIImage(named: "featured_zedd")!, label: "Zedd")
        let feauturedObject2 = SpotlightObject(image: UIImage(named: "featured_magnus")!, label: "Magnus Carlsen")
        let feauturedObject3 = SpotlightObject(image: UIImage(named: "featured_rihanna")!, label: "Rihanna")
        let feauturedObject4 = SpotlightObject(image: UIImage(named: "featured_gordon")!, label: "Gordon Ramsay")
        let feauturedObject5 = SpotlightObject(image: UIImage(named: "featured_cudi")!, label: "Kid Cudi")
        let feauturedObject6 = SpotlightObject(image: UIImage(named: "featured_nas")!, label: "Lil Nas X")
        let feauturedObject7 = SpotlightObject(image: UIImage(named: "featured_wolfe")!, label: "Wolfe Glicke")
        let feauturedObject8 = SpotlightObject(image: UIImage(named: "featured_ederson")!, label: "Ederson")
        let feauturedObject9 = SpotlightObject(image: UIImage(named: "featured_dele")!, label: "Dele Alli")
        let feauturedObject10 = SpotlightObject(image: UIImage(named: "featured_scarlett")!, label: "Scarlett Johanson")
        let feauturedObject11 = SpotlightObject(image: UIImage(named: "featured_miranda")!, label: "Miranda Kerr")
        let feauturedObject12 = SpotlightObject(image: UIImage(named: "featured_mila")!, label: "Mila Kunis")
        let feauturedObject13 = SpotlightObject(image: UIImage(named: "featured_elon")!, label: "Elon Musk")
        let feauturedObject14 = SpotlightObject(image: UIImage(named: "featured_ben")!, label: "Ben Shapiro")
        
        featuredObjects.append(feauturedObject)
        featuredObjects.append(feauturedObject2)
        featuredObjects.append(feauturedObject3)
        featuredObjects.append(feauturedObject4)
        featuredObjects.append(feauturedObject5)
        featuredObjects.append(feauturedObject6)
        featuredObjects.append(feauturedObject7)
        featuredObjects.append(feauturedObject8)
        featuredObjects.append(feauturedObject9)
        featuredObjects.append(feauturedObject10)
        featuredObjects.append(feauturedObject11)
        featuredObjects.append(feauturedObject12)
        featuredObjects.append(feauturedObject13)
        featuredObjects.append(feauturedObject14)
        
        let ref = Database.database().reference(withPath: "influencers")
        ref.observe(.value, with: { snapshot in
            // This is the snapshot of the data at the moment in the Firebase database
            // To get value from the snapshot, we user snapshot.value
            print(snapshot.value as Any)
        })z
//        print(recentInfluencersQuery)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? InfluencerMainViewController {
            destination.title = selectedObject?.label
        }
    }
}