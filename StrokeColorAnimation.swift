//
//  StrokeColorAnimation.swift
//  
//
//  Created by Don Sirivat on 1/11/21.
//

import UIKit

class StrokeColorAnimation: CAKeyframeAnimation {
    let startAnimation = StrokeAnimation(
        type: .start,
        beginTime: 0.25,
        fromValue: 0.0,
        toValue: 1.0,
        duration: 0.75
    )
    
    let endAnimation = StrokeAnimation(
        type: .end,
        fromValue: 0.0,
        toValue: 1.0,
        duration: 0.75
    )
    
    let strokeAnimationGroup = CAAnimationGroup()
    strokeAnimationGroup.duration = 1
    strokeAnimationGroup.repeatDuration = .infinity
    strokeAnimationGroup.animations = [startAnimation, endAnimation]
    
    shapeLayer.add(strokeAnimationGroup, forKey: nil)
    
    /// UPDATED
    let colorAnimation = StrokeColorAnimation(
        colors: colors.map { $0.cgColor },
        duration: strokeAnimationGroup.duration * Double(colors.count)
    )
    
    shapeLayer.add(colorAnimation, forKey: nil)

}
