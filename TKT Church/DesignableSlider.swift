//
//  DesignableSlider.swift
//  TKT Church
//
//  Created by Suprem Vanam on 29/10/17.
//  Copyright © 2017 Suprem Vanam. All rights reserved.
//

import UIKit

@IBDesignable
class DesignableSlider: UISlider {
    
    @IBInspectable var thumbImage: UIImage? {
        didSet {
            setThumbImage(thumbImage, for: .normal)
        }
    }
    
    @IBInspectable var thumbHighlightedImage: UIImage? {
        didSet {
            setThumbImage(thumbHighlightedImage, for: .highlighted)
        }
    }

}
