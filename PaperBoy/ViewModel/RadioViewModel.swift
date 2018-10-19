//
//  RadioViewModel.swift
//  PaperBoy
//
//  Created by Winston Maragh on 10/12/18.
//  Copyright © 2018 Winston Maragh. All rights reserved.
//

import Foundation

class RadioViewModel {

    var stations = [RadioStation]()
    var searchedStations = [RadioStation]()
    var currentStation: RadioStation?

    init() {
        RadioDataService.shared.getRadioStationsFromFile(completion: { (onlineStations) in
            self.stations = onlineStations
        })
    }

    deinit {
    }

}
