//
//  RadioVC.swift
//  PaperBoy
//
//  Created by Winston Maragh on 10/6/18.
//  Copyright © 2018 Winston Maragh. All rights reserved.
//

import UIKit
import MediaPlayer
import AVFoundation
import SwiftyJSON


class RadioVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var stationNowPlayingButton: UIButton!
    @IBOutlet weak var nowPlayingAnimationImageView: UIImageView!
    

    @IBAction func sideMenuPressed() {
        NotificationCenter.default.post(name: NSNotification.Name("toggleSideMenu"), object: nil)
    }

    var stations = [RadioStation]()
    var currentStation: RadioStation?
    var currentTrack: Track?
    var refreshControl: UIRefreshControl!
    var firstTime = true
    
    var searchedStations = [RadioStation]()
    var searchController : UISearchController!
    
    @objc var controllersDict = [String:Any]()
    
    @objc var lastIndexPath : IndexPath!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadStationsFromJSON()
        setupTableView()
        setupPullToRefresh()
        createNowPlayingAnimation()
        setupSearchController()
        
        // Set AVFoundation category, required for background audio
        var error: NSError?
        var success: Bool
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
            success = true
        }
        catch let error1 as NSError {
            error = error1
            success = false
        }
        if !success {
            if let e = error {
                print("Failed to set audio session category.  Error: \(e)")
            }
        }
        
        // Set audioSession as active
        do {
            try AVAudioSession.sharedInstance().setActive(true)
        } catch let error2 as NSError {
            print("audioSession setActive error \(error2)")
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {        
        // If a station has been selected, create "Now Playing" button to get back to current station
        if !firstTime {
            createNowPlayingBarButton()
        }
        
        // If a track is playing, display title & artist information and animation
        if currentTrack != nil && currentTrack!.isPlaying {
            let title = currentStation!.stationName + ": " + currentTrack!.title + " - " + currentTrack!.artist + "..."
            stationNowPlayingButton.setTitle(title, for: UIControl.State())
            nowPlayingAnimationImageView.startAnimating()
        } else {
            nowPlayingAnimationImageView.stopAnimating()
            nowPlayingAnimationImageView.image = UIImage(named: "NowPlayingBars")
        }
        
    }
    
    private func setupTableView(){
        tableView.backgroundColor = UIColor.clear
        tableView.backgroundView = nil
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        let cellNib = UINib(nibName: "NothingFoundCell", bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: "NothingFound")
    }
    
    private func setupPullToRefresh() {
        self.refreshControl = UIRefreshControl()
        self.refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh", attributes: [NSAttributedString.Key.foregroundColor:UIColor.white])
        self.refreshControl.backgroundColor = UIColor.black
        self.refreshControl.tintColor = UIColor.white
        self.refreshControl.addTarget(self, action: #selector(RadioVC.refresh(_:)), for: UIControl.Event.valueChanged)
        self.tableView.addSubview(refreshControl)
    }
    
    private func createNowPlayingAnimation() {
        nowPlayingAnimationImageView.animationImages = AnimationFrames.createFrames()
        nowPlayingAnimationImageView.animationDuration = 0.7
    }
    
    private func createNowPlayingBarButton() {
        if self.navigationItem.rightBarButtonItem == nil {
            let btn = UIBarButtonItem(title: "", style: UIBarButtonItem.Style.plain, target: self, action:#selector(RadioVC.nowPlayingBarButtonPressed))
            btn.image = UIImage(named: "btn-nowPlaying")
            self.navigationItem.rightBarButtonItem = btn
        }
    }
    
    func setupSearchController() {
        searchController = UISearchController(searchResultsController: nil)
        
        if searchable {
            searchController.searchResultsUpdater = self
            searchController.dimsBackgroundDuringPresentation = false
            searchController.searchBar.sizeToFit()
            
            // Add UISearchController to the tableView
            tableView.tableHeaderView = searchController?.searchBar
            tableView.tableHeaderView?.backgroundColor = UIColor.clear
            definesPresentationContext = true
            searchController.hidesNavigationBarDuringPresentation = false
            
            // Style the UISearchController
            searchController.searchBar.barTintColor = UIColor.clear
            searchController.searchBar.tintColor = UIColor.white
            
            // Hide the UISearchController
            tableView.setContentOffset(CGPoint(x: 0.0, y: searchController.searchBar.frame.size.height), animated: false)
            
            // Set a black keyborad for UISearchController's TextField
            let searchTextField = searchController.searchBar.value(forKey: "_searchField") as! UITextField
            searchTextField.keyboardAppearance = UIKeyboardAppearance.dark
        }
        
    }
    
    
    @objc func nowPlayingBarButtonPressed() {
        tableView(self.tableView, didSelectRowAt: lastIndexPath)
    }
    
    @IBAction func nowPlayingPressed(_ sender: UIButton) {
        tableView(self.tableView, didSelectRowAt: lastIndexPath)
    }
    
    @objc func refresh(_ sender: AnyObject) {
        stations.removeAll(keepingCapacity: false)
        loadStationsFromJSON()
        
        // Wait 2 seconds then refresh screen
        let popTime = DispatchTime.now() + Double(Int64(2 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC);
        DispatchQueue.main.asyncAfter(deadline: popTime) { () -> Void in
            self.refreshControl.endRefreshing()
            self.view.setNeedsDisplay()
        }
    }
    
    
    func loadStationsFromJSON() {
        // Turn on network indicator in status bar
        DispatchQueue.main.async {
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
        }
        // Get the Radio Stations
        DataManager.getStationDataWithSuccess() { (data) in
            
            do {
                let json = try JSON(data: data!)
                
                if let stationArray = json["station"].array {
                    
                    for stationJSON in stationArray {
                        let station = RadioStation.parseStation(stationJSON)
                        self.stations.append(station)
                    }
                    
                    // stations array populated, update table on main queue
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                        self.view.setNeedsDisplay()
                    }
                    
                } else {
                    print("JSON Station Loading Error")
                }
                
                
            } catch {
                
            }
            
            
            // Turn off network indicator in status bar
            DispatchQueue.main.async {
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
            }
        }
    }
}




// MARK: - TableViewDataSource
extension RadioVC: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.isActive {
            return searchedStations.count
        } else {
            if stations.count == 0 {
                return 1
            } else {
                return stations.count
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if stations.isEmpty {
            let cell = tableView.dequeueReusableCell(withIdentifier: "NothingFound", for: indexPath)
            cell.backgroundColor = UIColor.clear
            cell.selectionStyle = UITableViewCell.SelectionStyle.none
            return cell
            
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "StationCell", for: indexPath) as! StationCell
            
            // alternate background color
            if indexPath.row % 2 == 0 {
                cell.backgroundColor = UIColor.clear
            } else {
                cell.backgroundColor = UIColor.black.withAlphaComponent(0.2)
            }
            
            // Configure the cell...
            let station = stations[indexPath.row]
            cell.configureStationCell(station)
            
            // The UISeachController is active
            if searchController.isActive {
                let station = searchedStations[indexPath.row]
                cell.configureStationCell(station)
            } else {
                let station = stations[indexPath.row]
                cell.configureStationCell(station)
            }
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 88
    }
}



// MARK: - TableViewDelegate
extension RadioVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        firstTime = false
        
        if !stations.isEmpty {
            // Set Now Playing Buttons
            let title = stations[indexPath.row].stationName + " - Now Playing..."
            stationNowPlayingButton.setTitle(title, for: UIControl.State())
            stationNowPlayingButton.isEnabled = true
        }
        
        var nowPlayingVC = self.storyboard!.instantiateViewController(withIdentifier: "NowPlayingVC") as! NowPlayingVC
        nowPlayingVC.delegate = self
        
        if indexPath != lastIndexPath {
            // User clicked on row, load/reset station
            if searchController.isActive {
                currentStation = searchedStations[indexPath.row]
            } else if stations.count > 0 {
                currentStation = stations[indexPath.row]
                
                nowPlayingVC.currentStation = currentStation
                nowPlayingVC.newStation = true
                
                lastIndexPath = indexPath
                
                controllersDict["NowPlayingVC"] = nowPlayingVC
                self.navigationController!.pushViewController(nowPlayingVC, animated: true)
            }
        } else {
            // User clicked on a now playing button
            if currentTrack != nil {
                nowPlayingVC = controllersDict["NowPlayingVC"] as! NowPlayingVC!
                self.navigationController!.pushViewController(nowPlayingVC, animated: true)
            } else {
                // Issue with track, reload station
                nowPlayingVC.currentStation = currentStation
                nowPlayingVC.newStation = true
                
                lastIndexPath = indexPath
                
                controllersDict["NowPlayingVC"] = nowPlayingVC
                self.navigationController!.pushViewController(nowPlayingVC, animated: true)
            }
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}



// MARK: - NowPlayingViewControllerDelegate
extension RadioVC: NowPlayingVCDelegate {
    
    func artworkDidUpdate(_ track: Track) {
        currentTrack?.artworkURL = track.artworkURL
        currentTrack?.artworkImage = track.artworkImage
    }
    
    func songMetaDataDidUpdate(_ track: Track) {
        currentTrack = track
        let title = currentStation!.stationName + ": " + currentTrack!.title + " - " + currentTrack!.artist + "..."
        stationNowPlayingButton.setTitle(title, for: UIControl.State())
    }
    
    func trackPlayingToggled(_ track: Track) {
        currentTrack?.isPlaying = track.isPlaying
    }
    
}



// MARK: - UISearchControllerDelegate
extension RadioVC: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        searchedStations.removeAll(keepingCapacity: false)
        
        // Create a Predicate
        let searchPredicate = NSPredicate(format: "SELF.stationName CONTAINS[c] %@", searchController.searchBar.text!)
        
        // Create an NSArray with a Predicate
        let array = (self.stations as NSArray).filtered(using: searchPredicate)
        
        // Set the searchedStations with search result array
        searchedStations = array as! [RadioStation]
        
        self.tableView.reloadData()
    }
    
}
