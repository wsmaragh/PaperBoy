//
//  ImageService.swift
//  PaperBoy
//
//  Created by Winston Maragh on 9/26/18.
//  Copyright © 2018 Winston Maragh. All rights reserved.
//

import UIKit

class ImageCacheService {
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

class ImageService {
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


// MARK: ImageView Extension
extension UIImageView {
    
    func loadImage(imageURLString: String?, defaultImageStr: String = "noImage") {
            
        guard let imageStr = imageURLString else {
            self.image = UIImage(named: defaultImageStr)
            return
        }
        
        if imageStr.contains("http") {
            ImageService.shared.getImage(from: imageStr) { (image) in

                DispatchQueue.main.async {
                    let spinner: UIActivityIndicatorView = {
                        let spinner = UIActivityIndicatorView()
                        spinner.style = .white
                        return spinner
                    }()

                    self.addSubview(spinner)
                    spinner.translatesAutoresizingMaskIntoConstraints = false
                    
                    NSLayoutConstraint.activate([
                        spinner.centerXAnchor.constraint(equalTo: self.centerXAnchor),
                        spinner.centerYAnchor.constraint(equalTo: self.centerYAnchor)
                    ])

                    spinner.startAnimating()
                    spinner.isHidden = false
                    self.image = image
                    spinner.stopAnimating()
                    spinner.isHidden = true
                }
            }
        } else if imageURLString != "" {
            self.image =  UIImage(named: imageStr)
        }

    }
}
