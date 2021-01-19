//
//  OnboardingViewController.swift
//  qfluence
//
//  Created by Don Sirivat on 1/18/21.
//  Copyright © 2021 Don Sirivat. All rights reserved.
//

import UIKit
import Lottie
import Canvas

class OnboardingViewController: UIViewController {
    @IBOutlet weak var animationView: AnimationView!
    @IBOutlet weak var continueButton: UIButton!
    @IBOutlet weak var greetingView: UITextView!
    @IBOutlet weak var greetingSubheaderView: UILabel!
    @IBOutlet weak var firstOnboardingScreen: UIView!
    @IBOutlet weak var animationViewTwo: AnimationView!
    @IBOutlet weak var secondOnboardingScreen: UIView!
    @IBOutlet weak var optionViewOne: CSAnimationView!
    @IBOutlet weak var optionViewTwo: CSAnimationView!
    @IBOutlet weak var optionViewThree: CSAnimationView!
    @IBOutlet weak var optionViewFour: CSAnimationView!
    @IBOutlet weak var thirdOnboardingScreen: UIView!
    @IBOutlet weak var animationViewThree: AnimationView!
    
    var clicks: Int = 0
    
    @IBAction func continuePressed(_ sender: Any) {
        if self.clicks == 0 {
            self.animationView.stop()
            self.animationView.isHidden = true
            self.greetingView.isHidden = true
            self.greetingSubheaderView.isHidden = true
            self.firstOnboardingScreen.isHidden = false
            
            animationViewTwo.contentMode = .scaleAspectFill
            animationViewTwo.loopMode = .loop
            animationViewTwo.animationSpeed = 0.75
            animationViewTwo.play()
            
            self.clicks += 1
        } else if self.clicks == 1 {
            animationViewTwo.stop()
            self.firstOnboardingScreen.isHidden = true
            self.secondOnboardingScreen.isHidden = false
            
            optionViewOne.startCanvasAnimation()
            optionViewTwo.startCanvasAnimation()
            optionViewThree.startCanvasAnimation()
            optionViewFour.startCanvasAnimation()
            
            self.clicks += 1
        } else if self.clicks == 2 {
            self.secondOnboardingScreen.isHidden = true
            self.thirdOnboardingScreen.isHidden = false
            
            animationViewThree.contentMode = .scaleAspectFill
            animationViewThree.loopMode = .loop
            animationViewThree.animationSpeed = 0.75
            animationViewThree.play()
            
            self.clicks += 1
        } else {
            animationViewThree.stop()
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        firstOnboardingScreen.isHidden = true
        secondOnboardingScreen.isHidden = true
        thirdOnboardingScreen.isHidden = true
        
        animationView.contentMode = .scaleAspectFill
        animationView.loopMode = .loop
        animationView.animationSpeed = 0.75
        animationView.play()
        
        continueButton.layer.cornerRadius = 15.0
        continueButton.layer.borderWidth = 0.5
        continueButton.layer.borderColor = UIColor.clear.cgColor

    }
}
