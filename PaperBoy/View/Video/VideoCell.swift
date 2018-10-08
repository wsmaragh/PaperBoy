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
    
    override func awakeFromNib(){
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    private func timeConverter(seconds: Int) -> String {
        let x = seconds / 60
        let y = seconds % (60 * x)
        if y < 10 {
            return "\(x):0\(y)"
        }
        return "\(x):\(y)"
    }
    
    func configureCell(video: Video){
        titleLabel.text = video.title
        sourceLabel.text = video.source
        timeLabel.text = timeConverter(seconds: video.time)
        videoImageView.loadImage(imageURLString: video.videoStr)
    }
}

