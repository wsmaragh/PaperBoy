//
//  RadioStation.swift
//  PaperBoy
//
//  Created by Winston Maragh on 9/26/18.
//  Copyright © 2018 Winston Maragh. All rights reserved.
//

import Foundation
import RealmSwift

class RadioStationJSON: Codable {
    var stations: [RadioStation]
}

@objcMembers
final class RadioStation: Object, Codable {
    dynamic var name: String = ""
    dynamic var streamStr: String = ""
    dynamic var imageStr: String = ""
    dynamic var desc: String = ""
    dynamic var longDesc: String = ""
    
    dynamic var isPlaying: Bool = false
    
    override class func primaryKey() -> String? {
        return "name"
    }

    enum CodingKeys: String, CodingKey {
        case name, streamStr, imageStr, desc, longDesc
    }

    public required convenience init(from decoder: Decoder) throws {
        self.init()
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.name = try container.decode(String.self, forKey: .name)
        self.streamStr = try container.decode(String.self, forKey: .streamStr)
        self.imageStr = try container.decode(String.self, forKey: .imageStr)
        self.desc = try container.decode(String.self, forKey: .desc)
        self.longDesc = try container.decode(String.self, forKey: .longDesc)
    }
    
}
