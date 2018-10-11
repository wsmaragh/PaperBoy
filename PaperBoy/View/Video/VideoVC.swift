//
//  VideoVC.swift
//  PaperBoy
//
//  Created by Winston Maragh on 10/6/18.
//  Copyright © 2018 Winston Maragh. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation




class VideoVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var avPlayerViewController: AVPlayerViewController?
    let videos: [Video] = Video.allVideos
    var currentVideoPlayingIndex: Int = 0
    var videoPlaying: Bool = false
    var videoTimer = Timer()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        addRightSwipeGestureToSideMenu()
        loadLocalVideo()
    }
    
    private func setupTableView(){
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 75
        tableView.backgroundColor = .white
        let nib = UINib(nibName: VideoCell.id, bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: VideoCell.id)
    }
    
    
    private func addRightSwipeGestureToSideMenu() {
        let swipeGesture = UISwipeGestureRecognizer.init(target: self, action: #selector(slideToMenu))
        swipeGesture.direction = .right
        view.addGestureRecognizer(swipeGesture)
    }
    
    private func loadLocalVideo() {
        guard let localVideoPath = Bundle.main.path(forResource: "newsLoading", ofType: "mp4") else {
            print("Error loading local video")
            return
        }
        guard let urlPath = URL(string: localVideoPath) else {return}
        let videoItem = AVPlayerItem(url: urlPath)
        let player = AVPlayer(playerItem: videoItem)
        avPlayerViewController?.player = player
//        avPlayerViewController?.player?.replaceCurrentItem(with: videoItem)
        avPlayerViewController?.player?.play()
        self.videoPlaying = true
        let duration = avPlayerViewController?.player?.currentItem!.duration.seconds
        avPlayerViewController?.player?.actionAtItemEnd
//        videoTimer = Timer.scheduledTimer(withTimeInterval: duration, repeats: false, block: { (timer) in
//            self.avPlayerViewController!.player!.pause()
//            self.videoPlaying = false
//            self.videoTimer.invalidate()
//        })
        
    }
    
    @IBAction func sideMenuPressed() {
        slideToMenu()
    }
    
    @objc func slideToMenu(){
        NotificationCenter.default.post(name: NSNotification.Name(NotificationNames.toggleSideMenu.rawValue), object: nil)
    }

    private func playVideo(video: Video){
        if let url = URL(string: video.videoStr) {
            if videoPlaying {
                self.avPlayerViewController!.player!.pause()
                let videoItem = AVPlayerItem(url: url)
                avPlayerViewController?.player?.replaceCurrentItem(with: videoItem)
                avPlayerViewController?.player?.play()
                let duration = avPlayerViewController!.player!.currentItem!.duration.seconds
                videoTimer = Timer.scheduledTimer(withTimeInterval: duration, repeats: false, block: { (timer) in
                    self.avPlayerViewController!.player!.pause()
                    self.videoPlaying = false
                    self.videoTimer.invalidate()
                })
            } else {
                avPlayerViewController?.player = AVPlayer(url: url)
                avPlayerViewController?.player?.play()
                videoPlaying = true
                let duration = avPlayerViewController!.player!.currentItem!.duration.seconds
                videoTimer = Timer.scheduledTimer(withTimeInterval: duration, repeats: false, block: { (timer) in
                    self.avPlayerViewController!.player!.pause()
                    self.videoPlaying = false
                    self.videoTimer.invalidate()
                })
            }
        }
    }
    
    private func pauseVideo(){
        self.avPlayerViewController?.player?.pause()
        guard let indexPath = tableView.indexPathForSelectedRow else {return}
        let cell = tableView.cellForRow(at: indexPath) as! VideoCell
        cell.delegate = self
        cell.isCurrentlyPlayingVideo = false
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "embeddedAVPlayer",
            let avPlayerVC = segue.destination as? AVPlayerViewController {
                avPlayerViewController = avPlayerVC
                self.addChild(avPlayerVC)
        }
    }
    
}



// MARK: Tableview

extension VideoVC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return videos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: VideoCell.id, for: indexPath) as! VideoCell
        let video = videos[indexPath.row]
        cell.configureCell(video: video)
        cell.delegate = self
        cell.backgroundColor = (indexPath.row % 2 == 0) ?  UIColor.lightText : UIColor.appTableGray            
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.currentVideoPlayingIndex = indexPath.row
        guard videos.count != 0 else {return}
        let video = videos[currentVideoPlayingIndex]
        self.playVideo(video: video)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}



// MARK: VideoCellDelegate

extension VideoVC: VideoCellDelegate {
    
    func cancelPlayingVideoInCell() {
        //
    }
    
    
    func didFinishPlayingVideoInCell() {
        self.avPlayerViewController?.player?.pause()
        guard currentVideoPlayingIndex < videos.count else {return}
        self.currentVideoPlayingIndex += 1
        guard currentVideoPlayingIndex < videos.count else {return}
        let video = videos[currentVideoPlayingIndex]
        self.playVideo(video: video)
        self.tableView.selectRow(at: IndexPath(row: currentVideoPlayingIndex, section: 0), animated: true, scrollPosition: UITableView.ScrollPosition.top)
    }
    
}

