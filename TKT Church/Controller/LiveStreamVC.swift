//
//  LiveStreamVC.swift
//  TKT Church
//
//  Created by Suprem Vanam on 13/10/17.
//  Copyright © 2017 Suprem Vanam. All rights reserved.
//

import UIKit
import AVFoundation
import YouTubePlayer_Swift
import Firebase
import FirebaseDatabase

class LiveStreamVC: UIViewController {
 
    @IBOutlet weak var videoPlayerView: YouTubePlayerView!
    @IBOutlet weak var liveStreamTitle: UILabel!
    @IBOutlet weak var liveStreamDescription: UILabel!
    
    
    
    let appDel = UIApplication.shared.delegate as! AppDelegate


    override func viewDidLoad() {
        super.viewDidLoad()
   
        let statusBarView = UIView(frame: UIApplication.shared.statusBarFrame)
        let statusBarColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 1.0)
        statusBarView.backgroundColor = statusBarColor
        view.addSubview(statusBarView)
        
        appDel.ref.child("livestream").child("livetitle").observe(.value, with: { (snapshot) in
            if let value = snapshot.value {
                print("Live Title is \(String(describing: value))")
                self.liveStreamTitle.text = (value as! String)
            } else {
                print ("Title value is not shown")
            }
        }) { (error) in
            print(error.localizedDescription)
        }
        
        appDel.ref.child("livestream").child("livedescription").observe(.value, with: { (snapshot) in
            if let value = snapshot.value {
                print("Live Description is \(String(describing: value))")
                self.liveStreamDescription.text = value as? String
            } else {
                print ("Description value not available")
            }
        }) { (error) in
            print(error.localizedDescription)
        }
    
    }
    override func viewDidAppear(_ animated: Bool) {
        
        appDel.ref.child("livestream").child("liveurl").observe(.value, with: { (snapshot) in
            if let value = snapshot.value {
                print("The Live URL Value is \(String(describing: value))")
                
                self.LiveStreamSuccess(value: value as! String)
                
            } else {
                print ("Some error")
                }
            
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    
    func LiveStreamSuccess(value: String) {
        
        videoPlayerView.playerVars = ["playsinline": 1 as AnyObject,
                                      "showinfo": 0 as AnyObject,
                                      "modestbranding": 1 as AnyObject]
        let myVideoURL = NSURL(string: value)
        videoPlayerView.loadVideoURL(myVideoURL! as URL)
    
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
}
