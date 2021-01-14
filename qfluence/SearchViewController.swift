//
//  SearchViewController.swift
//  qfluence
//
//  Created by Don Sirivat on 1/11/21.
//  Copyright © 2021 Don Sirivat. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {
    @IBOutlet weak var searchField: UITextField!
    @IBOutlet weak var peopleCollectionView: UICollectionView!
    @IBOutlet weak var videoCollectionView: UICollectionView!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var peopleLabel: UILabel!
    @IBOutlet weak var questionLabel: UILabel!
    
    @IBAction func searchPressed(_ sender: Any) {
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        searchField.leftViewMode = UITextField.ViewMode.always
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        let image = UIImage(named: "icons8-search-60")?.withTintColor(.lightGray)
        imageView.image = image
        searchField.leftView = imageView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: animated)
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
}
