//
//  DeputeTest.swift
//  direct-assemblee
//
//  Created by Julien Coudsi on 02/05/2017.
//  Copyright © 2018 Direct Assemblée. All rights reserved.
//
//  Refer to the LICENSE file of the official project for license.

import XCTest

@testable import direct_assemblee

class DeputyTest: BaseTests {

    func testDeputiesMainInformationFromDetailsWebServiceShouldBeBuiltCorrectly() {
        
        let asyncExpectation = expectation(description: "deputyDetails")
        var retrievedDeputy:Deputy? = nil
        
        self.testsHelper.deputyDetailsApi.deputy(forDepartmentId: 1, andDistrictNumber: 1).subscribe(onNext: { deputy in
            asyncExpectation.fulfill()
            retrievedDeputy = deputy
        }).disposed(by: self.disposeBag)
        
        self.waitForExpectations(timeout: 4) { error in
            XCTAssert(retrievedDeputy?.id == 120)
            XCTAssert(retrievedDeputy?.firstName == "Xavier")
            XCTAssert(retrievedDeputy?.lastName == "Breton")
            XCTAssert(retrievedDeputy?.parliamentGroup == "Les Républicains")
            XCTAssert(retrievedDeputy?.department?.id == 20)
            XCTAssert(retrievedDeputy?.department?.code == "2a")
            XCTAssert(retrievedDeputy?.department?.name == "Corse-du-Sud")
            XCTAssert(retrievedDeputy?.districtNumber.value == 1)
            XCTAssert(retrievedDeputy?.commission == "Affaires culturelles et éducation")
            XCTAssert(retrievedDeputy?.phone == "0909090909")
            XCTAssert(retrievedDeputy?.email == "contact@xavierbreton.fr")
            XCTAssert(retrievedDeputy?.job == "Cadre territorial")
            XCTAssert(retrievedDeputy?.currentMandateStartDate?.toString(withFormat: "dd/MM/yyyy") == "19/06/2012")
            XCTAssert(retrievedDeputy?.photoUrl == "http://www2.assemblee-nationale.fr/static/tribun/14/photos/330008.jpg")
            XCTAssert(retrievedDeputy?.activityRate.value == 5)
            XCTAssert(retrievedDeputy?.seatNumber.value == 21)
            XCTAssert(retrievedDeputy?.salary.value == 7209.99)
            XCTAssert(retrievedDeputy?.parliamentAgeInMonths.value == 10)
            XCTAssert(retrievedDeputy?.age.value == 45)
            XCTAssert(retrievedDeputy?.otherCurrentMandates[0] == "Membre du conseil départemental (Ain)")
            XCTAssert(retrievedDeputy?.otherCurrentMandates[1] == "Activiste dans une ONG")
            
        }
    }
    
    func testDeputiesDeclarationsFromDetailsWebServiceShouldBeBuiltCorrectly() {
        
        let asyncExpectation = expectation(description: "deputyDetails")
        var retrievedDeputy:Deputy? = nil
        
        self.testsHelper.deputyDetailsApi.deputy(forDepartmentId: 1, andDistrictNumber: 1).subscribe(onNext: { deputy in
            asyncExpectation.fulfill()
            retrievedDeputy = deputy
        }).disposed(by: self.disposeBag)
        
        self.waitForExpectations(timeout: 4) { error in
            
            XCTAssert(retrievedDeputy?.declarations.count == 2)
            XCTAssert(retrievedDeputy?.declarations[0].title == "Déclaration d’intérêts et d’activités")
            XCTAssert(retrievedDeputy?.declarations[0].date.toString(withFormat: "dd/MM/yyyy") == "23/07/2014")
            XCTAssert(retrievedDeputy?.declarations[0].url == "http://www.hatvp.fr/livraison/dossiers/breton-xavier-dia-depute-01.pdf")
            XCTAssert(retrievedDeputy?.declarations[1].title == "Déclaration d’intérêts et d’activités N°2")
            XCTAssert(retrievedDeputy?.declarations[1].date.toString(withFormat: "dd/MM/yyyy") == "24/07/2014")
            XCTAssert(retrievedDeputy?.declarations[1].url == "http://www.hatvp.fr/livraison/dossiers/breton-xavier-dia-depute-02.pdf")
        }
    }
    
    func testDeputiesRolesFromDetailsWebServiceShouldBeBuiltCorrectly() {
        
        let asyncExpectation = expectation(description: "deputyDetails")
        var retrievedDeputy:Deputy? = nil
        
        self.testsHelper.deputyDetailsApi.deputy(forDepartmentId: 1, andDistrictNumber: 1).subscribe(onNext: { deputy in
            asyncExpectation.fulfill()
            retrievedDeputy = deputy
        }).disposed(by: self.disposeBag)
        
        self.waitForExpectations(timeout: 4) { error in

            XCTAssert(retrievedDeputy?.roles.count == 2)
            XCTAssert(retrievedDeputy?.roles[0].instanceType == "Commission permanente")
            XCTAssert(retrievedDeputy?.roles[0].positions.count == 1)
            XCTAssert(retrievedDeputy?.roles[0].positions[0].name == "Vice-Président")
            XCTAssert(retrievedDeputy?.roles[0].positions[0].instances.count == 1)
            XCTAssert(retrievedDeputy?.roles[0].positions[0].instances[0] == "Commission de la défense nationale et des forces armées")
            
            XCTAssert(retrievedDeputy?.roles[1].instanceType == "Groupe d'amitié")
            XCTAssert(retrievedDeputy?.roles[1].positions.count == 1)
            XCTAssert(retrievedDeputy?.roles[1].positions[0].name == "Président")
            XCTAssert(retrievedDeputy?.roles[1].positions[0].instances.count == 2)
            XCTAssert(retrievedDeputy?.roles[1].positions[0].instances[0] == "France-Kenya Ouganda Tanzanie")
            XCTAssert(retrievedDeputy?.roles[1].positions[0].instances[1] == "Hip-hop")
        }
    }
    
    func testDeputyShouldBeBuiltWithSummarySuccessfully() {
    
        let deputySummary = self.testsHelper.deputySummary()
        let deputy = Deputy.fromSummary(deputySummary)

        XCTAssert(deputy.id == 1)
        XCTAssert(deputy.firstName == "Jean-Michel")
        XCTAssert(deputy.lastName == "Député")
        XCTAssert(deputy.department?.id == 34)
        XCTAssert(deputy.department?.code == "34")
        XCTAssert(deputy.department?.name == "Hérault")
        XCTAssert(deputy.districtNumber.value == 2)
        XCTAssert(deputy.parliamentGroup == "Les absentéistes")
        XCTAssert(deputy.activityRate.value == 50)
        XCTAssert(deputy.seatNumber.value == 18)
        XCTAssert(deputy.photoUrl == "http://www.tu-veux-ma-photo.org")
        XCTAssert(deputy.photoData == Data())
    }

}
