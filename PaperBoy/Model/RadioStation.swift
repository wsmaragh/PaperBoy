
import UIKit
import SwiftyJSON



class RadioStation: NSObject {
    
    @objc var stationName: String
    @objc var stationStreamURL: String
    @objc var stationImageString: String
    @objc var stationDesc: String
    @objc var stationLongDesc: String
    var isPlaying: Bool = false

    
    @objc init(name: String, streamURL: String, imageURL: String, desc: String, longDesc: String) {
        self.stationName      = name
        self.stationStreamURL = streamURL
        self.stationImageString  = imageURL
        self.stationDesc      = desc
        self.stationLongDesc  = longDesc
    }
    
    @objc init(dict: [String : Any]) {
        self.stationName = dict["name"] as? String ?? ""
        self.stationStreamURL = dict["streamURL"] as? String ?? ""
        self.stationImageString = dict["imageURL"] as? String ?? ""
        self.stationDesc = dict["desc"] as? String ?? ""
        self.stationLongDesc = dict["longDesc"] as? String ?? ""
    }
    
    @objc convenience init(name: String, streamURL: String, imageURL: String, desc: String) {
        self.init(name: name, streamURL: streamURL, imageURL: imageURL, desc: desc, longDesc: "")
    }
    
    final class func parseStation(_ stationJSON: JSON) -> RadioStation {
        let name      = stationJSON["name"].string ?? ""
        let streamURL = stationJSON["streamURL"].string ?? ""
        let imageURL  = stationJSON["imageURL"].string ?? ""
        let desc      = stationJSON["desc"].string ?? ""
        let longDesc  = stationJSON["longDesc"].string ?? ""
        let station = RadioStation(name: name, streamURL: streamURL, imageURL: imageURL, desc: desc, longDesc: longDesc)
        return station
    }
    
}
