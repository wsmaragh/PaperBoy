//
//  RadioVC.swift
//  PaperBoy
//
//  Created by Winston Maragh on 10/6/18.
//  Copyright © 2018 Winston Maragh. All rights reserved.
//

import UIKit
import AVFoundation
import MediaPlayer
import SwiftyJSON


class RadioVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var stationNowPlayingButton: UIButton!
    @IBOutlet weak var nowPlayingAnimationImageView: UIImageView!
    

    @IBAction func sideMenuPressed() {
        slideToMenu()
    }
    
    var firstTime = true
    
    var stations = [RadioStation]()
    var currentStation: RadioStation?
    var currentTrack: Track?
    
    var searchController: UISearchController = UISearchController(searchResultsController: nil)

    var searchedStations = [RadioStation]()
    
    var refreshControl: UIRefreshControl!
    
    @objc var controllersDict = [String:Any]()
    
    @objc var lastIndexPath : IndexPath!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSearchController()
        setupNavBar()
        setupTableView()
        setupPullToRefresh()
        loadStationsFromJSON()
        setupAudioSession()
        createNowPlayingAnimation()
        addRightSwipeGestureToSideMenu()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        checkIfFirstTime()
        checkIfTrackIsPlaying()
    }
    
    private func setupAudioSession(){
        var error: NSError?
        var success: Bool
        
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
            success = true
        } catch let error1 as NSError {
            error = error1
            success = false
        }
        
        if !success {
            if let e = error {
                print("Failed to set audio session category.  Error: \(e)")
            }
        }
        
        do {
            try AVAudioSession.sharedInstance().setActive(true)
        } catch let error2 as NSError {
            print("audioSession setActive error \(error2)")
        }
    }
    
    private func setupTableView(){
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        let cellNib = UINib(nibName: "LoadingStationCell", bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: "LoadingStationCell")
    }
    
    private func setupSearchController(){
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.barStyle = .default
        searchController.searchBar.barTintColor = .white
        searchController.searchBar.tintColor = .white
        searchController.searchBar.placeholder = "Search for radio stations"
        if let textfield = searchController.searchBar.value(forKey: "searchField") as? UITextField {
            textfield.textColor = UIColor.darkGray
            if let backgroundview = textfield.subviews.first {
                backgroundview.backgroundColor = UIColor.white
                backgroundview.layer.cornerRadius = 10;
                backgroundview.clipsToBounds = true;
            }
        }
        if ((searchController.searchBar.responds(to: NSSelectorFromString("searchBarStyle")))){
            searchController.searchBar.searchBarStyle = .minimal
        }
//        searchController.searchBar.delegate = self
        searchController.definesPresentationContext = true
    }
    
    private func setupNavBar(){
        if #available(iOS 11.0, *) {
            navigationItem.title = "Radio Stations"
            navigationItem.searchController = searchController
        } else {
            navigationItem.titleView = searchController.searchBar
        }
        navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    
    private func setupPullToRefresh() {
        self.refreshControl = UIRefreshControl()
        self.refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh", attributes: [NSAttributedString.Key.foregroundColor:UIColor.white])
        self.refreshControl.backgroundColor = UIColor.lightGray
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
    
    private func checkIfFirstTime(){
        if !firstTime {
            createNowPlayingBarButton()
        }
    }
    
    private func checkIfTrackIsPlaying(){
        if currentTrack != nil && currentTrack!.isPlaying {
            let title = currentStation!.stationName + ": " + currentTrack!.title + " - " + currentTrack!.artist + "..."
            stationNowPlayingButton.setTitle(title, for: UIControl.State())
            nowPlayingAnimationImageView.startAnimating()
        } else {
            nowPlayingAnimationImageView.stopAnimating()
            nowPlayingAnimationImageView.image = UIImage(named: "NowPlayingBars")
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
        
        // Wait 2 seconds then refresh
        let popTime = DispatchTime.now() + Double(Int64(2 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC);
        DispatchQueue.main.asyncAfter(deadline: popTime) { () -> Void in
            self.refreshControl.endRefreshing()
            self.view.setNeedsDisplay()
        }
    }
    
    
    func loadStationsFromJSON() {
        DispatchQueue.main.async {
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
        }

        RadioDataService.getStationData({ (data) in
            
            var json: JSON!
            
            do {
                json = try JSON(data: data!)
            } catch {
                print("Error converting data to JSON")
            }
            
            if let stationArray = json["station"].array {
                
                for stationJSON in stationArray {
                    let station = RadioStation.parseStation(stationJSON)
                    self.stations.append(station)
                }
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    self.view.setNeedsDisplay()
                }
                
            } else {
                print("JSON Station Loading Error")
            }
            
            DispatchQueue.main.async {
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
            }
        })
        
    }
    
    func addRightSwipeGestureToSideMenu() {
        let swipeGesture = UISwipeGestureRecognizer.init(target: self, action: #selector(slideToMenu))
        swipeGesture.direction = .right
        view.addGestureRecognizer(swipeGesture)
    }
    
    @objc func slideToMenu(){
        NotificationCenter.default.post(name: NSNotification.Name("toggleSideMenu"), object: nil)
    }
}




// MARK: - TableView DataSource
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
            let cell = tableView.dequeueReusableCell(withIdentifier: "LoadingStationCell", for: indexPath)
            cell.backgroundColor = UIColor.clear
            cell.selectionStyle = UITableViewCell.SelectionStyle.none
            return cell
            
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: StationCell.id, for: indexPath) as! StationCell
            if searchController.isActive {
                let station = searchedStations[indexPath.row]
                cell.configureStationCell(station)
            } else {
                let station = stations[indexPath.row]
                cell.configureStationCell(station)
            }
            cell.backgroundColor = (indexPath.row % 2 == 0) ?  UIColor.lightText : UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 0.9)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}



// MARK: - TableView Delegate
extension RadioVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        firstTime = false
        
        if !stations.isEmpty {
            let title = stations[indexPath.row].stationName + " - Now Playing..."
            stationNowPlayingButton.setTitle(title, for: UIControl.State())
            stationNowPlayingButton.isEnabled = true
        }
        
        var nowPlayingVC = self.storyboard!.instantiateViewController(withIdentifier: NowPlayingVC.id) as! NowPlayingVC
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
                
                controllersDict[NowPlayingVC.id] = nowPlayingVC
                self.navigationController!.pushViewController(nowPlayingVC, animated: true)
            }
        } else {
            // User clicked on a now playing button
            if currentTrack != nil {
                nowPlayingVC = controllersDict[NowPlayingVC.id] as! NowPlayingVC!
                self.navigationController!.pushViewController(nowPlayingVC, animated: true)
            } else {
                // Issue with track, reload station
                nowPlayingVC.currentStation = currentStation
                nowPlayingVC.newStation = true
                
                lastIndexPath = indexPath
                
                controllersDict[NowPlayingVC.id] = nowPlayingVC
                self.navigationController!.pushViewController(nowPlayingVC, animated: true)
            }
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}



// MARK: - NowPlayingVCDelegate
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
