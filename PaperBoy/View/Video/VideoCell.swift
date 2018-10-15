//
//  VideoCell.swift
//  PaperBoy
//
//  Created by Winston Maragh on 10/1/18.
//  Copyright © 2018 Winston Maragh. All rights reserved.
//

import UIKit
import AVFoundation


protocol VideoCellDelegate {
    func playVideoInCell()
    func pauseVideoInCell()
    func didFinishPlayingVideoInCell()
}


class VideoCell: UITableViewCell {

    @IBOutlet weak var videoImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var sourceLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var doneButton: UIButton!
    
    static let id = "VideoCell"
    
    var delegate: VideoCellDelegate?
    
    private var countdownTimer = Timer()
    private var timeUpdateInterval: Double = 0.01
    private var workoutTime: Double = 0
    private var labelCountDownTime: Double = 0
    private var progressBarTime: Double = 0
    private var audioPlayer: AVAudioPlayer?
    private var alreadyWatchedVideo: Bool = false
    
    var isCurrentlyPlayingVideo: Bool = false
    
    override func awakeFromNib(){
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        if selected {
            togglePlayPause()
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        sourceLabel.text  = nil
        titleLabel.text  = nil
        videoImageView.image = nil
    }

    func configureCell(video: StreamingVideo){
        titleLabel.text = video.title
        sourceLabel.text = video.source
        workoutTime = Double(video.time)
        labelCountDownTime = Double(video.time)
        timeLabel.text = timeFormatted(video.time)
        videoImageView.loadImage(imageURLString: video.imageStr)
    }
    
    private func togglePlayPause(){
        if isCurrentlyPlayingVideo {
            pauseCountdown()
        } else {
            startCountdown()
        }
    }
    
    func startCountdown(){
        progressBar.progress = 0.00
        countdownTimer = Timer.scheduledTimer(timeInterval: timeUpdateInterval, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
        isCurrentlyPlayingVideo = true
        delegate?.playVideoInCell()
    }
    
    func pauseCountdown() {
        countdownTimer.invalidate()
        progressBar.progress = 0.0
        labelCountDownTime = workoutTime
        timeLabel.text = "\(timeFormatted(Int(labelCountDownTime)))"
        alreadyWatchedVideo = false
        isCurrentlyPlayingVideo = false
        delegate?.pauseVideoInCell()
    }
    
    func completeCountdown(){
        countdownTimer.invalidate()
        doneButton.isHidden = false
        alreadyWatchedVideo = true
        isCurrentlyPlayingVideo = false
        playBeepSound()
        delegate?.didFinishPlayingVideoInCell()
    }
    
    private func playBeepSound(){
        guard let soundPath = Bundle.main.path(forResource: "beep", ofType: "mp3") else {return}
        let soundURL = URL(fileURLWithPath: soundPath)
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
            try! audioPlayer = AVAudioPlayer(contentsOf: soundURL)
        } catch {
            print(error)
        }
        audioPlayer!.prepareToPlay()
        audioPlayer!.play()
    }
    
    private func timeFormatted(_ totalSeconds: Int) -> String {
        let minutes: Int = (totalSeconds / 60) % 60
        let seconds: Int = totalSeconds % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    @objc private func updateTime() {
        if isCurrentlyPlayingVideo {
            timeLabel.text = "\(timeFormatted(Int(labelCountDownTime)))"
            progressBar.progress = Float(progressBarTime)/Float(workoutTime)
            
            if progressBarTime < workoutTime {
                labelCountDownTime -= timeUpdateInterval
                progressBarTime += timeUpdateInterval
            } else if progressBarTime >= workoutTime {
                completeCountdown()
            }
        } else {
            pauseCountdown()
        }
    }
    
}

