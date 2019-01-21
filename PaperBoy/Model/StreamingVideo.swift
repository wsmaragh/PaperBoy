//
//  Video.swift
//  PaperBoy
//
//  Created by Winston Maragh on 10/1/18.
//  Copyright © 2018 Winston Maragh. All rights reserved.
//

import Foundation

struct StreamingVideoJSON: Codable {
    var streamingVideos: [StreamingVideo]
}

struct StreamingVideo: Codable {
    let title: String
    let imageStr: String?
    let videoStr: String
    let source: String
    let time: Int
}
