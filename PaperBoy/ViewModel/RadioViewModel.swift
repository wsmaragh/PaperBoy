//
//  RadioViewModel.swift
//  PaperBoy
//
//  Created by Winston Maragh on 10/12/18.
//  Copyright © 2018 Winston Maragh. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON



struct RadioViewModel {
    
    var stations = [RadioStation]()
    var searchedStations = [RadioStation]()
    var currentStation: RadioStation?
    
    
//    func loadStationsFromJSON() {
//        UIApplication.shared.isNetworkActivityIndicatorVisible = true
//        
//        RadioDataService.getStationData({ (data) in
//            var json: JSON!
//            
//            do {
//                json = try JSON(data: data!)
//            } catch {
//                print("Error converting data to JSON")
//            }
//            
//            if let stationJSONArray = json["stations"].array {
//                for stationJSON in stationJSONArray {
//                    let station = RadioStation.parseStation(stationJSON)
//                    self.stations.append(station)
//                }
//                
//                DispatchQueue.main.async {
//                    self.tableView.reloadData()
//                    self.view.setNeedsDisplay()
//                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
//                }
//            }
//        })
//        
//    }
//    
}


//extension RadioViewModel {
//
//    public var title: String? {
//        return name
//    }
//
//    public var subtitle: String? {
//        return ratingDescription
//    }
//}
