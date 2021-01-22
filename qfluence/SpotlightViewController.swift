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

extension SpotlightViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.featuredObjects.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 || indexPath.row == self.featuredObjects.count {
            let cell = tableView.dequeueReusableCell(withIdentifier: "headerCell") as! UITableViewCell
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "featuredCell") as! SpotlightTableViewCell
            cell.parallaxImage.task = cell.parallaxImage.returnTask(link: self.featuredObjects[indexPath.row - 1].imageUrl, contentMode: UIView.ContentMode.scaleAspectFill)
            cell.parallaxImage.task?.resume()
            cell.parallaxImage.downloadImageFrom(link: self.featuredObjects[indexPath.row-1].imageUrl, contentMode: UIView.ContentMode.scaleAspectFill)

            cell.featuredLabel.text = self.featuredObjects[indexPath.row-1].label
            cell.bioText.text = self.featuredObjects[indexPath.row-1].bioText
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        self.selectedObject = featuredObjects[indexPath.row]
        performSegue(withIdentifier: "toInfluencer", sender: self)
    }
}

extension SpotlightViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0   || indexPath.row == self.featuredObjects.count {
            return 450
        } else  {
            return self.mainTableView.frame.height/3
        }
    }
    
    // parallax effect
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if self.originalCellHeight == nil {
            let indexPath = IndexPath(row: 0, section: 0)
            let cell = self.mainTableView.cellForRow(at: indexPath) as? SpotlightTableViewCell
            
            self.originalCellHeight = Float(self.mainTableView.frame.height/3)
        }
        
        let indexPath = IndexPath(row: 0, section: 0)
        let cell = self.mainTableView.cellForRow(at: indexPath) as? SpotlightTableViewCell
        
        if cell != nil {
            let y = scrollView.contentOffset.y.magnitude
            let height = max(self.originalCellHeight! - Float(y/3), 0)
            cell!.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: CGFloat(Float(height)))
        } else {
            let offsetY = self.mainTableView.contentOffset.y
            if let questionCell = self.mainTableView.visibleCells.first as? SpotlightTableViewCell {
                let x = questionCell.contentView.frame.origin.x
                let w = questionCell.contentView.bounds.width
                let h = questionCell.contentView.bounds.height
                let y = ((offsetY - questionCell.frame.origin.y) / h) * 25
                
                questionCell.contentView.frame = CGRect(x: x, y: y, width: w, height: h)
            }
        }
    }
    
//    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "featuredCell") as! SpotlightTableViewCell
//        cell.parallaxImage.task?.cancel()
//    }
}

class SpotlightViewController: UIViewController {
//    @IBOutlet weak var popularCollectionView: UICollectionView!
    @IBOutlet weak var mainTableView: UITableView!
    
//    private var popularObjects = [CategoryObject]()
    private var featuredObjects = [SpotlightObject]()
    private var selectedObject: SpotlightObject?
    private var selectedCategory: CategoryObject?
    @IBOutlet weak var animationView: CSAnimationView!
    var originalCellHeight: Float?

    
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
    
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        if collectionView == self.popularCollectionView {
//            return popularObjects.count
//        } else {
//            return featuredObjects.count
//        }
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SpotlightCollectionViewCell", for: indexPath) as! SpotlightCollectionViewCell
//        cell.popularImage.image = popularObjects[indexPath.row].image
//        cell.popularLabel.text = popularObjects[indexPath.row].label
//
//        cell.contentView.layer.cornerRadius = 5.0
//        cell.contentView.layer.borderWidth = 0.5
//        cell.contentView.layer.borderColor = UIColor.clear.cgColor
//        cell.contentView.layer.masksToBounds = true
//
//        return cell
//    }
    
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        collectionView.deselectItem(at: indexPath, animated: true)
//        if collectionView == self.popularCollectionView {
//            self.selectedCategory = popularObjects[indexPath.row]
//            performSegue(withIdentifier: "toCategory", sender: self)
//        } else {
//            self.selectedObject = featuredObjects[indexPath.row]
//            performSegue(withIdentifier: "toInfluencer", sender: self)
//        }
//    }
    
    func addObjects() {
        // Backfill popular section
        let popularObject = CategoryObject(image: UIImage(named: "popular_music")!, label: "Music", influencerId: 1)
        let popularObject2 = CategoryObject(image: UIImage(named: "popular_tech")!, label: "Tech", influencerId: 1)
        let popularObject3 = CategoryObject(image: UIImage(named: "popular_sports")!, label: "Sports", influencerId: 1)
        let popularObject4 = CategoryObject(image: UIImage(named: "popular_fashion")!, label: "Fashion", influencerId: 1)
        let popularObject5 = CategoryObject(image: UIImage(named: "popular_politics")!, label: "Politics", influencerId: 1)

//        popularObjects.append(popularObject)
//        popularObjects.append(popularObject2)
//        popularObjects.append(popularObject3)
//        popularObjects.append(popularObject4)
//        popularObjects.append(popularObject5)
        
        let ref = Database.database().reference(withPath: "influencers").queryLimited(toLast: 50)
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            for influencer in snapshot.children {
                if let snapshot = influencer as? DataSnapshot {
                    let dict = snapshot.value as? NSDictionary
                    let firstName = dict!["firstName"] as? String
                    let lastName = dict!["lastName"] as? String
                    let bioText = dict!["bioText"] as? String
                    
                    // simple name logic
                    var influencerName: String?
                    if lastName?.lowercased() == "n/a" {
                        influencerName = firstName
                    } else {
                        influencerName = firstName! + " " + lastName!
                    }
                    
                    let featuredObject = SpotlightObject(imageUrl: dict!["imageUrl"] as! String, label: influencerName!, influencerId: dict!["influencerId"] as! Int, bioText: bioText!)
                    self.featuredObjects.append(featuredObject)
                }
            }
                
            self.mainTableView.reloadData()
//            self.popularCollectionView.isHidden = false
            self.mainTableView.isHidden = false
            self.animationView.isHidden = false
            
            // Remove loading indicator
            self.loadingIndicator.removeFromSuperview()
            self.animationView.startCanvasAnimation()
        })
        print(self.featuredObjects)
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
            }
        }
    }
}

extension UIImageView {
    func downloadImageFrom(link:String, contentMode: UIView.ContentMode) {
        URLSession.shared.dataTask( with: NSURL(string:link)! as URL, completionHandler: {
            (data, response, error) -> Void in
            DispatchQueue.main.async {
                self.contentMode =  contentMode
                if let data = data { self.image = UIImage(data: data) }
            }
        }).resume()
    }
    
    func returnTask(link:String, contentMode: UIView.ContentMode) -> URLSessionDataTask {
        URLSession.shared.dataTask( with: NSURL(string:link)! as URL, completionHandler: {
            (data, response, error) -> Void in
            DispatchQueue.main.async {
                self.contentMode =  contentMode
                if let data = data { self.image = UIImage(data: data) }
            }
        })
    }
}
