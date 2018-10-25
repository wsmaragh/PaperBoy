//
//  MediaPlayer.swift
//  PaperBoy
//
//  Created by Winston Maragh on 9/26/18.
//  Copyright © 2018 Winston Maragh. All rights reserved.
//

import Foundation
import MediaPlayer

struct MediaPlayer {
    static var radio = AVPlayer()
}

class StationAVPlayerItem: AVPlayerItem {
    
    init(url URL: URL) {
        super.init(asset: AVAsset(url: URL), automaticallyLoadedAssetKeys:[])
    }

}
