//
//  DeputyDetailsViewModel.swift
//  direct-assemblee
//
//  Created by COUDSI Julien on 15/06/2017.
//  Copyright © 2018 Direct Assemblée. All rights reserved.
//
//  Refer to the LICENSE file of the official project for license.

import Foundation
import RxSwift
import RxDataSources

enum InfosSection:Int {
    case about
    case declarations
    case mandates
    case roles
    case contact
}

enum InfosType:Int {
    case phone
    case email
}


class DeputyDetailsViewModel: BaseViewModel, FloatingHeaderContentViewModel {
    
    private var deputy:Deputy
    
    var infosSections = Variable<[SectionModel<String, DeputyDetail>]>([])
    var listScrollOffset = PublishSubject<CGFloat>()
    var didUserWantToScrollToTop = PublishSubject<Void>()
    
    var didSelectInfo = PublishSubject<IndexPath>()
    var selectedDeclarationViewerViewModel = PublishSubject<DeputyDeclarationViewerViewModel>()
    var selectedPhoneNumberUrl = PublishSubject<URL>()
    var selectedEmail = PublishSubject<String>()
    
    init(deputy: Deputy) {
        
        self.deputy = deputy
        
        super.init()
        
        self.configure(withDeputy: deputy)
        self.configureUserInfoSelection()
    }
    
    // MARK: - Configure
    
    private func configure(withDeputy deputy:Deputy) {
        
        let sections:[SectionModel<String, DeputyDetail>] = [
            SectionModel(model: R.string.localizable.deputy_details_about(deputy.firstName), items: self.aboutSectionViewModels(withDeputy: deputy)),
            SectionModel(model: R.string.localizable.declarations(), items: self.declarationsViewModels(withDeputy: deputy)),
            SectionModel(model: R.string.localizable.deputy_details_other_current_mandates(), items: self.otherCurrentMandatesViewModels(withDeputy: deputy)),
            SectionModel(model: R.string.localizable.deputy_details_roles(), items: self.rolesViewModels(withDeputy: deputy)),
            SectionModel(model: R.string.localizable.deputy_details_contact(), items: self.contactSectionViewModels(withDeputy: deputy))
        ]
        
        self.infosSections.value = sections
    }
    
    private func configureUserInfoSelection() {
        
        self.didSelectInfo.subscribe(onNext: { [weak self] indexPath in
            
            if indexPath.section == InfosSection.contact.rawValue {
                
                if indexPath.row == InfosType.phone.rawValue {
                    self?.setupSelectedPhone()
                } else if indexPath.row == InfosType.email.rawValue {
                    self?.setupSelectedEmail()
                }
                
            } else if indexPath.section == InfosSection.declarations.rawValue {
                self?.setupSelectedDeclarationViewModel(index: indexPath.row)
            }
            
        }).disposed(by: self.disposeBag)
        
    }
    
    //MARK: - Infos sections data
    
    private func aboutSectionViewModels(withDeputy deputy:Deputy) -> [DeputyDetail] {
        
        var viewModels = [DeputyDetail]()
        
        self.addTitleAndValue(info:deputy.job, title: R.string.localizable.deputy_details_job(), value: deputy.job, inSection: &viewModels)
        self.addTitleAndValue(info:deputy.age.value, title: R.string.localizable.deputy_details_age(), value: "\(deputy.age.value ?? 0) ans", inSection: &viewModels)
        self.addTitleAndValue(info:deputy.parliamentAgeInMonths.value, title: R.string.localizable.deputy_details_parliament_age(), value: "\(self.text(fromParliamentAgeInMounths: deputy.parliamentAgeInMonths.value ?? 0))", inSection: &viewModels)
        self.addTitleAndValue(info:deputy.currentMandateStartDate, title: R.string.localizable.deputy_details_current_mandate_start_date(), value: deputy.currentMandateStartDate?.toString(withFormat: "dd/MM/yyyy"), inSection: &viewModels)
        self.addTitleAndValue(info:deputy.salary.value, title: R.string.localizable.deputy_details_salary(), value: "\(Int(deputy.salary.value ?? 0)) €", inSection: &viewModels)
        
        
        return viewModels
    }
    
    private func declarationsViewModels(withDeputy deputy:Deputy) -> [DeputyDetail] {
        
        var viewModels = [DeputyDetail]()
        
        for declaration in deputy.declarations {
            let declarationsViewModel = DeputyDeclarationViewModel(declaration: declaration)
            viewModels.append(declarationsViewModel)
        }
        
        return viewModels.count > 0 ? viewModels : [DeputyDetailSingleValueViewModel(valueText: R.string.localizable.deputy_details_no_declaration())]
    }
    
    
    private func otherCurrentMandatesViewModels(withDeputy deputy:Deputy) -> [DeputyDetail] {
        
        var viewModels = [DeputyDetail]()
        
        guard deputy.otherCurrentMandates.count > 0 else {
            self.addSingleValue(R.string.localizable.deputy_details_no_other_current_mandate(), inSection: &viewModels)
            return viewModels
        }

        for otherCurrentMandate in deputy.otherCurrentMandates {
            self.addSingleValue(otherCurrentMandate, inSection: &viewModels)
        }
        
        return viewModels
    }
    
    private func rolesViewModels(withDeputy deputy:Deputy) -> [DeputyDetail] {
        
        var viewModels = [DeputyDetail]()
        
        guard deputy.roles.count > 0 else {
            self.addSingleValue(R.string.localizable.deputy_details_no_roles(), inSection: &viewModels)
            return viewModels
        }
        
        for role in deputy.roles {
            self.addSingleValue(role.instanceType, inSection: &viewModels, atLevel: 0)
            
            for position in role.positions {
                self.addSingleValue(position.name, inSection: &viewModels, atLevel: 1)
                
                for instance in position.instances {
                    self.addSingleValue(instance, inSection: &viewModels, atLevel: 2)
                }
            }
            
        }
        
        return viewModels
    }
    
    private func contactSectionViewModels(withDeputy deputy:Deputy) -> [DeputyDetail] {
        
        var viewModels = [DeputyDetail]()
        
        var isPhoneSelectable = false
        var isEmailSelectable = false
        
        if let phone = deputy.phone, !phone.isEmpty {
            isPhoneSelectable = true
        }
        
        if let email = deputy.email, !email.isEmpty {
            isEmailSelectable = true
        }
        
        self.addTitleAndValue(info:deputy.phone, title: R.string.localizable.deputy_details_phone(), value: deputy.phone, isSelectable: isPhoneSelectable, inSection: &viewModels)
        self.addTitleAndValue(info:deputy.email, title: R.string.localizable.email_address(), value: deputy.email, isSelectable: isEmailSelectable, inSection: &viewModels)
        
        return viewModels
        
    }
    
    // MARK: - User selection data
    
    private func setupSelectedPhone() {
        
        guard let phoneNumber = self.deputy.phone, let phoneNumberURL = URL(string:String("tel://\(phoneNumber)")) else {
            return
        }
        
        self.selectedPhoneNumberUrl.onNext(phoneNumberURL)
        self.sendTagForEvent("call_deputy")
    }
    
    private func setupSelectedEmail() {
        
        guard let email = self.deputy.email else {
            return
        }
        
        self.selectedEmail.onNext(email)
        self.sendTagForEvent("send_email_deputy")
    }
    
    private func setupSelectedDeclarationViewModel(index: Int) {
        
        guard self.deputy.declarations.count > index else {
            return
        }
        
        let selectedDeclaration = self.deputy.declarations[index]
        let viewModel = DeputyDeclarationViewerViewModel(api: SingletonManager.sharedApiInstance, declaration: selectedDeclaration)
        self.selectedDeclarationViewerViewModel.onNext(viewModel)
        self.sendTagForEvent("display_deputy_declaration", parameters: ["declaration_url": selectedDeclaration.url as NSObject])
    }
    
    // MARK: - Helpers
    
    private func text(fromParliamentAgeInMounths parliamentAgeInMounths:Int) -> String {
        
        let numberOfYears = parliamentAgeInMounths/12
        let numberOfRemainingMonths = parliamentAgeInMounths - (numberOfYears * 12)
        
        let yearText = numberOfYears == 1 ? "an" : "ans"
        
        if numberOfYears > 0 && numberOfRemainingMonths == 0 {
            return "\(numberOfYears) \(yearText)"
        } else if numberOfYears > 0 && numberOfRemainingMonths > 0 {
            return "\(numberOfYears) \(yearText) et \(numberOfRemainingMonths) mois"
        } else {
            return "\(parliamentAgeInMounths) mois"
        }
    }
    
    private func addTitleAndValue(info:Any?, title:String, value:String?, isSelectable:Bool = false, inSection section:inout [DeputyDetail], atLevel level: Int = 0) {
        
        let deputyInfoViewModel: DeputyDetailTitleAndValueViewModel!
        
        if let _ = info, let value = value, !value.isEmpty {
            deputyInfoViewModel = DeputyDetailTitleAndValueViewModel(titleText: title, valueText: value)
        } else {
            deputyInfoViewModel = DeputyDetailTitleAndValueViewModel(titleText: title, valueText: R.string.localizable.deputy_details_unspecified())
        }
        
        deputyInfoViewModel.cellIdentifier = R.reuseIdentifier.deputyDetailTitleAndValueTableViewCell.identifier
        deputyInfoViewModel.isSelectable = isSelectable
        deputyInfoViewModel.level = level
        
        section.append(deputyInfoViewModel)
    }
    
    private func addSingleValue(_ value: String?, isSelectable:Bool = false, inSection section:inout [DeputyDetail], atLevel level: Int = 0) {
        
        guard let value = value else {
            return
        }
        
        let deputyInfoViewModel = DeputyDetailSingleValueViewModel(valueText: value)
        deputyInfoViewModel.cellIdentifier = R.reuseIdentifier.deputyDetailSingleValueTableViewCell.identifier
        deputyInfoViewModel.isSelectable = isSelectable
        deputyInfoViewModel.level = level
        
        section.append(deputyInfoViewModel)
    }
    
    //MARK: - Tagging
    
    private func sendTagForEvent(_ event:String, parameters:[String: NSObject] = [:]) {
        TaggageManager.sendEvent(eventName: event, forDeputy: self.deputy, parameters: parameters)
    }
    
    
}
