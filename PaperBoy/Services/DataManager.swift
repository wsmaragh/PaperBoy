//
//  DataManager.swift
//  PaperBoy
//
//  Created by Winston Maragh on 10/6/18.
//  Copyright © 2018 Winston Maragh. All rights reserved.
//

import UIKit


class DataManager {
    
    class func getStationDataWithSuccess(_ completion: @escaping ((_ metaData: Data?) -> Void)) {
        DispatchQueue.global(qos: .background).async {
            if useLocalStations {
                getDataFromFile() { data in
                    completion(data)
                }
            } else {
                loadDataFromURL(URL(string: stationDataURL)!) { data, error in
                    if let urlData = data {
                        completion(urlData)
                    }
                }
            }
        }
    }
    
    
    class func getDataFromFile(_ completion: (_ data: Data) -> Void) {
        if let filePath = Bundle.main.path(forResource: "stations", ofType:"json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: filePath),
                                    options: NSData.ReadingOptions.uncached)
                completion(data)
            } catch {
                fatalError()
            }
        } else {
            print("The local JSON file could not be found")
        }
    }
    
    // Get LastFM/iTunes Data
    class func getTrackData(_ queryURL: String, completion: @escaping ((_ metaData: Data?) -> Void)) {
        loadDataFromURL(URL(string: queryURL)!) { data, _ in
            if let urlData = data {
                completion(urlData)
            } else {
                print("API TIMEOUT OR ERROR")
            }
        }
    }
    
    
    class func loadDataFromURL(_ url: URL, completion:@escaping (_ data: Data?, _ error: NSError?) -> Void) {
        let sessionConfig = URLSessionConfiguration.default
        sessionConfig.allowsCellularAccess          = true
        sessionConfig.timeoutIntervalForRequest     = 15
        sessionConfig.timeoutIntervalForResource    = 30
        sessionConfig.httpMaximumConnectionsPerHost = 1
        
        let session = URLSession(configuration: sessionConfig)
        
        let loadDataTask = session.dataTask(with: url, completionHandler: { data, response, error in
            if let responseError = error {
                completion(nil, responseError as NSError?)
                #warning("REMOVE - only for testing")
                print("API ERROR: \(error)")
                UIApplication.shared.isNetworkActivityIndicatorVisible = false // Stop activity Indicator
            } else if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode != 200 {
                    let statusError = NSError(domain:"com.winstonmaragh", code:httpResponse.statusCode, userInfo:[NSLocalizedDescriptionKey : "HTTP status code has unexpected value."])
                    #warning("REMOVE - only for testing")
                    print("API: HTTP status code has unexpected value")
                    completion(nil, statusError)
                } else {
                    completion(data, nil)
                }
            }
        })
        
        loadDataTask.resume()
    }
}
