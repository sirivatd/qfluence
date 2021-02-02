//
//  OptimizeViewController.swift
//  qfluence
//
//  Created by Don Sirivat on 1/21/21.
//  Copyright © 2021 Don Sirivat. All rights reserved.
//

import UIKit
import Lottie

class OptimizeViewController: UIViewController {
    @IBOutlet weak var animationView: AnimationView!
    @IBOutlet weak var checkmark: AnimationView!
    @IBOutlet weak var optimizeLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        animationView.contentMode = .scaleAspectFill
        animationView.loopMode = .loop
        animationView.play()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
            self.animationView.isHidden = true
            self.checkmark.contentMode = .scaleAspectFill
            self.checkmark.loopMode = .loop
            self.checkmark.animationSpeed = 0.25
            self.checkmark.play()
           }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 7.0) {
            self.dismiss(animated: true, completion: nil)
           }
    }
}
