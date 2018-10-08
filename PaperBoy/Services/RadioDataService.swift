
import UIKit


class RadioDataService {
    
    class func getStationData(_ completion: @escaping ((_ metaData: Data?) -> Void)) {
        DispatchQueue.global(qos: .background).async {
            switch Settings.stationType {
            case .localStations:
                loadDataFromFile() { data in
                    completion(data)
                }
            case .onlineStations:
                loadDataFromURL(URL(string: Settings.StationType.onlineStations.rawValue)!) { data, error in
                    if let urlData = data {
                        completion(urlData)
                    }
                }
            }
        }
    }
    
    
    class private func loadDataFromFile(_ completion: (_ data: Data) -> Void) {
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
    
    
    class func getTrackData(_ queryURL: String, completion: @escaping ((_ metaData: Data?) -> Void)) {
        loadDataFromURL(URL(string: queryURL)!) { data, _ in
            if let urlData = data {
                completion(urlData)
            } else {
                print("API Timeput or Error")
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
                print("API ERROR: \(error)")
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
            }
            else if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode != 200 {
                    let statusError = NSError(domain:"com.winstonmaragh", code:httpResponse.statusCode, userInfo:[NSLocalizedDescriptionKey : "HTTP status code has unexpected value."])
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
