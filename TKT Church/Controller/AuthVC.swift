//
//  AuthVC.swift
//  TKT Church
//
//  Created by Suprem Vanam on 28/09/17.
//  Copyright © 2017 Suprem Vanam. All rights reserved.
//

import UIKit
import FirebaseAuth


class AuthVC: UIViewController {

    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var verifyTextField: UITextField!
    @IBOutlet weak var nextButton: UIButton!
    
    var infoLabelText = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewStyle()
        navigationItem.hidesBackButton = true;
        
        infoLabel.text = infoLabelText
    }
    
    @IBAction func verifyButtonTapped(_ sender: UIButton) {
        
        sender.pulsate()
        
        let defaults = UserDefaults.standard
        let credential: PhoneAuthCredential = PhoneAuthProvider.provider().credential(withVerificationID: defaults.string(forKey: "authVID")!, verificationCode: verifyTextField.text!)
        Auth.auth().signIn(with: credential) { (user, error) in
            if error != nil {
                // Check the error
                print("Error : \(String(describing: error?.localizedDescription))")
            } else {
                print("Phone number \(String(describing:user?.phoneNumber))")
                let userInfo = user?.providerData[0]
                print("Provider ID: \(String(describing:userInfo?.providerID))")
                self.performSegue(withIdentifier: "logged", sender: Any?.self)
                
            }
        }
    }

    func viewStyle() {
        verifyTextField.layer.cornerRadius = verifyTextField.frame.size.height/2
        verifyTextField.layer.masksToBounds = true
        
        nextButton.layer.cornerRadius = nextButton.frame.size.height/2
        nextButton.layer.masksToBounds = true
        
        view.setDiagonalGradientBackground(colorOne: Colors.lightPurple, colorTwo: Colors.darkPurple)
    }

}
