//
//  FAQViewController.swift
//  direct-assemblee
//
//  Created by COUDSI Julien on 16/04/2018.
//  Copyright © 2018 Direct Assemblée. All rights reserved.
//
//  Refer to the LICENSE file of the official project for license.

import UIKit
import WebKit

class FAQViewController: BaseViewController, WKNavigationDelegate {

    private var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.topItem?.title = R.string.localizable.faq()
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.configureWebView()
        self.view.addLoadingView()
        self.loadFaq()
    }
    
    private func configureWebView() {
        let webConfiguration = WKWebViewConfiguration()
        self.webView = WKWebView(frame: self.view.bounds, configuration: webConfiguration)
        self.webView.navigationDelegate = self
        self.view = self.webView
    }
    
    private func loadFaq() {
        
        guard let url = URL(string: UrlBuilder.website().buildUrl(path: Constants.Web.faqPath)) else {
            return
        }
        
        self.webView.load(URLRequest(url: url))
    }
    
    //MARK: - WKNavigationDelegate
    
    func webView(_ webView: WKWebView, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        let cred = URLCredential(trust: challenge.protectionSpace.serverTrust!)
        completionHandler(.useCredential, cred)
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        self.view.removeLoadingView()
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        self.view.removeLoadingView()
        self.view.addPlaceholderView(error: DAError(error: error, message: R.string.localizable.error_faq())) { [weak self] in
            self?.view.removePlaceholderView()
            self?.view.addLoadingView()
            self?.loadFaq()
        }
    }
    
}
