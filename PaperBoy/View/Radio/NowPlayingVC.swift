//
//  NowPlayingVC.swift
//  PaperBoy
//
//  Created by Winston Maragh on 10/6/18.
//  Copyright © 2018 Winston Maragh. All rights reserved.
//

import UIKit
import MediaPlayer

class NowPlayingVC: UIViewController {
    
    @IBOutlet weak var stationImageView: UIImageView!
    @IBOutlet weak var stationLabel: UILabel!
    @IBOutlet weak var playPauseButton: UIButton!
    @IBOutlet weak var volumeView: UIView!
    @IBOutlet weak var volumeSlider: UISlider!
    
    @IBOutlet weak var radioPlayingButton: UIBarButtonItem!
    
    @objc var mpVolumeSlider = UISlider()
        
    static var controllerID: String {
        return String(describing: self)
    }
    
    @objc var radioPlayer: AVPlayer!
    
    @objc var currentStation: RadioStation! {
        didSet {
            playRadioStation()
        }
    }
    @objc var newStation: Bool = true
    @objc var justBecameActive: Bool = false
    
    fileprivate var isPlaying: Bool = false
    fileprivate var nowPlayingBars: UIImageView!
    
    deinit {
        removeMyObservers()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBar()
        setupRadioPlayer()
        setupVolumeSlider()
        addMyObservers()
        updateUI()
        setupLockScreenRemoteControls()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.topItem?.title = ""
    }
    
    private func setupNavBar() {
        setupNowPlayingBarButtonAnimation()
    }
    
    private func setupNowPlayingBarButtonAnimation() {
        nowPlayingBars = UIImageView(image: UIImage(named: "NowPlayingBars"))
        nowPlayingBars.autoresizingMask = UIView.AutoresizingMask()
        nowPlayingBars.contentMode = UIView.ContentMode.center
        nowPlayingBars.animationImages = Animations.movingBarsAnimationImages()
        nowPlayingBars.animationDuration = 0.7
        let nowPlayBarButtonItem = UIBarButtonItem(customView: nowPlayingBars)
        self.navigationItem.rightBarButtonItem = nowPlayBarButtonItem
    }
    
    private func setupRadioPlayer() {
        radioPlayer = MediaPlayer.radio
        radioPlayer.rate = 1
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
    
    private func updateUI() {
        if newStation {
            self.title = currentStation.name
            self.stationLabel.text = currentStation.name
            self.stationImageView.loadImage(imageURLString: currentStation.imageStr)
        }
    }

    @objc private func playRadioStation() {
        guard let streamURL = URL(string: currentStation.streamStr) else {return}
        let station = StationAVPlayerItem(url: streamURL)
        DispatchQueue.main.async {
            self.radioPlayer.replaceCurrentItem(with: station)
            self.radioPlayer.play()
            self.nowPlayingBars.startAnimating()
        }
        currentStation.isPlaying = true
    }

    private func addMyObservers() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(NowPlayingVC.didBecomeActiveNotificationReceived),
            name: NSNotification.Name(rawValue: NotificationNames.UIApplicationDidBecomeActiveNotification.rawValue),
            object: nil)
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(NowPlayingVC.radioAVSessionInterrupted(_:)),
            name: AVAudioSession.interruptionNotification,
            object: AVAudioSession.sharedInstance())
    }

    private func removeMyObservers() {
        NotificationCenter.default.removeObserver(
            self,
            name: NSNotification.Name(rawValue: NotificationNames.UIApplicationDidBecomeActiveNotification.rawValue),
            object: nil)
        
        NotificationCenter.default.removeObserver(
            self,
            name: AVAudioSession.interruptionNotification,
            object: AVAudioSession.sharedInstance())
    }

    @objc func didBecomeActiveNotificationReceived() {
        justBecameActive = true
    }

    @IBAction func playBtnPressed() {
        playPause()
    }

    func playPause() {
        if currentStation.isPlaying {
            playPauseButton.setImage(UIImage(named: "playButton"), for: .normal)
            radioPlayer.pause()

            nowPlayingBars.stopAnimating()
            currentStation.isPlaying = false
        } else {
            radioPlayer.play()
            playPauseButton.setImage(UIImage(named: "pauseButton"), for: .normal)
            nowPlayingBars.startAnimating()
            currentStation.isPlaying = true
        }
    }

    @IBAction func volumeSliderChanged(_ sender: UISlider) {
        mpVolumeSlider.value = sender.value
    }

    @IBAction func shareBtnPressed(_ sender: UIButton) {
        let radioStationToShare = "I'm listening to \(currentStation.name) via PaperBoy"
        let activityViewController = UIActivityViewController(activityItems: [radioStationToShare, currentStation.imageStr], applicationActivities: nil)
        present(activityViewController, animated: true, completion: nil)
    }

    @objc func radioAVSessionInterrupted(_ notification: Notification) {
        if let typeValue = notification.userInfo?[AVAudioSessionInterruptionTypeKey] as? NSNumber {
            if let type = AVAudioSession.InterruptionType(rawValue: typeValue.uintValue) {
                if type == .began {

                } else {

                }
            }
        }
    }

    func setupLockScreenRemoteControls() {
        let commandCenter = MPRemoteCommandCenter.shared()
        commandCenter.playCommand.addTarget { [unowned self] _ in
            if self.radioPlayer.rate == 0.0 {
                self.radioPlayer.play()
                return .success
            }
            return .commandFailed
        }

        commandCenter.pauseCommand.addTarget { [unowned self] _ in
            if self.radioPlayer.rate == 1.0 {
                self.radioPlayer.pause()
                return .success
            }
            return .commandFailed
        }
    }
}
