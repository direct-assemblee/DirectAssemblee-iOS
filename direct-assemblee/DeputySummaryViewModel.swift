//
//  DeputyViewModel.swift
//  direct-assemblee
//
//  Created by Julien Coudsi on 04/05/2017.
//  Copyright © 2018 Direct Assemblée. All rights reserved.
//
//  Refer to the LICENSE file of the official project for license.

import Foundation
import RxSwift

class DeputySummaryViewModel: BaseViewModel {
    
    var deputy:DeputySummary

    var completeNameText = Variable<String>("")
    var districtText = Variable<String>("")
    var departmentText = Variable<String>("")
    var parliamentGroupText = Variable<String>("")
    var photoData = Variable<Data>(Data())
    var photoUrl = Variable<String>("")
    
    init(deputy: DeputySummary) {
        
        self.deputy = deputy
        super.init()
        self.configure()
    }
    
    // MARK: - Configuration
    
    private func configure() {
        
        self.completeNameText.value = "\(self.deputy.firstName) \(self.deputy.lastName)"
        self.parliamentGroupText.value = self.deputy.parliamentGroup ?? ""
        
        if let districtNumber = self.deputy.districtNumber {
            let districtNumberSuffix = districtNumber == 1 ? R.string.localizable.district_first(districtNumber) : R.string.localizable.district_others(districtNumber)
            self.districtText.value = R.string.localizable.district(districtNumberSuffix)
        }
        
        if let departmentName = self.deputy.department?.name {
            self.departmentText.value = departmentName
        }
        
        if let photoData = deputy.photoData {
            self.photoData.value = photoData
        }
        
        if let photoUrl = deputy.photoUrl {
            self.photoUrl.value = photoUrl
        }
        
        self.photoData.asObservable().subscribe(onNext: { [weak self] data in
            self?.deputy.photoData = data
        }).disposed(by: self.disposeBag)
        
    }
}
