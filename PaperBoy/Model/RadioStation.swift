
import UIKit

class RadioStationJSON: Codable {
    var stations: [RadioStation]
}

class RadioStation: NSObject, Codable {
    
    @objc var name: String
    @objc var streamStr: String
    @objc var imageStr: String
    @objc var desc: String
    @objc var longDesc: String
    var isPlaying: Bool = false
    
    enum CodingKeys: String, CodingKey {
        case name, streamStr, imageStr, desc, longDesc
    }
    
    @objc init(name: String, streamStr: String, imageStr: String, desc: String, longDesc: String) {
        self.name      = name
        self.streamStr = streamStr
        self.imageStr  = imageStr
        self.desc      = desc
        self.longDesc  = longDesc
    }
    
    @objc init(dict: [String : Any]) {
        self.name = dict["name"] as? String ?? ""
        self.streamStr = dict["streamStr"] as? String ?? ""
        self.imageStr = dict["imageStr"] as? String ?? ""
        self.desc = dict["desc"] as? String ?? ""
        self.longDesc = dict["longDesc"] as? String ?? ""
    }
    
    @objc convenience init(name: String, streamStr: String, imageStr: String, desc: String) {
        self.init(name: name, streamStr: streamStr, imageStr: imageStr, desc: desc, longDesc: "")
    }
    
    
}
