//
//  DeputyDeclarationViewerViewModel.swift
//  direct-assemblee
//
//  Created by COUDSI Julien on 06/07/2017.
//  Copyright © 2018 Direct Assemblée. All rights reserved.
//
//  Refer to the LICENSE file of the official project for license.

import Foundation
import RxSwift
import Alamofire

class DeputyDeclarationViewerViewModel: BaseViewModel {
    
    private var api:Api
    private var declaration: Declaration

    var titleText:Variable<String>
    var dateText:Variable<String>
    var downloadedFileUrl = PublishSubject<URL>()
    var isLoadingViewHidden = Variable<Bool>(false)
    var isShareButtonEnabled = Variable<Bool>(false)
    var isWebviewHidden = Variable<Bool>(true)
    var isErrorViewHidden = Variable<Bool>(true)
    var errorText = Variable<String>("")
    var didTapOnShare = PublishSubject<Void>()
    
    init(api:Api, declaration:Declaration) {
        
        self.api = api
        self.declaration = declaration

        self.titleText = Variable<String>(declaration.title)
        self.dateText = Variable<String>("\(R.string.localizable.declarations_of_interest_delivered_on()) \(declaration.date.toString(withFormat: "dd/MM/yyyy"))")
        
        super.init()
        
        self.configure()
    }
    
    func reloadData() {
        self.configure()
    }
    
    // MARK: - Configure
    
    private func configure() {
        
        self.configureforLoading()

        self.api.downloadFile(url: self.declaration.url).subscribe(onNext: { [weak self] fileUrl in
            self?.configure(forDeclarationFileUrl: fileUrl)
        }, onError: { [weak self] error in
            self?.configure(forError: error)
        }).disposed(by: self.disposeBag)
        
        self.didTapOnShare.subscribe(onNext: { [weak self] _ in
            self?.sendTagEventForShare()
        }).disposed(by: self.disposeBag)
    }
    
    private func configureforLoading() {
        
        self.isLoadingViewHidden.value = false
        self.isShareButtonEnabled.value = false
        self.isWebviewHidden.value = true
        self.isErrorViewHidden.value = true
    }
    
    private func configure(forDeclarationFileUrl fileUrl:URL) {
        self.isLoadingViewHidden.value = true
        self.downloadedFileUrl.onNext(fileUrl)
        self.isWebviewHidden.value = false
        self.isShareButtonEnabled.value = true
        self.isErrorViewHidden.value = true
    }
    
    private func configure(forError error:Error) {
        
        self.isLoadingViewHidden.value = true
        self.downloadedFileUrl.onError(error)
        self.isWebviewHidden.value = true
        self.isErrorViewHidden.value = false
        self.errorText.value = String(describing: error)
    }
    
    private func sendTagEventForShare() {
        TaggageManager.sendEvent(eventName: "share_deputy_declaration", forDeputy: self.declaration.deputy, parameters: ["declaration_url": declaration.url as NSObject])
    }
    
}
