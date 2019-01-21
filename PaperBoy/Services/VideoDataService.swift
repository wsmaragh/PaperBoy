//
//  VideoDataService.swift
//  PaperBoy
//
//  Created by Winston Maragh on 10/19/18.
//  Copyright © 2018 Winston Maragh. All rights reserved.
//

import Foundation
import Alamofire
import Photos

final class VideoDataService {
    
    func getStreamingVideosFromFile(completion: @escaping ([StreamingVideo]) -> Void) {
        guard let filePath = Bundle.main.path(forResource: "StreamingVideos", ofType:"json") else {return}
        let filePathURL = URL(fileURLWithPath: filePath)
        
        do {
            let data = try Data(contentsOf: filePathURL, options: Data.ReadingOptions.uncached)
            let JSON = try JSONDecoder().decode(StreamingVideoJSON.self, from: data)
            let streamingVideos = JSON.streamingVideos
            completion(streamingVideos)
        } catch {print("Error processing data. Error: \(error)")}
    }
    
    func getDownloadableVideosFromFile(completion: @escaping ([DownloadableVideo]) -> Void) {
        guard let filePath = Bundle.main.path(forResource: "DownloadableVideos", ofType:"json") else {
            return
        }
        let filePathURL = URL(fileURLWithPath: filePath)
        
        do {
            let data = try Data(contentsOf: filePathURL, options: Data.ReadingOptions.uncached)
            let JSON = try JSONDecoder().decode(DownloadableVideoJSON.self, from: data)
            let downloadableVideos = JSON.downloadableVideos
            completion(downloadableVideos)
        } catch {print("Error processing data. Error: \(error)")}
    }
    
    
    func saveVideo(videoUrlStr: String) {
        DispatchQueue.global(qos: .background).async {
            guard let videoUrl = URL(string: videoUrlStr) else {return}
            var videoData: Data!
            
            do {
                videoData = try Data(contentsOf: videoUrl)
            } catch {
                print("error converting to video Data")
            }
            
            let documentPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            guard let filePath = URL(string: "\(documentPath)/tempVideoFile.mp4") else {return}
            
            DispatchQueue.main.async {
                do {
                    try videoData.write(to: filePath, options: Data.WritingOptions.atomic)
                } catch {
                    print("Error writing data to filepath")
                }
                
                PHPhotoLibrary.shared().performChanges({
                    PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: filePath)
                }, completionHandler: { (saved, _) in
                    if saved {
                        print("Video saved successfully")
                    }
                })
            }
        }
    }
    
}
