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
    
    let videoDataService = VideoDataService()
    
    var videoPlayerController: AVPlayerViewController?
    
    var streamingVideos: [StreamingVideo] = []
    var downloadableVideos: [DownloadableVideo] = []

    var currentVideoPlayingIndex: Int = 0
    var videoPlaying: Bool = false
    var videoTimer = Timer()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        addRightSwipeGestureToSideMenu()
        getStreamingVideos()
        getDownloadableVideos()
    }
    
    private func getDownloadableVideos() {
        videoDataService.getDownloadableVideosFromFile { (parsedDownloadableVideos) in
            self.downloadableVideos = parsedDownloadableVideos
        }
    }
    
    private func getStreamingVideos() {
        videoDataService.getStreamingVideosFromFile { (parsedStreamingVideos) in
            self.streamingVideos = parsedStreamingVideos
            self.reloadTableView()
        }
    }
    
    private func setupTableView(){
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 75
        tableView.backgroundColor = .white
        let nib = UINib(nibName: VideoCell.nibName, bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: VideoCell.cellID)
    }
    
    private func reloadTableView() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    private func addRightSwipeGestureToSideMenu() {
        let swipeGesture = UISwipeGestureRecognizer.init(target: self, action: #selector(slideToMenu))
        swipeGesture.direction = .right
        view.addGestureRecognizer(swipeGesture)
    }
    
    @IBAction func sideMenuPressed() {
        slideToMenu()
    }
    
    @objc func slideToMenu(){
        NotificationCenter.default.post(name: NSNotification.Name(NotificationNames.toggleSideMenu.rawValue), object: nil)
    }

    private func playVideo(video: StreamingVideo){
        
        guard let url = URL(string: video.videoStr) else { return }
        let asset: AVURLAsset = AVURLAsset(url: url)
        let videoItem: AVPlayerItem = AVPlayerItem(asset: asset)
        videoPlayerController?.player = AVPlayer(playerItem: videoItem)
        videoPlayerController?.player?.play()
        videoPlaying = true
        let duration = videoPlayerController!.player!.currentItem!.duration.seconds
        
        videoTimer = Timer.scheduledTimer(withTimeInterval: duration, repeats: false, block: { (timer) in
            self.videoPlayerController!.player!.pause()
            self.videoPlaying = false
            self.videoTimer.invalidate()
        })
    
//            if videoPlaying {
//                self.videoPlayerController!.player!.pause()
//                let videoItem = AVPlayerItem(url: url)
//                videoPlayerController?.player?.replaceCurrentItem(with: videoItem)
//                videoPlayerController?.player?.play()
//                let duration = videoPlayerController!.player!.currentItem!.duration.seconds
//                videoTimer = Timer.scheduledTimer(withTimeInterval: duration, repeats: false, block: { (timer) in
//                    self.videoPlayerController!.player!.pause()
//                    self.videoPlaying = false
//                    self.videoTimer.invalidate()
//                })
//            } else {
//                videoPlayerController?.player = AVPlayer(url: url)
//                videoPlayerController?.player?.play()
//                videoPlaying = true
//                let duration = videoPlayerController!.player!.currentItem!.duration.seconds
//                videoTimer = Timer.scheduledTimer(withTimeInterval: duration, repeats: false, block: { (timer) in
//                    self.videoPlayerController!.player!.pause()
//                    self.videoPlaying = false
//                    self.videoTimer.invalidate()
//                })
//            }
    }
    
    private func pauseVideo(){
        self.videoPlayerController?.player?.pause()
        guard let indexPath = tableView.indexPathForSelectedRow else {return}
        let cell = tableView.cellForRow(at: indexPath) as! VideoCell
        cell.pauseCountdown()
        cell.delegate = self
        cell.isCurrentlyPlayingVideo = false
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "embeddedAVPlayer",
            let avPlayerVC = segue.destination as? AVPlayerViewController {
                videoPlayerController = avPlayerVC
                self.addChild(avPlayerVC)
        }
    }
    
}


// MARK: Tableview

extension VideoVC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return streamingVideos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: VideoCell.cellID, for: indexPath) as! VideoCell
        let video = streamingVideos[indexPath.row]
        cell.configureCell(video: video)
        cell.delegate = self
        cell.backgroundColor = (indexPath.row % 2 == 0) ?  UIColor.lightText : UIColor.appTableGray            
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.currentVideoPlayingIndex = indexPath.row
        guard streamingVideos.count != 0 else {return}
        let video = streamingVideos[currentVideoPlayingIndex]
        self.playVideo(video: video)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}



// MARK: VideoCellDelegate

extension VideoVC: VideoCellDelegate {
    
    func playVideoInCell() {
        self.videoPlayerController?.player?.play()
    }
    
    func pauseVideoInCell(){
        self.videoPlayerController?.player?.pause()
    }
    
    func didFinishPlayingVideoInCell() {
        self.videoPlayerController?.player?.pause()
        guard currentVideoPlayingIndex < streamingVideos.count else {return}
        self.currentVideoPlayingIndex += 1
        guard currentVideoPlayingIndex < streamingVideos.count else {return}
        let video = streamingVideos[currentVideoPlayingIndex]
        self.playVideo(video: video)
        self.tableView.selectRow(at: IndexPath(row: currentVideoPlayingIndex, section: 0), animated: true, scrollPosition: UITableView.ScrollPosition.top)
    }

}
