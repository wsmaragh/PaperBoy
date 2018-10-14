//
//  Animations.swift
//  PaperBoy
//
//  Created by Winston Maragh on 10/12/18.
//  Copyright © 2018 Winston Maragh. All rights reserved.
//

import UIKit


struct Animations {
    
    static func nowPlayingAnimationImages() -> [UIImage] {
        let imageNames: [String] = ["movingBars1", "movingBars2", "movingBars3", "movingBars4"]
        
        var animationFrames = [UIImage]()
        
        for imageName in imageNames {
            if let image = UIImage(named: imageName){
                animationFrames.append(image)
            }
        }
        let reverseFrames = animationFrames.reversed().dropFirst()
       
        animationFrames.append(contentsOf: reverseFrames)
        return animationFrames
    }
    
    
    static func createAnimationImages(imageNames: [String]) -> [UIImage] {
    
        var animationFrames = [UIImage]()
    
        for imageName in imageNames {
            if let image = UIImage(named: imageName){
                animationFrames.append(image)
            }
        }
        
        let reverseFrames = animationFrames.reversed().dropFirst()
        animationFrames.append(contentsOf: reverseFrames)
        
        return animationFrames
    }
    
    
}
