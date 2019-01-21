//
//  UIImageView+.swift
//  PaperBoy
//
//  Created by Winston Maragh on 11/8/18.
//  Copyright © 2018 Winston Maragh. All rights reserved.
//

import UIKit.UIImageView

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
    
    func loadGif(imageURLString: String) {
        guard let image = UIImage.gifImageWithName(imageURLString) else {return}
        self.image = image
    }
    
}
