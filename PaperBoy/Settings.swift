

import Foundation


enum CoverApi : String {
    case iTunes = "iTunes"
    case lastFm = "LastFm"
    case spotify = "Spotify"
}

// Display Comments
let kDebugLog = true


let coverApi = CoverApi.lastFm
let lastFmApiKey    = "9a267c245324cfa4f887366d497d3dd3"
let lastFmApiSecret = "f1191864d7ae71e580b89238129768b8"


//**************************************
// STATION JSON
//**************************************

// If this is set to "true", it will use the JSON file in the app
// Set it to "false" to use the JSON file at the stationDataURL

let useLocalStations = true
let stationDataURL   = "http://yoururl.com/json/stations.json"


//**************************************
// SEARCH BAR
//**************************************

// Set this to "true" to enable the search bar
let searchable = true
