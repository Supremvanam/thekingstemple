//
//  UIButton+Extension.swift
//  TKT Church
//
//  Created by Suprem Vanam on 28/09/17.
//  Copyright © 2017 Suprem Vanam. All rights reserved.
//

import Foundation
import UIKit

extension UIButton {
    
    func pulsate() {
        let pulse = CASpringAnimation(keyPath: "transform.scale")
//        let test = CAKeyframeAnimation()
//        let test2 = CABasicAnimation()
        pulse.duration = 0.5
        pulse.fromValue = 1.0
        pulse.toValue = 0.95
        pulse.autoreverses = true
//        pulse.repeatDuration = 0.5
        pulse.repeatCount = 10
        pulse.initialVelocity = 0.5
        pulse.damping = 1.0
        
        layer.add(pulse, forKey: nil)
    }
}
