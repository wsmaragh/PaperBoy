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
    
    
    override func awakeFromNib(){
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        if selected {
            startCountdown()
        } else {
            stopCountdown()
        }
    }
    

    func configureCell(video: Video){
        if let imageStr = video.imageStr {
            videoImageView.image = UIImage(named: imageStr)
        }
        titleLabel.text = video.title
        sourceLabel.text = video.source
        workoutTime = 10 // Double(video.time)
        labelCountDownTime = 10 //Double(video.time)
        timeLabel.text = timeFormatted(10) //timeFormatted(video.time)

    }
    
    func startCountdown(){
        progressBar.progress = 0.00
        countdownTimer = Timer.scheduledTimer(timeInterval: timeUpdateInterval, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
    }
    
    @objc private func updateTime() {
        // display
        timeLabel.text = "\(timeFormatted(Int(labelCountDownTime)))"
        progressBar.progress = Float(progressBarTime)/Float(workoutTime)
        
        //update
        if progressBarTime < workoutTime {
            labelCountDownTime -= timeUpdateInterval
            progressBarTime += timeUpdateInterval
        } else if progressBarTime >= workoutTime {
            doneButton.isHidden = false
            completeCountdown()
        } 
    }
    
    private func stopCountdown() {
        countdownTimer.invalidate()
        progressBar.progress = 0.0
        labelCountDownTime = workoutTime
        timeLabel.text = "\(timeFormatted(Int(labelCountDownTime)))"
    }
    
    private func completeCountdown(){
        countdownTimer.invalidate()
        playBeepSound()
        delegate?.didFinishPlayingVideoInCell()
    }
    
    private func playBeepSound(){
        let alertSound = URL(fileURLWithPath: Bundle.main.path(forResource: "beep", ofType: "mp3")!)
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
            try! audioPlayer = AVAudioPlayer(contentsOf: alertSound)
        } catch {
            print(error)
        }
        audioPlayer!.prepareToPlay()
        audioPlayer!.play()
    }
    
    private func timeFormatted(_ totalSeconds: Int) -> String {
        let seconds: Int = totalSeconds % 60
        let minutes: Int = (totalSeconds / 60) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
}

