//
//  ViewController.swift
//  TKT Church
//
//  Created by Suprem Vanam on 26/09/17.
//  Copyright © 2017 Suprem Vanam. All rights reserved.
//

import UIKit

class LoginVC: UIViewController {
    
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var nextButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        phoneTextField.layer.cornerRadius = phoneTextField.frame.size.height/2
        phoneTextField.layer.masksToBounds = true
        
        nextButton.layer.cornerRadius = nextButton.frame.size.height/2
        nextButton.layer.masksToBounds = true

        view.setGradientBackground(colorOne: Colors.lightPurple, colorTwo: Colors.darkPurple)
    }

    @IBAction func nextButtonTapped(_ sender: UIButton) {
        sender.pulsate()
        print("Next button tapped")
    }
    
}

