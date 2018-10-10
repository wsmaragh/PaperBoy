//
//  VideoVC.swift
//  PaperBoy
//
//  Created by Winston Maragh on 10/6/18.
//  Copyright © 2018 Winston Maragh. All rights reserved.
//

import UIKit
import AVKit


class VideoVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var avPlayerViewController: AVPlayerViewController?
    let videos: [Video] = Video.allVideos
    

    override func viewDidLoad() {
        super.viewDidLoad()
        addRightSwipeGestureToSideMenu()
        setupTableView()
        loadStream()
    }
    
    func setupTableView(){
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 85
        tableView.backgroundColor = .white
        tableView.bounces = false
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
    
    private func loadStream(){
        if let url = URL(string: "http://devimages.apple.com/iphone/samples/bipbop/bipbopall.m3u8") {
            avPlayerViewController?.player = AVPlayer(url: url)
            avPlayerViewController?.player?.play()
            let playerLayerAV = AVPlayerLayer(player: avPlayerViewController?.player)
            avPlayerViewController?.player?.play()
        }
    }
    
    func playMedia(url: URL) {
        if let player = avPlayerViewController?.player {
            let videoItem = AVPlayerItem(url: url)
            player.replaceCurrentItem(with: videoItem)
            player.play()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "embedAVPlayer",
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
        let video = videos[indexPath.row]
        if let videoURL = URL(string: video.videoStr) {
            self.playMedia(url: videoURL)
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 85
    }
    
}


// MARK: VideoCellDelegate
extension VideoVC: VideoCellDelegate {
    
    func didSelectCell() {
        print("cell clicked")
    }
    
    
}

