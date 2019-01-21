//
//  ImageCacheService.swift
//  PaperBoy
//
//  Created by Winston Maragh on 11/8/18.
//  Copyright © 2018 Winston Maragh. All rights reserved.
//

import UIKit

final class ImageCacheService {
    
    private init() {}
    static let shared = ImageCacheService()
    
    private var imageCache = NSCache<NSString, UIImage>()
    
    func getImageFromCache(string: String) -> UIImage? {
        return imageCache.object(forKey: string as NSString)
    }
    
    func saveImageToCache(with urlStr: String, image: UIImage) {
        self.imageCache.setObject(image, forKey: urlStr as NSString)
    }
    
}
