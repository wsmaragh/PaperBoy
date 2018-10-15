//
//  Video.swift
//  PaperBoy
//
//  Created by Winston Maragh on 10/1/18.
//  Copyright © 2018 Winston Maragh. All rights reserved.
//

import Foundation


struct StreamingVideo {
    
    let title: String
    let imageStr: String?
    let videoStr: String
    let source: String
    let time: Int
    
    static let allVideos: [StreamingVideo] = {
        let video1 = StreamingVideo(title: "BipBop", imageStr: "bipbop", videoStr: "http://devimages.apple.com/iphone/samples/bipbop/bipbopall.m3u8", source: "Apple", time: 1800)
        let video2 = StreamingVideo(title: "Cartoon", imageStr: "cartoonWowza", videoStr: "http://184.72.239.149/vod/smil:BigBuckBunny.smil/playlist.m3u8", source: "Wowza", time: 597)
        let video3 = StreamingVideo(title: "Humming Bird", imageStr: "hummingBird", videoStr: "https://devimages-cdn.apple.com/samplecode/avfoundationMedia/AVFoundationQueuePlayer_HLS2/master.m3u8", source: "Apple", time: 20)
        let video4 = StreamingVideo(title: "Parkour", imageStr: "parkour", videoStr: "https://bitdash-a.akamaihd.net/content/MI201109210084_1/m3u8s/f08e80da-bf1d-4e3d-8899-f0f6155f6efa.m3u8", source: "Parkour", time: 209)
        let video5 = StreamingVideo(title: "Snow Mountain", imageStr: "snowMountain", videoStr: "https://bitdash-a.akamaihd.net/content/sintel/hls/playlist.m3u8", source: "Videogame", time: 888)
        let videos = [video1, video2, video3, video4, video5]
        return videos
    }()
    
}
