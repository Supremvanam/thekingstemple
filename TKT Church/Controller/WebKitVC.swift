//
//  WebKitVC.swift
//  TKT Church
//
//  Created by Suprem Vanam on 19/01/18.
//  Copyright © 2018 Suprem Vanam. All rights reserved.
//

import UIKit
import WebKit

class WebKitVC: UIViewController {

    @IBOutlet weak var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        navigationItem.hidesBackButton = false;
        
        let url = URL(string: "http://www.samuelpatta.org/give-online/")
        let request = URLRequest(url: url!)
        
        webView.load(request)
        
    }
    
    @IBAction func closeBtnTapped (_ sender: Any) {
        print("Dismissed")
        self.dismiss(animated: true, completion: nil)
        print("If this is working")
    }

}
