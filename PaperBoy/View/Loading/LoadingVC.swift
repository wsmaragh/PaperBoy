//
//  LoadingVC.swift
//  PaperBoy
//
//  Created by Winston Maragh on 11/7/18.
//  Copyright © 2018 Winston Maragh. All rights reserved.
//

import UIKit
import AVKit

final class LoadingVC: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAndPlayVideo()
        view.backgroundColor = .darkGray
    }
    
    func setupAndPlayVideo() {
        guard let videoURL = Bundle.main.url(forResource: "newsvideo", withExtension: "mp4") else { return }
        
        var avPlayer = AVPlayer()
        avPlayer = AVPlayer(url: videoURL)
        
        let avPlayerLayer = AVPlayerLayer(player: avPlayer)
        avPlayerLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        avPlayer.volume = 0
        avPlayer.actionAtItemEnd = AVPlayer.ActionAtItemEnd.none
        avPlayerLayer.frame = view.layer.bounds
        
        let layer = UIView(frame: self.view.frame)
        view.backgroundColor = UIColor.clear
        view.layer.insertSublayer(avPlayerLayer, at: 0)
        view.addSubview(layer)
        view.sendSubviewToBack(layer)
        
        avPlayer.play()
        
        NotificationCenter.default.addObserver(self, selector: #selector(playerDidFinishedPlaying), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: avPlayer.currentItem)
    }
    
    @objc func playerDidFinishedPlaying(notification: NSNotification) {
        if let _ = notification.object as? AVPlayerItem {
            dismiss(animated: true, completion: nil)
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
}
