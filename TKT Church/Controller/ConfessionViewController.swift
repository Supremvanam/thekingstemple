//
//  ConfessionViewController.swift
//  TKT Church
//
//  Created by Suprem Vanam on 28/10/17.
//  Copyright © 2017 Suprem Vanam. All rights reserved.
//

import UIKit

class ConfessionViewController: UIViewController {

    @IBOutlet weak var closeBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let statusBarView = UIView(frame: UIApplication.shared.statusBarFrame)
        let statusBarColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1.0)
        statusBarView.backgroundColor = statusBarColor
        view.addSubview(statusBarView)
        
        closeBtn.setDiagonalGradientBackground(colorOne: Colors.lightPurple, colorTwo: Colors.darkPurple)
        
        
    }
    
    @IBAction func CloseButton(_ sender: Any) {
        print("Dismissed")
        self.dismiss(animated: true, completion: nil)
        print("If this is working")
    }
    
    
}
