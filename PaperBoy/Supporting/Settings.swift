//
//  RadioSettings.swift
//  PaperBoy
//
//  Created by Winston Maragh on 10/6/18.
//  Copyright © 2018 Winston Maragh. All rights reserved.
//

import Foundation


struct Settings {
    
    enum CoverApi : String {
        case iTunes = "iTunes"
        case lastFm = "LastFm"
    }
    
    static let coverApi = CoverApi.lastFm
    
    
    enum StationType: String {
        case localStations
        case onlineStations = "http://yoururl.com/json/stations.json"
    }
    
    static let stationType = StationType.localStations
}


