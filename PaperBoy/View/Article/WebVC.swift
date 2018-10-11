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

    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    var article: Article!

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Browser in Paperboy"
        self.navigationController?.navigationBar.topItem?.title = ""
        setupWebView()
        view.layoutIfNeeded()
        webView.backgroundColor = UIColor.darkGray
    }
    
    func setupWebView(){
        guard let urlStr = article.websiteStr else {return}
        guard let url = URL(string: urlStr) else {return}
        let urlRequest = URLRequest(url: url)
        webView.load(urlRequest)
        spinner.stopAnimating()
    }

}
