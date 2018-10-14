
import UIKit
import Alamofire


class RadioDataService {
    
    final class func getRadioStationsFromFile(completion: @escaping ([RadioStation]) -> Void) {
        guard let filePath = Bundle.main.path(forResource: "RadioStations", ofType:"json") else {
            print("Error getting filePath")
            return
        }
        let filePathURL = URL(fileURLWithPath: filePath)
        
        do {
            let data = try Data(contentsOf: filePathURL, options: Data.ReadingOptions.uncached)
            let JSON = try JSONDecoder().decode(RadioStationJSON.self, from: data)
            let stations = JSON.stations
            completion(stations)
        } catch {print("Error processing data. Error: \(error)")}
    
    }

    
    final class func getRadioStationsFromURL(urlString: String, completion: @escaping ([RadioStation]) -> Void) {
        guard let url = URL(string: urlString) else {return}
        Alamofire.request(url).responseJSON { (response) in
            if response.result.isSuccess {
                if let data = response.data {
                    do {
                        let JSON = try JSONDecoder().decode(RadioStationJSON.self, from: data)
                        let stations = JSON.stations
                        completion(stations)
                    }
                    catch {print("Error processing data. Error: \(error)")}
                }
            } else {
                print("Error\(String(describing: response.result.error))")
            }
        }
    }
}
