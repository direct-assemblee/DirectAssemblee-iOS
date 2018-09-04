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

class DeputyDeclarationViewerViewController: BaseViewController, BindableType, UIGestureRecognizerDelegate {
    
    @IBOutlet weak var webview: UIWebView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var shareBarButtonItem: UIBarButtonItem!
    @IBOutlet weak var refreshBarButtonItem: UIBarButtonItem!
    @IBOutlet weak var errorView: UIView!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var loadingViewContainer: UIView!

    @IBOutlet weak var toolbar: UIToolbar!
    
    private var downloadedFileUrl:URL?
    
    typealias ViewModelType = DeputyDeclarationViewerViewModel
    var viewModel:DeputyDeclarationViewerViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupColors()
        self.bindViewModel()
        
        self.webview.scalesPageToFit = true
        self.webview.scrollView.minimumZoomScale = 1.0
        self.webview.scrollView.maximumZoomScale = 5.0
        self.webview.stringByEvaluatingJavaScript(from: "document.querySelector('meta[name=viewport]').setAttribute('content', 'user-scalable = 1;', false); ")
        
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true;
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self;
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
        
        self.viewModel.titleText.asObservable().bind(to: self.titleLabel.rx.text).disposed(by: self.disposeBag)
       self.viewModel.dateText.asObservable().bind(to: self.dateLabel.rx.text).disposed(by: self.disposeBag)
        self.viewModel.isShareButtonEnabled.asObservable().bind(to: self.shareBarButtonItem.rx.isEnabled).disposed(by: self.disposeBag)
        self.viewModel.isWebviewHidden.asObservable().bind(to: self.webview.rx.isHidden).disposed(by: self.disposeBag)
        self.viewModel.isErrorViewHidden.asObservable().bind(to: self.errorView.rx.isHidden).disposed(by: self.disposeBag)
        self.viewModel.errorText.asObservable().bind(to: self.errorLabel.rx.text).disposed(by: self.disposeBag)
        
        self.bindDownloadedFileUrl()
        self.bindLoadingView()
        
    }
    
    private func bindDownloadedFileUrl() {
        
        self.viewModel.downloadedFileUrl
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] url in
                self?.webview.loadRequest(URLRequest(url: url))
                self?.downloadedFileUrl = url
            }).disposed(by: self.disposeBag)
    }
    
    private func bindLoadingView() {
        
        self.viewModel.isLoadingViewHidden.asObservable().bind(to: self.loadingViewContainer.rx.isHidden).disposed(by: self.disposeBag)
        
        self.viewModel.isLoadingViewHidden.asObservable().subscribe(onNext: { [weak self] isHidden in
            
            if isHidden {
                self?.loadingViewContainer.removeLoadingView()
            } else {
                self?.loadingViewContainer.addLoadingView()
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
}
