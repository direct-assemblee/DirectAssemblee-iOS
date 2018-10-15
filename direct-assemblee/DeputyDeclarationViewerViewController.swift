//
//  DeputyDeclarationViewerViewController.swift
//  direct-assemblee
//
//  Created by COUDSI Julien on 20/06/2017.
//  Copyright © 2018 Direct Assemblée. All rights reserved.
//
//  Refer to the LICENSE file of the official project for license.

import UIKit
import RxAlamofire
import Alamofire
import RxSwift
import WebKit

class DeputyDeclarationViewerViewController: BaseViewController, BindableType, UIGestureRecognizerDelegate, WKNavigationDelegate {
    
    @IBOutlet weak var webviewContainer: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var shareBarButtonItem: UIBarButtonItem!
    @IBOutlet weak var refreshBarButtonItem: UIBarButtonItem!
    @IBOutlet weak var toolbar: UIToolbar!
    
    private var webview: WKWebView!
    private var downloadedFileUrl:URL?
    
    typealias ViewModelType = DeputyDeclarationViewerViewModel
    var viewModel:DeputyDeclarationViewerViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupColors()
        self.configureWebView()
        self.bindViewModel()

        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true;
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self;
    }
    
    private func configureWebView() {
        let webConfiguration = WKWebViewConfiguration()
        self.webview = WKWebView(frame: self.view.bounds, configuration: webConfiguration)
        self.webview.navigationDelegate = self
        self.webviewContainer.add(constraintedSubview: self.webview)
    }
    
    //MARK: - Style
    
    func setupColors() {
        
        self.view.backgroundColor = UIColor(hex: Constants.Color.blueColorCode)
        self.titleLabel.textColor = UIColor(hex: Constants.Color.whiteColorCode)
        self.dateLabel.textColor = UIColor(hex: Constants.Color.whiteColorCode)
        self.toolbar.barTintColor = UIColor(hex: Constants.Color.blueColorCode)
        self.shareBarButtonItem.tintColor = UIColor(hex: Constants.Color.whiteColorCode)
        self.refreshBarButtonItem.tintColor = UIColor(hex: Constants.Color.whiteColorCode)
        
    }
    
    // MARK: - Binding
    
    func bindViewModel() {
        
        self.viewModel.titleText.asDriver().drive(self.titleLabel.rx.text).disposed(by: self.disposeBag)
        self.viewModel.dateText.asDriver().drive(self.dateLabel.rx.text).disposed(by: self.disposeBag)
        self.viewModel.isShareButtonEnabled.asDriver().drive(self.shareBarButtonItem.rx.isEnabled).disposed(by: self.disposeBag)
        self.viewModel.isWebviewHidden.asDriver().drive(self.webview.rx.isHidden).disposed(by: self.disposeBag)

        self.bindDownloadedFileUrl()
        self.bindErrorView()
        self.bindLoadingView()
        
    }
    
    private func bindDownloadedFileUrl() {
        
        self.viewModel.downloadedFileUrl
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] fileUrl in
                self?.downloadedFileUrl = fileUrl
                self?.webview.loadFileURL(fileUrl, allowingReadAccessTo: fileUrl)
            }).disposed(by: self.disposeBag)
    }
    
    private func bindErrorView() {
        
        self.viewModel.isErrorViewHidden.asDriver().drive(onNext: { [unowned self] isHidden in
            
            if isHidden {
                self.webviewContainer.removePlaceholderView()
            } else {
                
                self.webviewContainer.addPlaceholderView(label: self.viewModel.errorText.value) { [unowned self] in
                    self.webviewContainer.removePlaceholderView()
                    self.viewModel.reloadData()
                }
            }
        }).disposed(by: self.disposeBag)
    }
    
    private func bindLoadingView() {
        
        self.viewModel.isLoadingViewHidden
            .asDriver()
            .drive(onNext: { [weak self] isHidden in
                
                if isHidden {
                    self?.webviewContainer.removeLoadingView()
                } else {
                    self?.webviewContainer.addLoadingView()
                }
                
            }).disposed(by: self.disposeBag)
    }
    
    
    // MARK: - Actions
    
    @IBAction func onActionTouch(_ sender: Any) {
        
        guard let downloadedFileUrl = self.downloadedFileUrl else {
            return
        }
        
        self.viewModel.didTapOnShare.onNext(())
        let activityViewController = UIActivityViewController(activityItems: [downloadedFileUrl], applicationActivities: nil)
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    @IBAction func onRefreshTouch(_ sender: Any) {
        self.viewModel.reloadData()
    }
    
    // MARK: - UIGestureRecognizerDelegate
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    //MARK: - WKNavigationDelegate
    
    func webView(_ webView: WKWebView, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        let cred = URLCredential(trust: challenge.protectionSpace.serverTrust!)
        completionHandler(.useCredential, cred)
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        self.webviewContainer.removeLoadingView()
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        self.webviewContainer.removeLoadingView()
        self.webviewContainer.addPlaceholderView(error: DAError(error: error, message: R.string.localizable.error_download())) { [weak self] in
            self?.webviewContainer.removePlaceholderView()
            self?.viewModel.reloadData()
        }
    }
}
