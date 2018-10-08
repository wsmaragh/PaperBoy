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
    func songMetaDataDidUpdate(_ track: Track)
    func artworkDidUpdate(_ track: Track)
    func trackPlayingToggled(_ track: Track)
}


class NowPlayingVC: UIViewController {
    
    @IBOutlet weak var songImageView: UIImageView!
    @IBOutlet weak var songImageHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var stationLabel: UILabel!
    @IBOutlet weak var playBtn: UIButton!
    @IBOutlet weak var pauseBtn: UIButton!
    @IBOutlet weak var volumeSlider: UISlider!
    @IBOutlet weak var songLbl: UILabel!
    @IBOutlet weak var volumeView: UIView!
    @IBOutlet weak var artistLbl: UILabel!
    
    @IBAction func playBtnPressed() {
        track.isPlaying = true
        playButtonEnable(false)
        radioPlayer.play()
        nowPlayingImageView.startAnimating()
        self.delegate?.trackPlayingToggled(self.track)
    }
    
    @IBAction func pauseBtnPressed() {
        track.isPlaying = false
        playButtonEnable()
        radioPlayer.pause()
        nowPlayingImageView.stopAnimating()
        self.delegate?.trackPlayingToggled(self.track)
    }
    
    @IBAction func volumeSliderChanged(_ sender: UISlider) {
        mpVolumeSlider.value = sender.value
    }
    
    @IBAction func shareBtnPressed(_ sender: UIButton) {
        let songToShare = "I'm listening to \(track.title) on \(currentStation.stationName) via PaperBoy"
        let activityViewController = UIActivityViewController(activityItems: [songToShare, track.artworkImage!], applicationActivities: nil)
        present(activityViewController, animated: true, completion: nil)
    }
    
    
    @IBAction func infoBtnPressed(_ sender: UIButton) {
//        performSegue(withIdentifier: "InfoDetail", sender: self)
    }
    
    
    static let id = "NowPlayingVC"
    
    @objc var currentStation: RadioStation!
    @objc var downloadTask: URLSessionDownloadTask?
    @objc var iPhone4 = false
    @objc var justBecameActive = false
    @objc var newStation = true
    @objc var nowPlayingImageView: UIImageView!
    @objc var radioPlayer: AVPlayer!
    
    var track: Track!
    
    @objc var mpVolumeSlider = UISlider()
    
    weak var delegate: NowPlayingVCDelegate?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUserActivity()
        optimizeForDeviceSize()
        createNowPlayingAnimationBarItem()
        setUpPlayer()
        addMyObservers()
        checkForStationChange()
        setupVolumeSlider()
        self.title = currentStation.stationName
    }
    
    private func addMyObservers(){
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(NowPlayingVC.didBecomeActiveNotificationReceived),
                                               name: NSNotification.Name(rawValue: "UIApplicationDidBecomeActiveNotification"),
                                               object: nil)
        NotificationCenter.default.addObserver(self,
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
            stationDidChange()
            nowPlayingImageView.startAnimating()
        } else {
            updateLabels()
            songImageView.image = track.artworkImage
            
            if !track.isPlaying {
                pauseBtnPressed()
            } else {
                nowPlayingImageView.startAnimating()
            }
        }
    }
    
    @objc func didBecomeActiveNotificationReceived() {
        updateLabels()
        justBecameActive = true
        updateAlbumArtwork()
    }
    
    deinit {
        removeMyObservers()
        resetPlayer()
    }
    
    @objc func setUpPlayer(){
        radioPlayer = MediaPlayer.radio
        radioPlayer.rate = 1
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.playerItemDidReachEnd),
            name: NSNotification.Name.AVPlayerItemDidPlayToEndTime,
            object: self.radioPlayer.currentItem
        )
    }
    
    @objc func resetPlayer(){
        if radioPlayer != nil {
            NotificationCenter.default.removeObserver(
                self,
                name: NSNotification.Name.AVPlayerItemDidPlayToEndTime,
                object: self.radioPlayer.currentItem)
        }
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
        
        let thumbImageNormal = UIImage(named: "slider-ball")
        volumeSlider?.setThumbImage(thumbImageNormal, for: UIControl.State())
    }
    
    @objc func stationDidChange() {
        resetPlayer()
        
        guard let streamURL = URL(string: currentStation.stationStreamURL) else {
            print("Stream Error \(currentStation.stationStreamURL)")
            return
        }
        
        let streamItem = CustomAVPlayerItem(url: streamURL)
        streamItem.delegate = self
        
        DispatchQueue.main.async {
            self.radioPlayer.replaceCurrentItem(with: streamItem)
            self.radioPlayer.play()
        }
    
        updateLabels("Streaming from:")
        resetAlbumArtwork()
        track.isPlaying = true
    }
    
    
    
    @objc func togglePlayPause() {
        if track.isPlaying {
            pauseBtnPressed()
        } else {
            playBtnPressed()
        }
    }
    
    
    @objc func optimizeForDeviceSize() {
        let deviceHeight = self.view.bounds.height
        if deviceHeight == 480 {
            iPhone4 = true
            songImageHeightConstraint.constant = 106
            view.updateConstraints()
        } else if deviceHeight == 667 {
            songImageHeightConstraint.constant = 230
            view.updateConstraints()
        } else if deviceHeight > 667 {
            songImageHeightConstraint.constant = 260
            view.updateConstraints()
        }
    }
    
    @objc func updateLabels(_ statusMessage: String = "") {
        if statusMessage != "" {
            songLbl.text = ""
            artistLbl.text = currentStation.stationName
        } else {
            if track != nil {
                songLbl.text = track.title
                artistLbl.text = track.artist
            }
        }
        
        #warning("REMOVE")
        if track.artworkLoaded || iPhone4 {
//            stationLabel.isHidden = true
        } else {
//            stationLabel.isHidden = false
//            stationLabel.text = currentStation.stationDesc
        }
    }
    
    @objc func playButtonEnable(_ enabled: Bool = true) {
        if enabled {
            playBtn.isEnabled = true
            pauseBtn.isEnabled = false
            track.isPlaying = false
        } else {
            playBtn.isEnabled = false
            pauseBtn.isEnabled = true
            track.isPlaying = true
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
        
    }
    
    @objc func startNowPlayingAnimation() {
        DispatchQueue.main.async { [unowned self] in
            self.nowPlayingImageView.startAnimating()
        }
    }
    
    @objc func resetAlbumArtwork() {
        track.artworkLoaded = false
        track.artworkURL = currentStation.stationImageURL
        DispatchQueue.main.async { [unowned self] in
            self.updateAlbumArtwork()
//            self.stationLabel.isHidden = false
        }
    }
    
    @objc func updateAlbumArtwork() {
        track.artworkLoaded = false
        if track.artworkURL.range(of: "http") != nil {
            DispatchQueue.main.async {
//                self.stationLabel.isHidden = false
            }
            
            if let url = URL(string: track.artworkURL) {
                self.downloadTask = self.songImageView.loadImageWithURL(url) { (image) in
                    
                    self.track.artworkImage = image
                    self.track.artworkLoaded = true
                    
                    DispatchQueue.main.async {
                        UIApplication.shared.isNetworkActivityIndicatorVisible = false
//                        self.stationLabel.isHidden = true
                        self.updateLockScreen()
                        self.delegate?.artworkDidUpdate(self.track)
                    }
                    
                }
            }
            
            if track.artworkLoaded && !self.justBecameActive {
//                self.stationLabel.isHidden = true
                self.justBecameActive = false
            }
            
        } else if track.artworkURL != "" {
            self.songImageView.image = UIImage(named: track.artworkURL)
            track.artworkImage = songImageView.image
            track.artworkLoaded = true
            self.delegate?.artworkDidUpdate(self.track)
            
        } else {
            // No Station or API art found, use default art
            DispatchQueue.main.async {
                self.songImageView.image = UIImage(named: "albumArt")
                self.track.artworkImage = self.songImageView.image
            }
        }
        
        // Force app to update display
        DispatchQueue.main.async {
            self.view.setNeedsDisplay()
        }
    }
    
    
    @objc func queryAlbumArt() {
        DispatchQueue.main.async {
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
        }

        let queryURL: String
        
        switch Settings.coverApi {
        case .lastFm:
            queryURL = String(format: "http://ws.audioscrobbler.com/2.0/?method=track.getInfo&api_key=%@&artist=%@&track=%@&format=json", APIKeys.lastFmApiKey, track.artist, track.title)
            break
        case .iTunes:
            queryURL = String(format: "https://itunes.apple.com/search?term=%@+%@&entity=song", track.artist, track.title)
            break
            
        }
        
        let escapedURL = queryURL.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
        
        RadioDataService.getTrackData(escapedURL!) { (data) in
            
            var json: JSON!
            
            do {
                json = try JSON(data: data!)
            } catch {
                print("Error converting data to JSON")
            }
           
            
            switch Settings.coverApi {
            case .lastFm:
                if let imageArray = json["track"]["album"]["image"].array {
                    
                    let arrayCount = imageArray.count
                    let lastImage = imageArray[arrayCount - 1]
                    
                    if let artURL = lastImage["#text"].string {
                        if artURL.range(of: "/noimage/") != nil {
                            self.resetAlbumArtwork()
                        } else {
                            self.track.artworkURL = artURL
                            self.track.artworkLoaded = true
                            self.updateAlbumArtwork()
                        }
                    } else {
                        self.resetAlbumArtwork()
                    }
                } else {
                    self.resetAlbumArtwork()
                }
                break
                
            case .iTunes:
                // Use iTunes API. Images are 100px by 100px
                if let artURL = json["results"][0]["artworkUrl100"].string {
                    print("iTunes artURL: \(artURL)")
                    self.track.artworkURL = artURL
                    self.track.artworkLoaded = true
                    self.updateAlbumArtwork()
                } else {
                    self.resetAlbumArtwork()
                }
                break
            }
            
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "InfoDetail" {
//            let infoController = segue.destination as! InfoDetailViewController
//            infoController.currentStation = currentStation
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
        
        MPRemoteCommandCenter.shared().playCommand.isEnabled = true
        MPRemoteCommandCenter.shared().playCommand.addTarget(self, action: #selector(playBtnPressed))
        MPRemoteCommandCenter.shared().pauseCommand.isEnabled = true
        MPRemoteCommandCenter.shared().pauseCommand.addTarget(self, action: #selector(pauseBtnPressed))
        MPRemoteCommandCenter.shared().togglePlayPauseCommand.isEnabled = true
        MPRemoteCommandCenter.shared().togglePlayPauseCommand.addTarget(self, action: #selector(togglePlayPause))
    }
    
    override func remoteControlReceived(with receivedEvent: UIEvent?) {
        super.remoteControlReceived(with: receivedEvent)
        
        if receivedEvent!.type == UIEvent.EventType.remoteControl {
            
            switch receivedEvent!.subtype {
            case .remoteControlPlay:
                playBtnPressed()
            case .remoteControlPause:
                pauseBtnPressed()
            default:
                break
            }
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
    
    
    // MARK: -
    @objc func setupUserActivity() {
        let activity = NSUserActivity(activityType: NSUserActivityTypeBrowsingWeb )
        userActivity = activity
        let url = "https://www.google.com/search?q=\(self.artistLbl.text!)+\(self.songLbl.text!)"
        let urlStr = url.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
        let searchURL : URL = URL(string: urlStr!)!
        activity.webpageURL = searchURL
        userActivity?.becomeCurrent()
    }
    
    override func updateUserActivityState(_ activity: NSUserActivity) {
        let url = "https://www.google.com/search?q=\(self.artistLbl.text!)+\(self.songLbl.text!)"
        let urlStr = url.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
        let searchURL : URL = URL(string: urlStr!)!
        activity.webpageURL = searchURL
        super.updateUserActivityState(activity)
    }
    
    
    // MARK: - Detect end of mp3 if using a file instead of a stream
    @objc func playerItemDidReachEnd(){
        print("playerItemDidReachEnd")
    }
}




// MARK: - AVPlayerItem Delegate (for metadata)
extension NowPlayingVC: CustomAVPlayerItemDelegate {
    
    @objc func onMetaData(_ metaData: [AVMetadataItem]?) {
        if let metaDatas = metaData{
            startNowPlayingAnimation()
            let firstMeta: AVMetadataItem = metaDatas.first!
            let metaData = firstMeta.value as! String
            var stringParts = [String]()
            if metaData.range(of: " - ") != nil {
                stringParts = metaData.components(separatedBy: " - ")
            } else {
                stringParts = metaData.components(separatedBy: "-")
            }
            
            // Set artist & songvariables
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
                    // Update Labels
                    self.artistLbl.text = self.track.artist
                    self.songLbl.text = self.track.title
                    self.updateUserActivityState(self.userActivity!)
                    
                    // songLabel animation
//                    self.songLbl.animation = "zoomIn"
//                    self.songLbl.duration = 1.5
//                    self.songLbl.damping = 1
//                    self.songLbl.animate()
                    
                    // Update Stations Screen
                    self.delegate?.songMetaDataDidUpdate(self.track)
                    
                    // Query API for album art
                    self.resetAlbumArtwork()
                    self.queryAlbumArt()
                    
                }
                self.artistLbl.text = self.track.artist
                self.songLbl.text = self.track.title
            }
        }
    }
}
