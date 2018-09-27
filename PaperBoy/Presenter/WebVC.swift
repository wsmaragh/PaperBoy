//
//  WebVC.swift
//  PaperBoy
//
//  Created by Winston Maragh on 9/27/18.
//  Copyright © 2018 Winston Maragh. All rights reserved.
//

import UIKit
import WebKit
import AVFoundation


class WebVC: UIViewController {

    @IBOutlet weak var webView: WKWebView!

    var article: Article!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupWebView()
        navigationItem.title = "Browser in Paperboy"
    }
    
    func setupWebView(){
        guard let urlStr = article.url else {return}
        guard let url = URL(string: urlStr) else {return}
        let urlRequest = URLRequest(url: url)
        webView.load(urlRequest)
    }

}
