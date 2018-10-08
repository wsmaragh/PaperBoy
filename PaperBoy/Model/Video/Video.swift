//
//  Video.swift
//  PaperBoy
//
//  Created by Winston Maragh on 10/1/18.
//  Copyright © 2018 Winston Maragh. All rights reserved.
//

import Foundation


struct Video {
    
    let title: String
    let videoStr: String
    let source: String
    let time: Int
    
    static let sampleVideos: [Video] = {
        let videos = [
            Video(title: "Animated Movie", videoStr: "http://184.72.239.149/vod/smil:BigBuckBunny.smil/playlist.m3u8", source: "Wowza", time: 120),
            Video(title: "Parkour", videoStr: "https://bitdash-a.akamaihd.net/content/MI201109210084_1/m3u8s/f08e80da-bf1d-4e3d-8899-f0f6155f6efa.m3u8", source: "Parkour", time: 420),
            Video(title: "Humming Bird", videoStr: "https://devimages-cdn.apple.com/samplecode/avfoundationMedia/AVFoundationQueuePlayer_HLS2/master.m3u8", source: "Apple", time: 360),
            Video(title: "Snow Mountain", videoStr: "https://bitdash-a.akamaihd.net/content/sintel/hls/playlist.m3u8", source: "Videogame", time: 180)
        ]
        return videos
    }()
    
}


struct Stream {
    
    let title: String
    let urlStr: String
    
    static let allStreams: [Stream] = {
        let stream1 = Stream(title: "BipBop", urlStr: "http://devimages.apple.com/iphone/samples/bipbop/bipbopall.m3u8")
        let stream2 = Stream(title: "Snow Mountain", urlStr: "https://bitdash-a.akamaihd.net/content/sintel/hls/playlist.m3u8")
        let stream3 = Stream(title: "Cartoon", urlStr: "http://184.72.239.149/vod/smil:BigBuckBunny.smil/playlist.m3u8")
        let stream4 = Stream(title: "Parkour", urlStr: "https://bitdash-a.akamaihd.net/content/MI201109210084_1/m3u8s/f08e80da-bf1d-4e3d-8899-f0f6155f6efa.m3u8")
        let stream5 = Stream(title: "Bird", urlStr: "https://devimages-cdn.apple.com/samplecode/avfoundationMedia/AVFoundationQueuePlayer_HLS2/master.m3u8")
        let stream6 = Stream(title: "Sample", urlStr: "https://devimages-cdn.apple.com/samplecode/avfoundationMedia/AVFoundationQueuePlayer_HLS2/master.m3u8")
        let streams = [stream1, stream2, stream3, stream4, stream5, stream6]
        return streams
    }()
    
}
