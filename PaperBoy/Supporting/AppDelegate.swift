//
//  AppDelegate.swift
//  PaperBoy
//
//  Created by Winston Maragh on 9/8/18.
//  Copyright © 2018 Winston Maragh. All rights reserved.
//

import UIKit
import AVFoundation


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // Allow other apps to play sound also
        try? AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.ambient,
                                                         mode: AVAudioSession.Mode.moviePlayback,
                                                         options: [.mixWithOthers])
        
        return true
    }
    
    
}


