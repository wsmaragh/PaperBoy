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
    
    fileprivate var searchController: UISearchController = UISearchController(searchResultsController: nil)
    
    var stations = [RadioStation]()
    
    var searchedStations = [RadioStation]()
    
    var currentStation: RadioStation?
    
    @objc var lastIndexPath: IndexPath!
    
    
    
    private var firstTime: Bool = true

    var refreshControl: UIRefreshControl!
    
    var savedVC = [String: Any]()
    

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
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
        }
        catch let error {
            print("Failed to set audio session category.  Error: \(error)")
        }

        do {
            try AVAudioSession.sharedInstance().setActive(true)
        }
        catch let error {
            print("audioSession setActive error \(error)")
        }
    }
    
    private func setupTableView(){
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
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
        nowPlayingAnimationImageView.animationImages = NowPlayingAnimation.createFrames()
        nowPlayingAnimationImageView.animationDuration = 0.8
    }
    
    private func checkIfFirstTime(){
        if !firstTime {
            createNowPlayingBarButton()
        }
    }
    
    private func createNowPlayingBarButton() {
        if self.navigationItem.rightBarButtonItem == nil {
            let btn = UIBarButtonItem(title: "", style: UIBarButtonItem.Style.plain, target: self, action:#selector(RadioVC.nowPlayingBarButtonPressed))
            btn.image = UIImage(named: "btn-nowPlaying")
            self.navigationItem.rightBarButtonItem = btn
            stationNowPlayingButton.isEnabled = true
        }
    }
    
    private func checkIfTrackIsPlaying(){
        if currentStation != nil && currentStation!.isPlaying {
            let title = currentStation!.stationName
            stationNowPlayingButton.setTitle(title, for: UIControl.State())
            stationNowPlayingButton.isEnabled = true
            nowPlayingAnimationImageView.startAnimating()
        } else {
            nowPlayingAnimationImageView.image = UIImage(named: "NowPlayingBars")
            stationNowPlayingButton.isEnabled = false
            nowPlayingAnimationImageView.stopAnimating()
        }
    }
    

    @objc func nowPlayingBarButtonPressed() {
        tableView(self.tableView, didSelectRowAt: lastIndexPath)
    }
    
    @IBAction func nowPlayingPressed(_ sender: UIButton) {
        nowPlayingBarButtonPressed()
    }
    
    @objc func refresh(_ sender: AnyObject) {
        stations.removeAll()
        loadStationsFromJSON()
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2), execute: {
            self.refreshControl.endRefreshing()
            self.view.setNeedsDisplay()
        })
    }
    
    
    func loadStationsFromJSON() {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true

        RadioDataService.getStationData({ (data) in
            var json: JSON!
        
            do {
                json = try JSON(data: data!)
            } catch {
                print("Error converting data to JSON")
            }
            
            if let stationJSONArray = json["stations"].array {
                for stationJSON in stationJSONArray {
                    let station = RadioStation.parseStation(stationJSON)
                    self.stations.append(station)
                }
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    self.view.setNeedsDisplay()
                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                }
            }
        })
        
    }
    
    func addRightSwipeGestureToSideMenu() {
        let swipeGesture = UISwipeGestureRecognizer.init(target: self, action: #selector(slideToMenu))
        swipeGesture.direction = .right
        view.addGestureRecognizer(swipeGesture)
    }
    
    @objc func slideToMenu(){        
        NotificationCenter.default.post(name: NSNotification.Name(NotificationNames.toggleSideMenu.rawValue), object: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == StoryboardIDs.RadioVCToNowPlayingVC.rawValue {
            guard let nowPlayingVC = segue.destination as? NowPlayingVC,
                let indexPath = tableView.indexPathForSelectedRow else {
                    return
            }

            let selectedStation = searchController.isActive ? searchedStations[indexPath.row]: stations[indexPath.row]
            nowPlayingVC.currentStation = selectedStation
            nowPlayingVC.newStation = (selectedStation == currentStation) ? false : true
        }
    }
    
}



// MARK: - TableView

extension RadioVC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = searchController.isActive ? searchedStations.count : stations.count
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard !stations.isEmpty else { return UITableViewCell() }
        let cell = tableView.dequeueReusableCell(withIdentifier: StationCell.id, for: indexPath) as! StationCell
        var station: RadioStation!
        station = searchController.isActive ? searchedStations[indexPath.row] : stations[indexPath.row]
        cell.configureStationCell(station)
        cell.backgroundColor = (indexPath.row % 2 == 0) ?  UIColor.lightText : UIColor.appTableGray
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 105
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard !stations.isEmpty else {return}
        firstTime = false
        
        let title = stations[indexPath.row].stationName
        stationNowPlayingButton.setTitle(title, for: UIControl.State())
        stationNowPlayingButton.isEnabled = true
        nowPlayingAnimationImageView.startAnimating()
        let selectedStation = searchController.isActive ? searchedStations[indexPath.row]: stations[indexPath.row]
        currentStation = selectedStation
        performSegue(withIdentifier: StoryboardIDs.RadioVCToNowPlayingVC.rawValue, sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}



// MARK: - UISearchControllerDelegate

extension RadioVC: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        searchedStations.removeAll(keepingCapacity: false)
        let searchPredicate = NSPredicate(format: "SELF.stationName CONTAINS[c] %@", searchController.searchBar.text!)
        let array = (self.stations as NSArray).filtered(using: searchPredicate)
        searchedStations = array as! [RadioStation]
        self.tableView.reloadData()
    }
    
}
