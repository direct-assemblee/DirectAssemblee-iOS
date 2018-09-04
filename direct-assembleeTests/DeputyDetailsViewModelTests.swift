//
//  DeputyDetailsViewModelTests.swift
//  direct-assemblee
//
//  Created by COUDSI Julien on 15/06/2017.
//  Copyright © 2018 Direct Assemblée. All rights reserved.
//
//  Refer to the LICENSE file of the official project for license.

import XCTest
import RxSwift
import RxDataSources

@testable import direct_assemblee

class DeputyDetailsViewModelTests: BaseTests {

    //MARK: - Presentation
    
    func testViewModelWithMainInfosAndParliamentAgeLessThanOneYearShouldBeOk() {
        
        let deputy = self.testsHelper.deputy()

        let deputyDetailsViewModel = DeputyDetailsViewModel(deputy:deputy)
        
        let infosSections = deputyDetailsViewModel.infosSections.value
        
        let infoJob = self.info(atLine: 0, in: infosSections[0].items) as? DeputyDetailTitleAndValueViewModel
        let infoAge = self.info(atLine: 1, in: infosSections[0].items) as? DeputyDetailTitleAndValueViewModel
        let infoParliamentAgeInMonths = self.info(atLine: 2, in: infosSections[0].items) as? DeputyDetailTitleAndValueViewModel
        let infoCurrentMandatStartDate = self.info(atLine: 3, in: infosSections[0].items) as? DeputyDetailTitleAndValueViewModel
        let infoSalary = self.info(atLine: 4, in: infosSections[0].items) as? DeputyDetailTitleAndValueViewModel
        
        let declaration1 = self.info(atLine: 0, in: infosSections[1].items) as? DeputyDeclarationViewModel
        let declaration2 = self.info(atLine: 1, in: infosSections[1].items) as? DeputyDeclarationViewModel

        let infoPhone = self.info(atLine: 0, in: infosSections[4].items) as? DeputyDetailTitleAndValueViewModel
        let infoMail = self.info(atLine: 1, in: infosSections[4].items) as? DeputyDetailTitleAndValueViewModel

        XCTAssertEqual(infosSections.count, 5)
        
        XCTAssertEqual(infosSections[0].model, R.string.localizable.deputy_details_about("Jean-Michel"))
        XCTAssertEqual(infosSections[1].model, R.string.localizable.declarations())
        XCTAssertEqual(infosSections[2].model, R.string.localizable.deputy_details_other_current_mandates())
        XCTAssertEqual(infosSections[4].model, R.string.localizable.deputy_details_contact())
        
        XCTAssertEqual(infoJob?.titleText.value, R.string.localizable.deputy_details_job())
        XCTAssertEqual(infoJob?.valueText.value, "Chiller professionnel")
        XCTAssertEqual(infoJob?.isSelectable, false)
        
        XCTAssertEqual(infoAge?.titleText.value, R.string.localizable.deputy_details_age())
        XCTAssertEqual(infoAge?.valueText.value, "45 ans")
        XCTAssertEqual(infoAge?.isSelectable, false)
        
        XCTAssertEqual(infoParliamentAgeInMonths?.titleText.value, R.string.localizable.deputy_details_parliament_age())
        XCTAssertEqual(infoParliamentAgeInMonths?.valueText.value, "8 mois")
        XCTAssertEqual(infoParliamentAgeInMonths?.isSelectable, false)
        
        XCTAssertEqual(infoSalary?.titleText.value, R.string.localizable.deputy_details_salary())
        XCTAssertEqual(infoSalary?.valueText.value, "20000 €")
        XCTAssertEqual(infoSalary?.isSelectable, false)
        
        XCTAssertEqual(infoCurrentMandatStartDate?.titleText.value, R.string.localizable.deputy_details_current_mandate_start_date())
        XCTAssertEqual(infoCurrentMandatStartDate?.valueText.value, "25/06/2012")
        XCTAssertEqual(infoCurrentMandatStartDate?.isSelectable, false)
        
        XCTAssertEqual(infoPhone?.titleText.value, R.string.localizable.deputy_details_phone())
        XCTAssertEqual(infoPhone?.valueText.value, "0112131415")
        XCTAssertEqual(infoPhone?.isSelectable, true)
        
        XCTAssertEqual(infoMail?.titleText.value, R.string.localizable.email_address())
        XCTAssertEqual(infoMail?.valueText.value, "jean-michel@assemblee.fr")
        XCTAssertEqual(infoMail?.isSelectable, true)
        
        XCTAssertEqual(declaration1?.titleText.value, "Déclaration 1")
        XCTAssertEqual(declaration1?.valueText.value, "Déposée le 10/06/2017")
        XCTAssertEqual(infoMail?.isSelectable, true)
        XCTAssertEqual(declaration2?.titleText.value, "Déclaration 2")
        XCTAssertEqual(declaration2?.valueText.value, "Déposée le 11/06/2017")
        XCTAssertEqual(declaration2?.isSelectable, true)
    
    }
    
    func testViewModelWithMandatesAndRolesShouldBeOk() {
        
        let deputy = self.testsHelper.deputy()
        
        deputy.otherCurrentMandates.append("Mandate 1")
        deputy.otherCurrentMandates.append("Mandate 2")
        
        let position = Position()
        position.name = "Président"
        position.instances.append("Langage des signes")
        position.instances.append("Discussion avec les canards")
        
        let role = Role()
        role.positions.append(position)
        role.instanceType = "Groupe des experts du langage"
        
        deputy.roles.append(role)
        
        let deputyDetailsViewModel = DeputyDetailsViewModel(deputy:deputy)
        let infosSections = deputyDetailsViewModel.infosSections.value

        let otherCurrentMandate1 = self.info(atLine: 0, in: infosSections[2].items) as? DeputyDetailSingleValueViewModel
        let otherCurrentMandate2 = self.info(atLine: 1, in: infosSections[2].items) as? DeputyDetailSingleValueViewModel
        
        let roleInstanceType = self.info(atLine: 0, in: infosSections[3].items) as? DeputyDetailSingleValueViewModel
        let positionName = self.info(atLine: 1, in: infosSections[3].items) as? DeputyDetailSingleValueViewModel
        let positionInstance1 = self.info(atLine: 2, in: infosSections[3].items) as? DeputyDetailSingleValueViewModel
        let positionInstance2 = self.info(atLine: 3, in: infosSections[3].items) as? DeputyDetailSingleValueViewModel
        
        XCTAssertEqual(roleInstanceType?.valueText.value, "Groupe des experts du langage")
        XCTAssertEqual(positionName?.valueText.value, "Président")
        XCTAssertEqual(positionInstance1?.valueText.value, "Langage des signes")
        XCTAssertEqual(positionInstance2?.valueText.value, "Discussion avec les canards")
        
        XCTAssertEqual(otherCurrentMandate1?.valueText.value, "Mandate 1")
        XCTAssertEqual(otherCurrentMandate2?.valueText.value, "Mandate 2")
        
    }


    func testViewModelWithParliamentIsExactlyOneMultipleOfYearShouldBeOk() {
        
        let deputy = self.testsHelper.deputy(withParliamentAgeInMounths: 12)
        let deputyDetailsViewModel = DeputyDetailsViewModel(deputy:deputy)
        
        let infosSections = deputyDetailsViewModel.infosSections.value
        let infoParliamentAgeInMonths = self.info(atLine: 2, in: infosSections[0].items) as? DeputyDetailTitleAndValueViewModel
        
        XCTAssertEqual(infoParliamentAgeInMonths?.valueText.value, "1 an")
        
    }
    
    func testViewModelWithParliamentAgeMoreThanOneYearAndLessThanTwoYearsShouldBeOk() {
        
        let deputy = self.testsHelper.deputy(withParliamentAgeInMounths: 20)
        let deputyDetailsViewModel = DeputyDetailsViewModel(deputy:deputy)
        
        let infosSections = deputyDetailsViewModel.infosSections.value
        let infoParliamentAgeInMonths = self.info(atLine: 2, in: infosSections[0].items) as? DeputyDetailTitleAndValueViewModel
        
        XCTAssertEqual(infoParliamentAgeInMonths?.valueText.value, "1 an et 8 mois")
        
    }
    
    func testViewModelWithParliamentAgeMoreThanTwoYearsShouldBeOk() {
        
        let deputy = self.testsHelper.deputy(withParliamentAgeInMounths: 26)
        let deputyDetailsViewModel = DeputyDetailsViewModel(deputy:deputy)
        
        let infosSections = deputyDetailsViewModel.infosSections.value
        let infoParliamentAgeInMonths = self.info(atLine: 2, in: infosSections[0].items) as? DeputyDetailTitleAndValueViewModel
        
        XCTAssertEqual(infoParliamentAgeInMonths?.valueText.value, "2 ans et 2 mois")
        
    }
    
    func testViewModelWithMissingInfosShouldBeOk() {
        
        let deputy = Deputy()
        deputy.id = 1
        deputy.firstName = "Jean-Michel"
        deputy.lastName = "Député"
        deputy.department = self.testsHelper.department()
        deputy.districtNumber.value = 2
        
        let deputyDetailsViewModel = DeputyDetailsViewModel(deputy:deputy)
        
        let infosSections = deputyDetailsViewModel.infosSections.value
        
        let infoJob = self.info(atLine: 0, in: infosSections[0].items) as? DeputyDetailTitleAndValueViewModel
        let infoAge = self.info(atLine: 1, in: infosSections[0].items) as? DeputyDetailTitleAndValueViewModel
        let infoParliamentAgeInMonths = self.info(atLine: 2, in: infosSections[0].items) as? DeputyDetailTitleAndValueViewModel
        let infoCurrentMandatStartDate = self.info(atLine: 3, in: infosSections[0].items) as? DeputyDetailTitleAndValueViewModel
        let infoSalary = self.info(atLine: 4, in: infosSections[0].items) as? DeputyDetailTitleAndValueViewModel
        
        let noDeclaration = self.info(atLine: 0, in: infosSections[1].items) as? DeputyDetailSingleValueViewModel
        let noOtherCurrentMandate = self.info(atLine: 0, in: infosSections[2].items) as? DeputyDetailSingleValueViewModel
        let noRole = self.info(atLine: 0, in: infosSections[3].items) as? DeputyDetailSingleValueViewModel

        let infoPhone = self.info(atLine: 0, in: infosSections[4].items) as? DeputyDetailTitleAndValueViewModel
        let infoMail = self.info(atLine: 1, in: infosSections[4].items) as? DeputyDetailTitleAndValueViewModel
        
        XCTAssertEqual(infosSections.count, 5)
        
        let noInformationLabel = R.string.localizable.deputy_details_unspecified()
        
        XCTAssertEqual(infoJob?.titleText.value, R.string.localizable.deputy_details_job())
        XCTAssertEqual(infoJob?.valueText.value, noInformationLabel)
        XCTAssertEqual(infoJob?.isSelectable, false)
        
        XCTAssertEqual(infoAge?.titleText.value, R.string.localizable.deputy_details_age())
        XCTAssertEqual(infoAge?.valueText.value, noInformationLabel)
        XCTAssertEqual(infoAge?.isSelectable, false)
        
        XCTAssertEqual(infoParliamentAgeInMonths?.titleText.value, R.string.localizable.deputy_details_parliament_age())
        XCTAssertEqual(infoParliamentAgeInMonths?.valueText.value, noInformationLabel)
        XCTAssertEqual(infoParliamentAgeInMonths?.isSelectable, false)
        
        XCTAssertEqual(infoSalary?.titleText.value, R.string.localizable.deputy_details_salary())
        XCTAssertEqual(infoSalary?.valueText.value, noInformationLabel)
        XCTAssertEqual(infoSalary?.isSelectable, false)
        
        XCTAssertEqual(infoCurrentMandatStartDate?.titleText.value, R.string.localizable.deputy_details_current_mandate_start_date())
        XCTAssertEqual(infoCurrentMandatStartDate?.valueText.value, noInformationLabel)
        XCTAssertEqual(infoCurrentMandatStartDate?.isSelectable, false)
        
        XCTAssertEqual(infoPhone?.titleText.value, R.string.localizable.deputy_details_phone())
        XCTAssertEqual(infoPhone?.valueText.value, noInformationLabel)
        XCTAssertEqual(infoPhone?.isSelectable, false)
        
        XCTAssertEqual(infoMail?.titleText.value, R.string.localizable.email_address())
        XCTAssertEqual(infoMail?.valueText.value, noInformationLabel)
        XCTAssertEqual(infoMail?.isSelectable, false)
        
        XCTAssertEqual(noDeclaration?.valueText.value, R.string.localizable.deputy_details_no_declaration())
        XCTAssertEqual(noOtherCurrentMandate?.valueText.value, R.string.localizable.deputy_details_no_other_current_mandate())
        XCTAssertEqual(noRole?.valueText.value, R.string.localizable.deputy_details_no_roles())
    }
    
    //MARK: - User information selection
    
    func testViewModelShouldProvidePhoneNumberUrlAtUserSelection() {
        
        let testExpectation = expectation(description: "expectation")
        
        let deputy = Deputy()
        deputy.phone = "0123456789"
        let deputyDetailsViewModel = DeputyDetailsViewModel(deputy:deputy)
        
        var retrieveredUrl:URL?
        
        deputyDetailsViewModel.selectedPhoneNumberUrl.subscribe(onNext: { phoneNumberUrl in
            retrieveredUrl = phoneNumberUrl
            testExpectation.fulfill()
        }).disposed(by: self.disposeBag)
        
        deputyDetailsViewModel.didSelectInfo.onNext(IndexPath(row: InfosType.phone.rawValue, section: InfosSection.contact.rawValue))
        
        self.waitForExpectations(timeout: 1) { error in
            XCTAssertEqual(retrieveredUrl!.absoluteString, String("tel://\(deputy.phone!)"))
        }
    }
    
    
    func testViewModelShouldProvideEmailAtUserSelection() {
        
        let testExpectation = expectation(description: "expectation")
        
        let deputy = Deputy()
        deputy.email = "jeanmi@giorgio.org"
        let deputyDetailsViewModel = DeputyDetailsViewModel(deputy:deputy)
        
        var retrieveredEmail:String?
        
        deputyDetailsViewModel.selectedEmail.subscribe(onNext: { email in
            retrieveredEmail = email
            testExpectation.fulfill()
        }).disposed(by: self.disposeBag)
        
        deputyDetailsViewModel.didSelectInfo.onNext(IndexPath(row: InfosType.email.rawValue, section: InfosSection.contact.rawValue))
        
        self.waitForExpectations(timeout: 1) { error in
            XCTAssertEqual(retrieveredEmail, deputy.email!)
        }
    }
    
    
    func testViewModelShouldDeputyDeclarationViewerViewModelAtUserSelection() {
        
        let testExpectation = expectation(description: "expectation")
        
        let deputy = self.testsHelper.deputy()
        let deputyDetailsViewModel = DeputyDetailsViewModel(deputy:deputy)
        
        var retrieveredViewModel:DeputyDeclarationViewerViewModel?
        
        deputyDetailsViewModel.selectedDeclarationViewerViewModel.subscribe(onNext: { viewModel in
            retrieveredViewModel = viewModel
            testExpectation.fulfill()
        }).disposed(by: self.disposeBag)
        
        deputyDetailsViewModel.didSelectInfo.onNext(IndexPath(row: 0, section: InfosSection.declarations.rawValue))
        
        self.waitForExpectations(timeout: 1) { error in
            XCTAssertNotNil(retrieveredViewModel)
        }
    }

    // MARK: - Helpers
    
    private func info(atLine line:Int, in infosSections:[DeputyDetail]) -> DeputyDetail? {
        
        guard line < infosSections.count else {
            return nil
        }
        
        return infosSections[line]
        
    }
}
