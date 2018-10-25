//
//  DownloadableVideos.swift
//  PaperBoy
//
//  Created by Winston Maragh on 10/15/18.
//  Copyright © 2018 Winston Maragh. All rights reserved.
//

import Foundation

class DownloadableVideoJSON: Codable {
    var downloadableVideos: [DownloadableVideo]
}

struct DownloadableVideo: Codable {
    var name: String
    var urlLink: String
    var length: Int //seconds
    var size: Int //mb
}
