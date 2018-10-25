//
//  OfflineView.swift
//  PaperBoy
//
//  Created by Winston Maragh on 10/24/18.
//  Copyright © 2018 Winston Maragh. All rights reserved.
//

import UIKit

class OfflineView: UIView {
    
    lazy var lightShadeView: UIView = {
        let lightView = UIView()
        lightView.layer.opacity = 0.4
        lightView.backgroundColor = UIColor.lightGray
        return lightView
    }()
    
    lazy var internetImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "nointernet")
        return iv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: UIScreen.main.bounds)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        internetImageView.layer.masksToBounds = true
        internetImageView.layer.cornerRadius = 15
        setupViews()
    }
    
    private func setupViews() {
        addBlurView()
        addImageView()
    }
    
    private func addBlurView() {
        addSubview(lightShadeView)
        lightShadeView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            lightShadeView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            lightShadeView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            lightShadeView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            lightShadeView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor)
            ])
    }
    
    private func addImageView() {
        addSubview(internetImageView)
        internetImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            internetImageView.centerYAnchor.constraint(equalTo: safeAreaLayoutGuide.centerYAnchor),
            internetImageView.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor),
            internetImageView.widthAnchor.constraint(equalTo: safeAreaLayoutGuide.widthAnchor, multiplier: 0.7),
            internetImageView.heightAnchor.constraint(equalTo: internetImageView.widthAnchor, multiplier: 1.2)
            ])
    }
    
}
