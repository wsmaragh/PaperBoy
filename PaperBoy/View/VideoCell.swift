//
//  VideoCell.swift
//  PaperBoy
//
//  Created by Winston Maragh on 10/1/18.
//  Copyright © 2018 Winston Maragh. All rights reserved.
//

import UIKit


@objc protocol VideoCellDelegate {
//    @objc func savePressed(video: Video)
//    @objc func sharePressed(video: Video)
}


class VideoCell: UITableViewCell {

    @IBOutlet weak var videoImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var sourceLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    weak var delegate: VideoCellDelegate?

    static let id = "VideoCell"
    
    #warning("REMOVE - dont like the idea of the cell owning a video")
    var video: Video?

    func configureCell(video: Video){
        titleLabel.text = video.title
        sourceLabel.text = video.source
        timeLabel.text = "\(video.time)"
        videoImageView.loadImage(imageURLString: video.videoStr)
    }
}

