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
import Firebase
import Jukebox

class HomeVC: UIViewController, JukeboxDelegate {
    func jukeboxStateDidChange(_ jukebox: Jukebox) {
        
        UIView.animate(withDuration: 0.3, animations: { () -> Void in
//            self.indicator.alpha = jukebox.state == .loading ? 1 : 0
            self.playPauseBtn.alpha = jukebox.state == .loading ? 0 : 1
            self.playPauseBtn.isEnabled = jukebox.state == .loading ? false : true
        })
        
        if jukebox.state == .ready {
            playPauseBtn.setImage(UIImage(named: "play-btn"), for: UIControlState())
        } else if jukebox.state == .loading  {
            playPauseBtn.setImage(UIImage(named: "pause-btn"), for: UIControlState())
        } else {
            let imageName: String
            switch jukebox.state {
            case .playing, .loading:
                imageName = "pause-btn"
            case .paused, .failed, .ready:
                imageName = "play-btn"
            }
            playPauseBtn.setImage(UIImage(named: imageName), for: UIControlState())
        }
        
        print("Jukebox state changed to \(jukebox.state)")
        
    }
    
    func jukeboxPlaybackProgressDidChange(_ jukebox: Jukebox) {
        
        if let currentTime = jukebox.currentItem?.currentTime, let duration = jukebox.currentItem?.meta.duration {
            let value = Float(currentTime / duration)
            sermonSlider.value = value
            populateLabelWithTime(currentTimeLabel, time: currentTime)
            populateLabelWithTime(durationLabel, time: duration)
        } else {
//            resetUI() // Check this later
        }
    }
    
    func jukeboxDidLoadItem(_ jukebox: Jukebox, item: JukeboxItem) {
        print("Jukebox did load: \(item.URL.lastPathComponent)")

    }
    
    func jukeboxDidUpdateMetadata(_ jukebox: Jukebox, forItem: JukeboxItem) {
        print("Item updated:\n\(forItem)")
    }
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var weekLabel: UILabel!
    @IBOutlet weak var logoutBtn: UIButton!
    
    @IBOutlet weak var greetView: UIView!
    @IBOutlet weak var greetImage: UIImageView!
    @IBOutlet weak var greetText: UILabel!
    
    @IBOutlet weak var audioPlayerView: UIView!
    @IBOutlet weak var playPauseBtn: UIButton!
    @IBOutlet weak var sermonSlider: UISlider!
    
    @IBOutlet weak var currentTimeLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var sermonTitle: UILabel!
    @IBOutlet weak var sermonPreacher: UILabel!
    
    @IBOutlet weak var confessionView: UIView!
    
    @IBOutlet weak var giveOnlineView: UIView!
    
    @IBOutlet weak var streakView: UIView!
    
    let appDel = UIApplication.shared.delegate as! AppDelegate
    
    var jukebox : Jukebox!
    
    var player: AVAudioPlayer = AVAudioPlayer()
    
//    var testimony = [Post]()
//    var feedArray = [Post]()
//    var databaseRef: DatabaseReference!
//    let cellScaling : CGFloat = 0.6

    
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
        
        print("The day is \(day)")
        
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
        
        dateLabel.text = "\(day) \(monthName)"
        weekLabel.text = "\(weekName)"
        greetText.text = "\(greeting)"
        
        
        UIApplication.shared.beginReceivingRemoteControlEvents()
        
        appDel.ref.child("sermonplayer").child("sermonurl").observe(.value, with: { (snapshot) in
            if let value = snapshot.value {
                
                print("The Sermon URL Value is \(String(describing: value))")
                
                self.jukebox = Jukebox(delegate: self, items: [JukeboxItem(URL: URL(string: value as! String)!)])
                
//                self.liveStreamTitle.text = (value as! String)
                
            } else {
                print ("Some error")
            }
            
        }) { (error) in
            print(error.localizedDescription)
        }
        
        appDel.ref.child("sermonplayer").child("sermonpreacher").observe(.value, with: { (snapshot) in
            if let value = snapshot.value {
                print("The Sermon Preacher Name is \(String(describing: value))")
                
//                self.jukebox = Jukebox(delegate: self, items: [JukeboxItem(URL: URL(string: value as! String)!)])
                
                self.sermonPreacher.text = (value as! String)
                
            } else {
                print ("Some error")
            }
            
        }) { (error) in
            print(error.localizedDescription)
        }
        
        appDel.ref.child("sermonplayer").child("sermontitle").observe(.value, with: { (snapshot) in
            if let value = snapshot.value {
                print("The Sermon URL Value is \(String(describing: value))")
                self.sermonTitle.text = (value as! String)

//                self.jukebox = Jukebox(delegate: self, items: [JukeboxItem(URL: URL(string: value as! String)!)])
                
                
            } else {
                print ("Some error")
            }
            
        }) { (error) in
            print(error.localizedDescription)
        }
        
        ApplyCornerRadius(viewName: greetView)
        ApplyCornerRadius(viewName: audioPlayerView)
//        ApplyCornerRadius(viewName: goalView)
        ApplyCornerRadius(viewName: confessionView)
        ApplyCornerRadius(viewName: giveOnlineView)
        ApplyCornerRadius(viewName: streakView)
        ApplyCornerRadius(viewName: logoutBtn)
        
        audioPlayerView.setHorizontalGradientBackground(colorOne: Colors.lightBlue, colorTwo: Colors.darkBlue)
//        goalView.setHorizontalGradientBackground(colorOne: Colors.lightGreen, colorTwo: Colors.darkGreen)
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
            
            jukebox.play()
            

        } else {
            sender.setImage(#imageLiteral(resourceName: "play-btn"), for: .normal)
            print("This works")
            jukebox.pause()
        }
    }

//    func SermonSuccess(value: String) {

//        do {
////            let audioPath = Bundle.main.path(forResource: "aug-ps-raj", ofType: "mp3")
////            try player = AVAudioPlayer(contentsOf: NSURL(fileURLWithPath: value) as URL)
//        } catch {
//            // Catch the error
//        }

//    }
    
    @IBAction func SermonSliderChanged(_ sender: AnyObject) {
//        jukebox.stop()
//        playPauseBtn.setImage(#imageLiteral(resourceName: "play-btn"), for: .normal)
        if let duration = jukebox.currentItem?.meta.duration {
            jukebox.seek(toSecond: Int(Double(sermonSlider.value) * duration))
        }
    }
    
    @objc func SermonSliderCustomise() {
        
    }
    
    
    func populateLabelWithTime(_ label : UILabel, time: Double) {
        let minutes = Int(time / 60)
        let seconds = Int(time) - minutes * 60
        
        label.text = String(format: "%02d", minutes) + ":" + String(format: "%02d", seconds)
    }
    
    // Goals View
    
//    @IBAction func PrayForAnHourButton(_ sender: UIButton) {
//        if sender.currentImage == #imageLiteral(resourceName: "goal-btn") {
//            sender.setImage(#imageLiteral(resourceName: "goal-tick"), for: .normal)
//        } else {
//            sender.setImage(#imageLiteral(resourceName: "goal-btn"), for: .normal)
//        }
//    }
//    @IBAction func ReadTheBibleButton(_ sender: UIButton) {
//        if sender.currentImage == #imageLiteral(resourceName: "goal-btn") {
//            sender.setImage(#imageLiteral(resourceName: "goal-tick"), for: .normal)
//        } else {
//            sender.setImage(#imageLiteral(resourceName: "goal-btn"), for: .normal)
//        }
//    }
//    @IBAction func ListenASermonButton(_ sender: UIButton) {
//        if sender.currentImage == #imageLiteral(resourceName: "goal-btn") {
//            sender.setImage(#imageLiteral(resourceName: "goal-tick"), for: .normal)
//        } else {
//            sender.setImage(#imageLiteral(resourceName: "goal-btn"), for: .normal)
//        }
//    }
//
    
//    Give Online
    
    @IBAction func GiveOnlineButtonTapped(_sender: UIButton) {
        performSegue(withIdentifier: "giveOnlineSegue", sender: Any?.self)
        print("Give Online Segue succesful")
    }
    
    // Confession View
    
    @IBAction func ConfessionButtonTapped(_sender: UIButton) {
        performSegue(withIdentifier: "confessionSegue", sender: Any?.self)
        print("Confession Segue succesful")
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
    
    override func remoteControlReceived(with event: UIEvent?) {
        if event?.type == .remoteControl {
            switch event!.subtype {
            case .remoteControlPlay :
                jukebox.play()
            case .remoteControlPause :
                jukebox.pause()
            case .remoteControlNextTrack :
                jukebox.playNext()
            case .remoteControlPreviousTrack:
                jukebox.playPrevious()
            case .remoteControlTogglePlayPause:
                if jukebox.state == .playing {
                    jukebox.pause()
                } else {
                    jukebox.play()
                }
            default:
                break
            }
        }
    }

    
}



//extension HomeVC : UICollectionViewDataSource {
//    func numberOfSections(in collectionView: UICollectionView) -> Int {
//        return 1
//    }
//
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return testimony.count
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TestimonyCell", for: indexPath) as! TestimonyCollectionViewCell
//
////        @IBOutlet weak var testimonyImageView: UIImageView!
////        @IBOutlet weak var testimonyTitleLabel: UILabel!
////        @IBOutlet weak var testimonyDescriptionLabel: UILabel!
////        @IBOutlet weak var bgColorView: UIView!
//
//                cell.testimonyTitleLabel.text = testimony[indexPath.row].testimonyTitle
//                cell.testimonyDescriptionLabel.text = testimony[indexPath.row].testimonyDescription
//
//
//        return cell
//
//    }
//}

