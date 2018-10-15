//
//  DownloadableVideos.swift
//  PaperBoy
//
//  Created by Winston Maragh on 10/15/18.
//  Copyright © 2018 Winston Maragh. All rights reserved.
//

import Foundation


struct DownloadableVideo {
    
    var name: String
    var urlLink: String
    var length: Int //seconds
    var size: Int //mb
    
    
    #warning("sample vidoes for testing")
    static let sampleDownloadableVideos = [
        DownloadableVideo(name: "Video 1", urlLink: "https://www.sample-videos.com/video/mp4/720/big_buck_bunny_720p_1mb.mp4", length: 5, size: 1),
        DownloadableVideo(name: "Video 2", urlLink: "https://www.sample-videos.com/video/mp4/720/big_buck_bunny_720p_2mb.mp4", length: 13, size: 2),
        DownloadableVideo(name: "Video 3", urlLink: "https://www.sample-videos.com/video/mp4/720/big_buck_bunny_720p_5mb.mp4", length: 29, size: 5),
        DownloadableVideo(name: "Video 4", urlLink: "https://www.sample-videos.com/video/mp4/720/big_buck_bunny_720p_10mb.mp4", length: 62, size: 10),
        DownloadableVideo(name: "Video 5", urlLink: "https://www.sample-videos.com/video/mp4/720/big_buck_bunny_720p_20mb.mp4", length: 117, size: 20),
        DownloadableVideo(name: "Video 6", urlLink: "https://www.sample-videos.com/video/mp4/720/big_buck_bunny_720p_30mb.mp4", length: 170, size: 30),
        DownloadableVideo(name: "Video 7", urlLink: "https://www.sample-videos.com/video/mp4/720/big_buck_bunny_720p_50mb.mp4", length: 281, size: 50),
    ]
    
    // save videos
    static func saveVideo(videoUrlStr: String){
        
        DispatchQueue.global(qos: .background).async {
            
            guard let videoUrl = URL(string: videoUrlStr) else {return}
            guard let videoData = NSData(contentsOf: videoUrl) else {return}
            
            let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0];
            
            let filePath="\(documentsPath)/tempVideoFile.mp4"
            
            DispatchQueue.main.async {
                
                videoData.write(toFile: filePath, atomically: true)
                
                PHPhotoLibrary.shared().performChanges({
                    PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: URL(fileURLWithPath: filePath))
                }) { completed, error in
                    if completed {
                        print("Video is saved!")
                    }
                }
                
            }
        }
    }
    
}
