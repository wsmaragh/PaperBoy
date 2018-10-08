//
//  VideoCell.swift
//  PaperBoy
//
//  Created by Winston Maragh on 10/1/18.
//  Copyright © 2018 Winston Maragh. All rights reserved.
//

import UIKit

class VideoCell: UITableViewCell {

    @IBOutlet weak var videoImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var sourceLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
        
    func configureCell(video: Video){
        titleLabel.text = video.title
        sourceLabel.text = video.source
        timeLabel.text = "\(video.time)"
        videoImageView.loadImage(imageURLString: video.videoStr)
    }
}

