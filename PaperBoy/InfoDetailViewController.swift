//
//  InfoDetailViewController.swift
//  Swift Radio
//
//  Created by Matthew Fecher on 7/9/15.
//  Copyright (c) 2015 MatthewFecher.com. All rights reserved.
//

import UIKit

class InfoDetailViewController: UIViewController {
    
    @IBOutlet weak var stationImageView: UIImageView!
    @IBOutlet weak var stationNameLabel: UILabel!
    @IBOutlet weak var stationDescLabel: UILabel!
    @IBOutlet weak var stationLongDescTextView: UITextView!
    @IBOutlet weak var okayButton: UIButton!
    
    @objc var currentStation: RadioStation!
    @objc var downloadTask: URLSessionDownloadTask?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupStationText()
        setupStationLogo()
    }

    deinit {
        downloadTask?.cancel()
        downloadTask = nil
    }
    
    @objc func setupStationText() {
        stationNameLabel.text = currentStation.stationName
        stationDescLabel.text = currentStation.stationDesc
        
        if currentStation.stationLongDesc == "" {
            loadDefaultText()
        } else {
            stationLongDescTextView.text = currentStation.stationLongDesc
        }
    }
    
    @objc func loadDefaultText() {
        stationLongDescTextView.text = "You are listening to PaperBoy radio!"
    }
    
    @objc func setupStationLogo() {
        let imageURL = currentStation.stationImageURL
        
        if imageURL.range(of: "http") != nil {
            if let url = URL(string: currentStation.stationImageURL) {
                downloadTask = stationImageView.loadImageWithURL(url) { _ in }
            }
        } else if imageURL != "" {
            stationImageView.image = UIImage(named: imageURL)
        } else {
            stationImageView.image = UIImage(named: "stationImage")
        }
        
        stationImageView.applyShadow()
    }

    @IBAction func okayButtonPressed(_ sender: UIButton) {
        _ = navigationController?.popViewController(animated: true)
    }
    
}
