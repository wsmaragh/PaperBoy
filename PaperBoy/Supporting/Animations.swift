//
//  Animations.swift
//  PaperBoy
//
//  Created by Winston Maragh on 10/12/18.
//  Copyright © 2018 Winston Maragh. All rights reserved.
//

import UIKit


struct Animations {
    
    static func addNowPlayingBarAnimationFrames() -> [UIImage] {
        var animationFrames = [UIImage]()
        for i in 1...4 {
            if let image = UIImage(named: "NowPlayingBars\(i)") {
                animationFrames.append(image)
            }
        }
        for i in stride(from: 3, to: 1, by: -1) {
            if let image = UIImage(named: "NowPlayingBars\(i)") {
                animationFrames.append(image)
            }
        }
        return animationFrames
    }
    
    
}
