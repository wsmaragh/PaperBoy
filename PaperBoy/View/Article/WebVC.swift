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

    private func setupNavBar() {
        navigationItem.title = "Browser in Paperboy"
        self.navigationController?.navigationBar.topItem?.title = ""
    }

    private func setupWebView() {
        webView.uiDelegate = self
        webView.navigationDelegate = self

        webView.allowsLinkPreview = true
        webView.allowsBackForwardNavigationGestures = true

        guard let urlStr = article.websiteStr else { return }
        guard let url = URL(string: urlStr) else { return }
        let urlRequest = URLRequest(url: url)
        webView.load(urlRequest)
        view.layoutIfNeeded()
    }

    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        spinner.startAnimating()
        spinner.isHidden = false
    }

    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        spinner.startAnimating()
        spinner.isHidden = false
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        spinner.stopAnimating()
        spinner.isHidden = true
    }

    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        spinner.stopAnimating()
        spinner.isHidden = true
    }

}
