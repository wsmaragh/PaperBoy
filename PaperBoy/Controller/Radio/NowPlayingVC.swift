//
//  NowPlayingVC.swift
//  PaperBoy
//
//  Created by Winston Maragh on 10/6/18.
//  Copyright © 2018 Winston Maragh. All rights reserved.
//

import UIKit
import MediaPlayer
import SwiftyJSON


class NowPlayingVC: UIViewController {
    
    @IBOutlet weak var stationImageView: UIImageView!
    @IBOutlet weak var stationLabel: UILabel!
    @IBOutlet weak var playPauseButton: UIButton!
    @IBOutlet weak var volumeView: UIView!
    @IBOutlet weak var volumeSlider: UISlider!
    
    @objc var mpVolumeSlider = UISlider()
    
    static let id: String = "NowPlayingVC"
    
    @objc var radioPlayer: AVPlayer!
    
    @objc var currentStation: RadioStation!
    @objc var newStation: Bool = true
    @objc var justBecameActive: Bool = false
    
    var isPlaying: Bool = false

    @objc var nowPlayingImageView: UIImageView!
    
    
    deinit {
        removeMyObservers()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupRadioPlayer()
        addMyObservers()
        checkForStationChange()
        createNowPlayingAnimationBarItem()
    }
    
    private func setupUI(){
        self.title = currentStation.stationName
        self.stationLabel.text = currentStation.stationName
        self.stationImageView.loadImage(imageURLString: currentStation.stationImageString)
        setupVolumeSlider()
    }
    
    @objc private func setupVolumeSlider() {
        volumeView.backgroundColor = UIColor.clear
        let mpLocalVolumeView = MPVolumeView(frame: volumeView.bounds)
        
        for view in mpLocalVolumeView.subviews {
            let uiview: UIView = view as UIView
            if (uiview.description as NSString).range(of: "MPVolumeSlider").location != NSNotFound {
                mpVolumeSlider = (uiview as! UISlider)
            }
        }
        
        let sliderThumbImage = UIImage(named: "sliderBall")
        volumeSlider?.setThumbImage(sliderThumbImage, for: UIControl.State())
    }
    
    @objc private func setupRadioPlayer(){
        radioPlayer = MediaPlayer.radio
        radioPlayer.rate = 1
    }
    
    private func checkForStationChange(){
        if newStation {
            changeStationAndPlay()
        }
    }
    
    @objc private func changeStationAndPlay() {
        guard let streamURL = URL(string: currentStation.stationStreamURL) else {return}
        let station = CustomAVPlayerItem(url: streamURL)
        DispatchQueue.main.async {
            self.radioPlayer.replaceCurrentItem(with: station)
            self.radioPlayer.play()
            self.nowPlayingImageView.startAnimating()
        }
        currentStation.isPlaying = true
    }
    
    @objc private func createNowPlayingAnimationBarItem() {
        nowPlayingImageView = UIImageView(image: UIImage(named: "NowPlayingBars-3"))
        nowPlayingImageView.autoresizingMask = UIView.AutoresizingMask()
        nowPlayingImageView.contentMode = UIView.ContentMode.center
        nowPlayingImageView.animationImages = AnimationFrames.createFrames()
        nowPlayingImageView.animationDuration = 0.8
        
        let barButton = UIButton(type: UIButton.ButtonType.custom)
        barButton.frame = CGRect(x: 0, y: 0, width: 40, height: 40);
        barButton.addSubview(nowPlayingImageView)
        nowPlayingImageView.center = barButton.center
        
        let barItem = UIBarButtonItem(customView: barButton)
        self.navigationItem.rightBarButtonItem = barItem
        DispatchQueue.main.async { [unowned self] in
            self.nowPlayingImageView.startAnimating()
        }
    }

    private func addMyObservers(){
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(NowPlayingVC.didBecomeActiveNotificationReceived),
            name: NSNotification.Name(rawValue: "UIApplicationDidBecomeActiveNotification"),
            object: nil)
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(NowPlayingVC.sessionInterrupted(_:)),
            name: AVAudioSession.interruptionNotification,
            object: AVAudioSession.sharedInstance())
    }
    
    private func removeMyObservers(){
        NotificationCenter.default.removeObserver(self, name:NSNotification.Name(rawValue: "UIApplicationDidBecomeActiveNotification"), object: nil)
        NotificationCenter.default.removeObserver(self, name: AVAudioSession.interruptionNotification, object: AVAudioSession.sharedInstance())
    }
    
    @objc func didBecomeActiveNotificationReceived() {
        justBecameActive = true
    }
    
    
    @IBAction func playBtnPressed() {
        if currentStation.isPlaying {
            playPauseButton.setImage(UIImage(named: "playButton"), for: .normal)
            radioPlayer.pause()
            nowPlayingImageView.stopAnimating()
            currentStation.isPlaying = false
        } else {
            radioPlayer.play()
            playPauseButton.setImage(UIImage(named: "pauseButton"), for: .normal)
            nowPlayingImageView.startAnimating()
            currentStation.isPlaying = true
        }
    }
    

    @IBAction func volumeSliderChanged(_ sender: UISlider) {
        mpVolumeSlider.value = sender.value
    }
    
    
    @IBAction func shareBtnPressed(_ sender: UIButton) {
        let radioStationToShare = "I'm listening to \(currentStation.stationName) via PaperBoy"
        let activityViewController = UIActivityViewController(activityItems: [radioStationToShare, currentStation.stationImageString], applicationActivities: nil)
        present(activityViewController, animated: true, completion: nil)
    }


    
    // MARK: - AVAudio Sesssion Interrupted (eg. Phone Call)
    @objc func sessionInterrupted(_ notification: Notification) {
        if let typeValue = notification.userInfo?[AVAudioSessionInterruptionTypeKey] as? NSNumber{
            if let type = AVAudioSession.InterruptionType(rawValue: typeValue.uintValue){
                if type == .began {
                    print("interruption: began")
                } else{
                    print("interruption: ended")
                }
            }
        }
    }
    

    // MARK: - MPNowPlayingInfoCenter (Lock screen)
    @objc func updateLockScreen() {
        let albumArtwork = MPMediaItemArtwork(image: UIImage(named: currentStation.stationImageString)!)
        
        MPNowPlayingInfoCenter.default().nowPlayingInfo = [
            MPMediaItemPropertyArtist: currentStation.stationName,
            MPMediaItemPropertyArtwork: albumArtwork
        ]
//        MPRemoteCommandCenter.shared().playCommand.isEnabled = true
//        MPRemoteCommandCenter.shared().pauseCommand.isEnabled = true
//        MPRemoteCommandCenter.shared().playCommand.addTarget(self, action: #selector(playBtnPressed))
//        MPRemoteCommandCenter.shared().pauseCommand.addTarget(self, action: #selector(playBtnPressed))
        #warning("Change implementation")
        MPRemoteCommandCenter.shared().togglePlayPauseCommand.isEnabled = true
        MPRemoteCommandCenter.shared().togglePlayPauseCommand.addTarget(self, action: #selector(playBtnPressed))
    }
    
    
    override func remoteControlReceived(with receivedEvent: UIEvent?) {
        super.remoteControlReceived(with: receivedEvent)
        if receivedEvent!.type == UIEvent.EventType.remoteControl {
            playBtnPressed()
        }
    }

}
