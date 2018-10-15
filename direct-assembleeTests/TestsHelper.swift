//
//  TestsHelper.swift
//  direct-assemblee
//
//  Created by Julien Coudsi on 03/05/2017.
//  Copyright © 2018 Direct Assemblée. All rights reserved.
//
//  Refer to the LICENSE file of the official project for license.

import Foundation
import RealmSwift
@testable import direct_assemblee

class TestHelper {
    
    var timelineApi = TestsApi(testMode: TimelineTestMode.timelineOk)
    var timelineThemesApi = TestsApi(testMode: TimelineTestMode.timelineThemes)
    var oneDeputyListApi = TestsApi(testMode: DeputiesListTestMode.oneDeputyFoundByGps)
    var twoDeputiesListApi = TestsApi(testMode: DeputiesListTestMode.twoDeputiesFoundByGps)
    var allDeputiesListApi = TestsApi(testMode: DeputiesListTestMode.allDeputies)
    var deputyDetailsApi = TestsApi(testMode: DeputyDetailsTestMode.deputyOk)
    var ballotDeputiesVotes = TestsApi(testMode: BallotDetailsTestMode.deputiesVotes)
    var places = TestsApi(testMode: PlacesTestMode.places)
    var activityRatesApi = TestsApi(testMode: StatisticsTestMode.activityRatesByGroup)
    var emptyApi = TestsApi(testMode: CommonTestMode.empty)
    var errorApi = TestsApi(testMode: CommonTestMode.error)
    
    var database = try! Realm(configuration: Realm.Configuration(fileURL: nil, inMemoryIdentifier: "test", syncConfiguration: nil, encryptionKey: nil, readOnly: false, schemaVersion: 1, migrationBlock: nil, deleteRealmIfMigrationNeeded: false, shouldCompactOnLaunch: nil, objectTypes: nil))
    
    //#MARK: - Model helpers
    
    func deputySummary() -> DeputySummary {
        
        let deputySummary = DeputySummary(id: 1, firstName: "Jean-Michel", lastName: "Député")
        deputySummary.department = self.department()
        deputySummary.parliamentGroup = "Les absentéistes"
        deputySummary.districtNumber = 2
        deputySummary.seatNumber = 18
        deputySummary.photoUrl = "http://www.tu-veux-ma-photo.org"
        deputySummary.photoData = Data()
        deputySummary.activityRate = 50
        
        return deputySummary
    }
    
    func deputy() -> Deputy {
        return self.deputy(withParliamentAgeInMounths: 8)
    }
    
    func deputy(withParliamentAgeInMounths parliamentAgeInMonths:Int) -> Deputy  {
        
        let deputy = Deputy()
        deputy.id = 1
        deputy.firstName = "Jean-Michel"
        deputy.lastName = "Député"
        deputy.department = self.department()
        deputy.districtNumber.value = 2
        deputy.commission = "Commission de la bienveillance"
        deputy.email = "jean-michel@assemblee.fr"
        deputy.seatNumber.value = 18
        deputy.phone = "0112131415"
        deputy.salary.value = 20000
        deputy.job = "Chiller professionnel"
        deputy.parliamentAgeInMonths.value = parliamentAgeInMonths
        deputy.currentMandateStartDate = Date.from(string: "25/06/2012")
        deputy.age.value = 45
        
        let declaration1 = Declaration()
        declaration1.title = "Déclaration 1"
        declaration1.date = Date.from(string: "10/06/2017")!
        declaration1.url = "http://www.url1.org"
        
        let declaration2 = Declaration()
        declaration2.title = "Déclaration 2"
        declaration2.date = Date.from(string: "11/06/2017")!
        declaration2.url = "http://www.url2.org"
        
        deputy.declarations.append(declaration1)
        deputy.declarations.append(declaration2)
        
        return deputy
    }
    
    func department() -> Department {
        
        let department = Department()
        department.id = 34
        department.code = "34"
        department.name = "Hérault"
        
        return department
    }
    
    func timelineEvent(withId id:Int = 1,
                       withTitle title:String = "Evènement",
                       withType type:TimelineEventType = .ordinaryVote,
                       withUserDeputyVoteResult userDeputyVoteResult:VoteResult = .agree,
                       isAdopted:Bool = true,
                       withTheme theme:TimelineEventTheme = TimelineEventTheme(type: .powersAndConstitution, defaultName: "Pouvoirs publics et Constitution", fullName:nil, shortName: nil)) -> TimelineEvent {
        
        var timelineEvent = TimelineEvent(id: id, type: type, date: Date.from(string: "06/09/2017")!, title: title)
        
        if [.solemnVote, .ordinaryVote, .otherVote, .motionOfCensureVote].contains(type) {
            timelineEvent.voteInfo = TimelineEventVoteInfo(userDeputyVote:self.userDeputyVote(withVoteResult: userDeputyVoteResult), isAdopted: isAdopted)
        }
 
        timelineEvent.theme = theme
        timelineEvent.description = "description"
        
        return timelineEvent
    }

    func timelineEventTheme(withFullName fullName:String? = nil, shortName:String? = nil) -> TimelineEventTheme {
        return TimelineEventTheme(type: .powersAndConstitution, defaultName: "Pouvoirs publics et Constitution", fullName:fullName, shortName:shortName)
    }
    
    func userDeputyVote(withVoteResult voteResult:VoteResult = .agree) -> UserDeputyVote {
        return UserDeputyVote(voteResult: voteResult, userDeputy: UserDeputy(deputyFirstName: "Jean-Michel", deputyLastName: "Député"))
    }
    
    //#MARK: - View model helper
    
    func deputyViewModel() -> DeputySummaryViewModel {
        return DeputySummaryViewModel(deputy: self.deputySummary())
    }
    


    //#MARK: - Database helpers
    
    func saveDeputy() {
        
        try! self.database.write {
            self.database.add(self.deputy())
        }
    }
    
    func cleanDatabase() {
        
        try! self.database.write {
            self.database.deleteAll()
        }
    }
}
