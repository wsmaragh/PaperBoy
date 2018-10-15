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


class WebVC: UIViewController, WKUIDelegate, WKNavigationDelegate {

    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    var article: Article!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBar()
        setupWebView()
    }
    
    private func setupNavBar(){
        navigationItem.title = "Browser in Paperboy"
        self.navigationController?.navigationBar.topItem?.title = ""
    }
    
    private func setupWebView(){
        webView.uiDelegate = self
        webView.navigationDelegate = self
        webView.allowsLinkPreview = true
        webView.allowsBackForwardNavigationGestures = true
        guard let urlStr = article.websiteStr else {return}
        guard let url = URL(string: urlStr) else {return}
        let urlRequest = URLRequest(url: url)
        webView.load(urlRequest)
        spinner.startAnimating()
        view.layoutIfNeeded()
    }

    func webViewDidStartLoad(_ webView: UIWebView) {
        print("webViewDid Start Load")
        spinner.startAnimating()
        spinner.isHidden = false
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        print("webViewDid Finish Load")
        spinner.stopAnimating()
        spinner.isHidden = true

    }
    
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        spinner.stopAnimating()
        spinner.isHidden = true
    }
    
}
