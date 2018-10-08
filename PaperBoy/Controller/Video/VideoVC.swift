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
    
    @IBAction func sideMenuPressed() {
        NotificationCenter.default.post(name: NSNotification.Name("toggleSideMenu"), object: nil)
    }
    
    @IBOutlet weak var optionsView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    
    let videos: [Video] = Video.allVideos
    
    var avPlayerViewController: AVPlayerViewController?

    
    override func viewDidLoad() {
        super.viewDidLoad()
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
    
    private func loadStream(){
        if let url = URL(string: "http://devimages.apple.com/iphone/samples/bipbop/bipbopall.m3u8") {
            avPlayerViewController?.player = AVPlayer(url: url)
        }
    }
    
    func playMedia(url: URL) {
        if let player = avPlayerViewController?.player {
            let videoItem = AVPlayerItem(url: url)
            player.replaceCurrentItem(with: videoItem)
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "embedAVPlayer", let avPlayerVC = segue.destination as? AVPlayerViewController {
            avPlayerViewController = avPlayerVC
            self.addChild(avPlayerVC)
        }
    }
    
}



// MARK: Tableview
extension VideoVC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if videos.count == 0 {
            return 0
        }
        return videos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "VideoCell", for: indexPath) as! VideoCell
        let video = videos[indexPath.row]
        cell.configureCell(video: video)
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

