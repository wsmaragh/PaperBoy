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

    override func viewDidLoad() {
        super.viewDidLoad()
        addRightSwipeGestureToSideMenu()
        setupTableView()
    }
    
    func setupTableView(){
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 75
        tableView.backgroundColor = .white
        tableView.bounces = true
        let nib = UINib(nibName: "VideoCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "VideoCell")
    }
    
    
    func addRightSwipeGestureToSideMenu() {
        let swipeGesture = UISwipeGestureRecognizer.init(target: self, action: #selector(slideToMenu))
        swipeGesture.direction = .right
        view.addGestureRecognizer(swipeGesture)
    }
    
    @IBAction func sideMenuPressed() {
        slideToMenu()
    }
    
    @objc func slideToMenu(){
        NotificationCenter.default.post(name: NSNotification.Name("toggleSideMenu"), object: nil)
    }

    private func playVideo(videoString: String){
        if let url = URL(string: videoString) {
            if videoPlaying {
                let videoItem = AVPlayerItem(url: url)
                avPlayerViewController?.player?.replaceCurrentItem(with: videoItem)
                avPlayerViewController?.player?.play()
            } else {
                avPlayerViewController?.player = AVPlayer(url: url)
                avPlayerViewController?.player?.play()
                videoPlaying = true
            }
        }
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
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("did select pressed")
        self.currentVideoPlayingIndex = indexPath.row
        guard videos.count != 0 else {return}
        let video = videos[indexPath.row]
        self.playVideo(videoString: video.videoStr)
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        
    }
    

    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
}



// MARK: VideoCellDelegate

extension VideoVC: VideoCellDelegate {
    
    func didFinishPlayingVideoInCell() {
        //stop current video
        self.avPlayerViewController?.player?.pause()
        guard currentVideoPlayingIndex < videos.count else {return}
        self.currentVideoPlayingIndex += 1
        self.tableView.selectRow(at: IndexPath(row: currentVideoPlayingIndex, section: 0), animated: true, scrollPosition: UITableView.ScrollPosition.top)
    }
    
    func cancelPlayingVideoInCell() {
//        self.tableView.deselectRow(at: IndexPath(row: <#T##Int#>, section: <#T##Int#>), animated: <#T##Bool#>)
        //stop video
    }
    
}

