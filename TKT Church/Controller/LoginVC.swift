//
//  ViewController.swift
//  TKT Church
//
//  Created by Suprem Vanam on 26/09/17.
//  Copyright © 2017 Suprem Vanam. All rights reserved.
//

import UIKit
import FirebaseAuth

class LoginVC: UIViewController {
    
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var visualEffectView: UIVisualEffectView!
    @IBOutlet weak var popUpView: UIView!
    @IBOutlet weak var editBtn: UIButton!
    @IBOutlet weak var confirmBtn: UIButton!
    @IBOutlet weak var infoConfirmText: UILabel!
    
    var effect: UIVisualEffect!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        effect = visualEffectView.effect
        visualEffectView.effect = nil
        
        popUpView.layer.cornerRadius = 10
        
        phoneTextField.delegate = self
        viewStyle()
        navigationItem.hidesBackButton = true;
        
    }
    
    func AnimateIn() {
        self.view.addSubview(popUpView)
        popUpView.center = self.view.center
        
        popUpView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
        popUpView.alpha = 0

        UIView.animate(withDuration: 0.4) {
            self.visualEffectView.effect = self.effect
            self.popUpView.alpha = 1
            self.popUpView.transform = CGAffineTransform.identity
        }
    }
    
    func AnimateOut() {
        UIView.animate(withDuration: 0.3, animations: {
            self.popUpView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
            self.popUpView.alpha = 0
            self.visualEffectView.effect = nil

        }) { (success: Bool) in
            self.popUpView.removeFromSuperview()
        }
    }
    
    @IBAction func editPopup(_ sender: UIButton) {
        sender.pulsate()
        AnimateOut()
    }
    
    @IBAction func confirmPopup(_ sender: UIButton) {
        sender.pulsate()
        
                PhoneAuthProvider.provider().verifyPhoneNumber(self.phoneTextField.text!) { (verificationID, error) in
                    if error != nil {
                        print("Error : \(String(describing: error?.localizedDescription))")
                    } else {
        
                        let defaults = UserDefaults.standard
                        defaults.set(verificationID, forKey: "authVID")
                        self.performSegue(withIdentifier: "code", sender: Any?.self)
        
                    }
                }
                           print("Next button tapped")
        
    }

    @IBAction func nextButtonTapped(_ sender: UIButton) {
        AnimateIn()
        if phoneTextField.text != nil {
            infoConfirmText.text = "\(phoneTextField.text ?? "nil") \n Please check the number once again and click 'CONFIRM' to receive a verification code"
        }
        self.view.endEditing(true)
        }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let DestController = segue.destination as! AuthVC
        DestController.infoLabelText = "We’ve sent  a verification code to \n \(phoneTextField.text!)\n\nPlease enter the code down here to Get Started"
    }
        
    func viewStyle() {
        phoneTextField.layer.cornerRadius = phoneTextField.frame.size.height/2
        phoneTextField.layer.masksToBounds = true
        
        nextButton.layer.cornerRadius = nextButton.frame.size.height/2
        nextButton.layer.masksToBounds = true
        
//        confirmBtn.layer.cornerRadius = 5
//        confirmBtn.layer.masksToBounds = true
        
        view.setDiagonalGradientBackground(colorOne: Colors.lightPurple, colorTwo: Colors.darkPurple)
    }
}

extension LoginVC: UITextFieldDelegate {

    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.text = "+91"
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}
    
    
    
    
    
    

