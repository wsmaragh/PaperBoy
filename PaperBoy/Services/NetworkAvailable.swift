//
//  NetworkAvailable.swift
//  PaperBoy
//
//  Created by Winston Maragh on 10/24/18.
//  Copyright © 2018 Winston Maragh. All rights reserved.
//

import Foundation
import Reachability


final class NetworkAvailable: NSObject {
    
    static let shared = NetworkAvailable()
    
    var reachability = Reachability()!
    
    override init() {
        super.init()
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(networkStatusChanged(_:)),
            name: .reachabilityChanged,
            object: reachability
        )
        
        reachability.allowsCellularConnection = true
        
        do {
            try reachability.startNotifier()
        } catch {
            print("Unable to start notifier")
        }
    }
    
    @objc func networkStatusChanged(_ notification: Notification) {
        print("Network Status changed") //
    }
    
    static func stopNotifier() -> Void {
        NetworkAvailable.shared.reachability.stopNotifier()
    }

}
