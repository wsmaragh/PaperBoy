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
    var newStation: Bool = false
    var savedVC: NowPlayingVC?
    
    private var refreshControl: UIRefreshControl!
    
    @IBOutlet weak var rightButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBar()
        setupTableView()
        addPullToRefresh()
        setupSearchController()
        loadStationsFromJSON()
        setupAudioSession()
        addAnimations()
        addRightSwipeGestureToSideMenu()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationItem.title = "Streaming Radio Stations"
        configureNowPlayingView()
    }
    
    private func setupAudioSession(){
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
        }
        catch let error {
            print("Failed to setup audio session.  Error: \(error)")
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
            navigationItem.searchController = searchController
        } else {
            navigationItem.titleView = searchController.searchBar
        }
        navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    private func addPullToRefresh() {
        self.refreshControl = UIRefreshControl()
        self.refreshControl.backgroundColor = UIColor.lightGray
        self.refreshControl.tintColor = UIColor.white
        self.refreshControl.addTarget(self, action: #selector(RadioVC.refreshTableView(_:)), for: UIControl.Event.valueChanged)
        self.tableView.addSubview(refreshControl)
    }
    
    @objc private func refreshTableView(_ sender: AnyObject) {
        stations.removeAll()
        loadStationsFromJSON()
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2), execute: {
            self.refreshControl.endRefreshing()
            self.view.setNeedsDisplay()
        })
    }
    
    private func addAnimations(){
        nowPlayingAnimationImageView.animationImages = Animations.addNowPlayingBarAnimationFrames()
        nowPlayingAnimationImageView.animationDuration = 0.8
    }
    
    private func configureNowPlayingView(){
        if currentStation != nil && currentStation!.isPlaying {
            let title = currentStation!.stationName
            stationNowPlayingButton.setTitle(title, for: UIControl.State())
            stationNowPlayingButton.isEnabled = true
            nowPlayingAnimationImageView.startAnimating()
            rightButton.isHidden = false
        } else {
            nowPlayingAnimationImageView.image = UIImage(named: "NowPlayingBars")
            stationNowPlayingButton.isEnabled = false
            rightButton.isHidden = true
            nowPlayingAnimationImageView.stopAnimating()
        }
    }
    
    @IBAction func nowPlayingViewPressed(_ sender: UIButton) {
        showNowPlayingStationVC()
    }
    
    @objc func showNowPlayingStationVC() {
        newStation = false
        if let nowPlayingVC = savedVC {
            navigationController?.pushViewController(nowPlayingVC, animated: true)
        }
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
            guard let nowPlayingVC = segue.destination as? NowPlayingVC else {return}
            savedVC = nowPlayingVC
            nowPlayingVC.currentStation = self.currentStation
            nowPlayingVC.newStation = true
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
        let station = searchController.isActive ? searchedStations[indexPath.row] : stations[indexPath.row]
        cell.configureStationCell(station)
        cell.backgroundColor = (indexPath.row % 2 == 0) ? UIColor.lightText : UIColor.appTableGray
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 105
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedStation = searchController.isActive ? searchedStations[indexPath.row]: stations[indexPath.row]
        if currentStation == selectedStation {
            newStation = false
            navigationController?.pushViewController(savedVC!, animated: true)
        } else {
            currentStation = selectedStation
            newStation = true
            performSegue(withIdentifier: StoryboardIDs.RadioVCToNowPlayingVC.rawValue, sender: self)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}



// MARK: - UISearchControllerDelegate

extension RadioVC: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        searchedStations.removeAll()
        let searchPredicate = NSPredicate(format: "SELF.stationName CONTAINS[c] %@", searchController.searchBar.text!)
        let array = (self.stations as NSArray).filtered(using: searchPredicate)
        searchedStations = array as! [RadioStation]
        self.tableView.reloadData()
    }
    
    
    
}
