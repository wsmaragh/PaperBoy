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


protocol NowPlayingVCDelegate: class {
    func stationMetaDataDidUpdate(_ track: Track)
    func artworkDidUpdate(_ track: Track)
    func trackPlayingToggled(_ track: Track)
}


class NowPlayingVC: UIViewController {
    
    @IBOutlet weak var stationImageView: UIImageView!
    @IBOutlet weak var stationLabel: UILabel!
    @IBOutlet weak var playPauseButton: UIButton!
    @IBOutlet weak var volumeSlider: UISlider!
    @IBOutlet weak var volumeView: UIView!
    
    
    @IBAction func playBtnPressed() {
        if track.isPlaying {
            playPauseButton.setImage(UIImage(named: "playButton"), for: .normal)
            radioPlayer.pause()
            nowPlayingImageView.stopAnimating()
            track.isPlaying = false
            self.delegate?.trackPlayingToggled(self.track)
        } else {
            radioPlayer.play()
            playPauseButton.setImage(UIImage(named: "pauseButton"), for: .normal)
            nowPlayingImageView.startAnimating()
            track.isPlaying = true
            self.delegate?.trackPlayingToggled(self.track)
        }
    }

    
    @IBAction func volumeSliderChanged(_ sender: UISlider) {
        mpVolumeSlider.value = sender.value
    }
    
    @IBAction func shareBtnPressed(_ sender: UIButton) {
        let radioStationToShare = "I'm listening to \(track.title) on \(currentStation.stationName) via PaperBoy"
        let activityViewController = UIActivityViewController(activityItems: [radioStationToShare, track.artworkImage!], applicationActivities: nil)
        present(activityViewController, animated: true, completion: nil)
    }
    
    
    static let id = "NowPlayingVC"
    
    weak var delegate: NowPlayingVCDelegate?
    
    @objc var radioPlayer: AVPlayer!
    @objc var nowPlayingImageView: UIImageView!
    @objc var currentStation: RadioStation!
    @objc var newStation = true
    @objc var downloadTask: URLSessionDownloadTask?
    @objc var justBecameActive = false
    
    var track: Track!
    var isPlaying: Bool = false

    @objc var mpVolumeSlider = UISlider()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        setupUserActivity()
        createNowPlayingAnimationBarItem()
        setupRadioPlayer()
        addMyObservers()
        checkForStationChange()
        setupVolumeSlider()
        self.title = currentStation.stationName
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
    
    private func checkForStationChange(){
        if newStation {
            track = Track()
            changeStationAndPlay()
        } else {
            updateLabels()
            stationImageView.image = track.artworkImage
        }
    }
    
    @objc func didBecomeActiveNotificationReceived() {
        justBecameActive = true
        updateLabels()
        updateAlbumArtwork()
    }
    
    deinit {
        removeMyObservers()
    }
    
    @objc func setupRadioPlayer(){
        radioPlayer = MediaPlayer.radio
        radioPlayer.rate = 1
    }
    
    @objc func setupVolumeSlider() {
        volumeView.backgroundColor = UIColor.clear
        let mpLocalVolumeView = MPVolumeView(frame: volumeView.bounds)
        
        for view in mpLocalVolumeView.subviews {
            let uiview: UIView = view as UIView
            if (uiview.description as NSString).range(of: "MPVolumeSlider").location != NSNotFound {
                mpVolumeSlider = (uiview as! UISlider)
            }
        }
        
        let sliderThumbImage = UIImage(named: "slider-ball")
        volumeSlider?.setThumbImage(sliderThumbImage, for: UIControl.State())
    }
    
    @objc func changeStationAndPlay() {
        guard let streamURL = URL(string: currentStation.stationStreamURL) else {return}
        let station = CustomAVPlayerItem(url: streamURL)
        station.delegate = self
        DispatchQueue.main.async {
            self.radioPlayer.replaceCurrentItem(with: station)
            self.radioPlayer.play()
            self.nowPlayingImageView.startAnimating()
        }
        resetRadioStationArtwork()
        track.isPlaying = true
    }

    @objc func updateLabels(_ statusMessage: String = "") {
        if statusMessage != "" {
            stationLabel.text = currentStation.stationName
        }
        else {
            if track != nil {
                stationLabel.text = track.title
            }
        }
    }
    
    
    @objc func createNowPlayingAnimationBarItem() {
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
    
    
    @objc func resetRadioStationArtwork() {
        track.artworkLoaded = false
        track.artworkURL = currentStation.stationImageURL
        DispatchQueue.main.async { [unowned self] in
            self.updateAlbumArtwork()
        }
    }
    
    @objc func updateAlbumArtwork() {
        track.artworkLoaded = false
        
        if track.artworkURL.range(of: "http") != nil {
            
            if let url = URL(string: track.artworkURL) {
                self.downloadTask = self.stationImageView.loadImageWithURL(url) { (image) in
                    self.track.artworkImage = image
                    self.track.artworkLoaded = true
                    DispatchQueue.main.async {
                        UIApplication.shared.isNetworkActivityIndicatorVisible = false
                        self.updateLockScreen()
                        self.delegate?.artworkDidUpdate(self.track)
                    }
                }
            }
            
            if track.artworkLoaded && !self.justBecameActive {
                self.justBecameActive = false
            }
            
        }
        
        else if track.artworkURL != "" {
            self.stationImageView.image = UIImage(named: track.artworkURL)
            track.artworkImage = stationImageView.image
            track.artworkLoaded = true
            self.delegate?.artworkDidUpdate(self.track)
            
        }
        
        else {
            DispatchQueue.main.async {
                self.stationImageView.image = UIImage(named: "albumArt")
                self.track.artworkImage = self.stationImageView.image
            }
        }
        
        DispatchQueue.main.async {
            self.view.setNeedsDisplay()
        }
    }


    // MARK: - MPNowPlayingInfoCenter (Lock screen)
    @objc func updateLockScreen() {
        let albumArtwork = MPMediaItemArtwork(image: track.artworkImage!)
        
        MPNowPlayingInfoCenter.default().nowPlayingInfo = [
            MPMediaItemPropertyArtist: track.artist,
            MPMediaItemPropertyTitle: track.title,
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

}



// MARK: - AVPlayerItem Delegate (for metadata)
extension NowPlayingVC: CustomAVPlayerItemDelegate {
    
    @objc func onMetaData(_ metaData: [AVMetadataItem]?) {
        
        if let metaDatas = metaData {
            
            let firstMeta: AVMetadataItem = metaDatas.first!
            let metaData = firstMeta.value as! String
            var stringParts = [String]()
            if metaData.range(of: " - ") != nil {
                stringParts = metaData.components(separatedBy: " - ")
            } else {
                stringParts = metaData.components(separatedBy: "-")
            }
            
            let currentSongName = track.title
            track.artist = stringParts[0].decodeToUTF8()
            track.title = stringParts[0].decodeToUTF8()
            
            if stringParts.count > 1 {
                track.title = stringParts[1].decodeToUTF8()
            }
            
            if track.artist == "" && track.title == "" {
                track.artist = currentStation.stationDesc
                track.title = currentStation.stationName
            }
            
            DispatchQueue.main.async {
                if currentSongName != self.track.title {
                    self.stationLabel.text = self.track.title
                    self.delegate?.stationMetaDataDidUpdate(self.track)
                    self.resetRadioStationArtwork()
                }
                self.stationLabel.text = self.track.title
            }
        }
    }
}
