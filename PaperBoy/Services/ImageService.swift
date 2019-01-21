//
//  ImageService.swift
//  PaperBoy
//
//  Created by Winston Maragh on 9/26/18.
//  Copyright © 2018 Winston Maragh. All rights reserved.
//

import UIKit

final class ImageService {
    
    private init() {}
    static let shared = ImageService()
    
    func getImage(from urlStr: String,
                  completionHandler: @escaping (UIImage?) -> Void) {
        
        if let cacheImage = ImageCacheService.shared.getImageFromCache(string: urlStr) {
            completionHandler(cacheImage)
            return
        }
        
        guard let url = URL(string: urlStr) else {
            print("Bad URL used in ImageService")
            return
        }
        
        DispatchQueue.global().async {
            guard let data = try? Data(contentsOf: url) else {return}
            guard let image = UIImage(data: data) else {return}
            ImageCacheService.shared.saveImageToCache(with: urlStr, image: image)
            completionHandler(image)
        }
    }
}


