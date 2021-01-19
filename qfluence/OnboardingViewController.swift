//
//  OnboardingViewController.swift
//  qfluence
//
//  Created by Don Sirivat on 1/18/21.
//  Copyright © 2021 Don Sirivat. All rights reserved.
//

import UIKit
import Lottie

class OnboardingViewController: UIViewController {
    @IBOutlet weak var animationView: AnimationView!
    @IBOutlet weak var continueButton: UIButton!
    
    @IBAction func continuePressed(_ sender: Any) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        animationView.contentMode = .scaleAspectFill
        animationView.loopMode = .loop
        animationView.animationSpeed = 0.75
        animationView.play()
        
        continueButton.layer.cornerRadius = 15.0
        continueButton.layer.borderWidth = 0.5
        continueButton.layer.borderColor = UIColor.clear.cgColor

        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.sendSubviewToBack(blurEffectView)
        // Do any additional setup after loading the view.
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
