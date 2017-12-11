//
//  HomeVC.swift
//  TKT Church
//
//  Created by Suprem Vanam on 30/09/17.
//  Copyright © 2017 Suprem Vanam. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation
import FirebaseAuth

class HomeVC: UIViewController {
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var weekLabel: UILabel!
    @IBOutlet weak var logoutBtn: UIButton!
    
    @IBOutlet weak var greetView: UIView!
    @IBOutlet weak var greetImage: UIImageView!
    @IBOutlet weak var greetText: UILabel!
    
    
    @IBOutlet weak var audioPlayerView: UIView!
    @IBOutlet weak var playPauseBtn: UIButton!
    @IBOutlet weak var sermonSlider: UISlider!
    
    
    @IBOutlet weak var goalView: UIView!
    
    @IBOutlet weak var confessionView: UIView!
    
    @IBOutlet weak var streakView: UIView!
    
    let appDel = UIApplication.shared.delegate as! AppDelegate
    
    var player: AVAudioPlayer = AVAudioPlayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let statusBarView = UIView(frame: UIApplication.shared.statusBarFrame)
        let statusBarColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1.0)
        statusBarView.backgroundColor = statusBarColor
        view.addSubview(statusBarView)
        
        let date = Date()
        let calendar = Calendar.current
        
        let day = calendar.component(.day, from: date)
        let month = calendar.component(.month, from: date)
        let week = calendar.component(.weekday, from: date)
        let hour = calendar.component(.hour, from: date)

        
        var monthName: String
        var weekName: String
        var greeting: String
        
        switch month {
        case 1:
            monthName = "JANUARY"
        case 2:
            monthName = "FEBRUARY"
        case 3:
            monthName = "MARCH"
        case 4:
            monthName = "APRIL"
        case 5:
            monthName = "MAY"
        case 6:
            monthName = "JUNE"
        case 7:
            monthName = "JULY"
        case 8:
            monthName = "AUGUST"
        case 9:
            monthName = "SEPTEMBER"
        case 10:
            monthName = "OCTOBER"
        case 11:
            monthName = "NOVEMBER"
        case 12:
            monthName = "DECEMBER"
        default:
            monthName = "OF THIS MONTH"
        }
        
        switch week {
        case 1:
            weekName = "SUNDAY"
        case 2:
            weekName = "MONDAY"
        case 3:
            weekName = "TUESDAY"
        case 4:
            weekName = "WEDNESDAY"
        case 5:
            weekName = "THURSDAY"
        case 6:
            weekName = "FRIDAY"
        case 7:
            weekName = "SATURDAY"
        default:
            weekName = "TODAY"
        }
        
        switch hour {
        case 12,13,14,15:
            greeting = "GOOD AFTERNOON"
        case 16,17,18,19,20,21:
            greeting = "GOOD EVENING"
        case 22,23,24,00,0,1,2,3:
            greeting = "GOOD NIGHT"
        case 4,5,6,7,8,9,10,11:
            greeting = "GOOD MORNING"
        default:
            greeting = "HAVE A GREAT DAY"
        }
        
//        if hour == 12 || 13 || 14 || 15 {
//            greetText.text = "Good Afternoon"
//        }
        
        dateLabel.text = "\(day) \(monthName)"
        weekLabel.text = "\(weekName)"
        greetText.text = "\(greeting)"
        
        
        
        do {
            let audioPath = Bundle.main.path(forResource: "aug-ps-raj", ofType: "mp3")

            try player = AVAudioPlayer(contentsOf: NSURL(fileURLWithPath: audioPath!) as URL)
        } catch {
            // Catch the error
        }
        
        sermonSlider.maximumValue = Float(player.duration)
        print("The Sermon duration is \(player.duration)")
        
        Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(SermonSliderCustomise), userInfo: nil, repeats: true)
        
        ApplyCornerRadius(viewName: greetView)
        ApplyCornerRadius(viewName: audioPlayerView)
        ApplyCornerRadius(viewName: goalView)
        ApplyCornerRadius(viewName: confessionView)
        ApplyCornerRadius(viewName: streakView)
        ApplyCornerRadius(viewName: logoutBtn)
        
        audioPlayerView.setHorizontalGradientBackground(colorOne: Colors.lightBlue, colorTwo: Colors.darkBlue)
        goalView.setHorizontalGradientBackground(colorOne: Colors.lightGreen, colorTwo: Colors.darkGreen)
        streakView.setDiagonalGradientBackground(colorOne: Colors.lightPurple, colorTwo: Colors.darkPurple)
        logoutBtn.setHorizontalGradientBackground(colorOne: Colors.darkRed, colorTwo: Colors.lightRed)
        
    }
    
    func ApplyCornerRadius(viewName: UIView!) {
        viewName.layer.cornerRadius = 25
        viewName.layer.masksToBounds = true
    }
    
    // Sermon Player
    @IBAction func PlayPauseAudioButton(_ sender: UIButton) {
        
        if sender.currentImage == #imageLiteral(resourceName: "play-btn") {
            sender.setImage(#imageLiteral(resourceName: "pause-btn"), for: .normal)
            
            player.prepareToPlay()
            player.play()
            
            let session = AVAudioSession.sharedInstance()

            do {
                try session.setCategory(AVAudioSessionCategoryPlayback)
            } catch {
                // Catch the error
            }

        } else {
            sender.setImage(#imageLiteral(resourceName: "play-btn"), for: .normal)
            print("This works")
            player.pause()
        }
    }
    
//    override func viewDidAppear(_ animated: Bool) {
//
////        appDel.ref.child("sermonplayer").queryOrdered(byChild: "sermonurl").queryEqual(toValue : "Today")
//
//        appDel.ref.child("sermonplayer").child("sermonurl").observe(.value, with: { (snapshot) in
//            if let value = snapshot.value {
//                print("The Sermon URL Value is \(String(describing: value))")
//
//                self.SermonSuccess(value: value as! String)
//
//            } else {
//                print ("Some error")
//            }
//
//        }) { (error) in
//            print(error.localizedDescription)
//        }
//    }

    func SermonSuccess(value: String) {

        do {
//            let audioPath = Bundle.main.path(forResource: "aug-ps-raj", ofType: "mp3")
            try player = AVAudioPlayer(contentsOf: NSURL(fileURLWithPath: value) as URL)
        } catch {
            // Catch the error
        }


    }
    
    @IBAction func SermonSliderChanged(_ sender: AnyObject) {
        player.stop()
        playPauseBtn.setImage(#imageLiteral(resourceName: "play-btn"), for: .normal)
        player.currentTime = TimeInterval(sermonSlider.value)
        player.prepareToPlay()
    }
    
    @objc func SermonSliderCustomise() {
        
        sermonSlider.value = Float(player.currentTime)
    }
    
    // Goals View
    
    @IBAction func PrayForAnHourButton(_ sender: UIButton) {
        if sender.currentImage == #imageLiteral(resourceName: "goal-btn") {
            sender.setImage(#imageLiteral(resourceName: "goal-tick"), for: .normal)
        } else {
            sender.setImage(#imageLiteral(resourceName: "goal-btn"), for: .normal)
        }
    }
    @IBAction func ReadTheBibleButton(_ sender: UIButton) {
        if sender.currentImage == #imageLiteral(resourceName: "goal-btn") {
            sender.setImage(#imageLiteral(resourceName: "goal-tick"), for: .normal)
        } else {
            sender.setImage(#imageLiteral(resourceName: "goal-btn"), for: .normal)
        }
    }
    @IBAction func ListenASermonButton(_ sender: UIButton) {
        if sender.currentImage == #imageLiteral(resourceName: "goal-btn") {
            sender.setImage(#imageLiteral(resourceName: "goal-tick"), for: .normal)
        } else {
            sender.setImage(#imageLiteral(resourceName: "goal-btn"), for: .normal)
        }
    }
    
    // Confession View
    
    @IBAction func ConfessionButtonTapped(_sender: UIButton) {
        performSegue(withIdentifier: "confessionSegue", sender: Any?.self)
        print("Segue succesful")
    }
    
    // Logout
    
    @IBAction func logoutButtonTapped(_ sender: UIButton) {
        sender.pulsate()
        do {
           try Auth.auth().signOut()
            self.performSegue(withIdentifier: "logout", sender: Any?.self)
            print("Logged out")
        } catch {
            print("Signout error")
        }
    }

    
}
