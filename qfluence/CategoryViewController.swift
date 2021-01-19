//
//  CategoryViewController.swift
//  qfluence
//
//  Created by Don Sirivat on 1/19/21.
//  Copyright © 2021 Don Sirivat. All rights reserved.
//

import UIKit

class CategoryViewController: UIViewController {
    var selectedCategory: String?

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.navigationBar.barTintColor = UIColor.black
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        
        if selectedCategory != nil {
            navigationController?.title = selectedCategory!
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
