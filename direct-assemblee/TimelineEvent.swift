//
//  Activity.swift
//  direct-assemblee
//
//  Created by COUDSI Julien on 06/06/2017.
//  Copyright © 2018 Direct Assemblée. All rights reserved.
//
//  Refer to the LICENSE file of the official project for license.

import Foundation

enum TimelineEventType {
    case solemnVote
    case ordinaryVote
    case otherVote
    case motionOfCensureVote
    case question
    case report
    case lawProposal
    case cosignedLawProposal
    case commission
    case publicSession

    init(string: String) {
        switch string {
        case "vote_solemn":
            self = .solemnVote
        case "vote_ordinary":
            self = .ordinaryVote
        case "vote_other":
            self = .otherVote
        case "vote_motion_of_censure":
            self = .motionOfCensureVote
        case "question":
            self = .question
        case "report":
            self = .report
        case "law_proposal":
            self = .lawProposal
        case "cosigned_law_proposal":
            self = .cosignedLawProposal
        case "commission":
            self = .commission
        case "public_session":
            self = .publicSession
        default:
            self = .solemnVote
            break
        }
    }
}

enum TimelineEventThemeType: Int {
    
    case none = 0
    case foreignAffairs
    case agriculture
    case territoryDevelopment
    case veterans
    case budget
    case localAuthorities
    case culture
    case defense
    case economyAndFinanceTaxation
    case education
    case energy
    case companies
    case environment
    case family
    case publicFunction
    case justice
    case housingAndUrbanism
    case overseas
    case smeTradeAndCrafts
    case policeAndSecurity
    case powersAndConstitution
    case socialIssuesAndHealth
    case researchScienceAndTechnology
    case socialSecurity
    case society
    case sports
    case treatiesAndConventions
    case transportNetwork
    case job
    case europeanUnion
    case generalPolicy
    
    var imageName:String {
        switch (self) {
            
        case .none:
            return "ic_non_categorise"
        case .foreignAffairs:
            return "ic_affaires_etrangeres"
        case .agriculture:
            return "ic_agriculture"
        case .territoryDevelopment:
            return "ic_amenagement_territoire"
        case .veterans:
            return "ic_anciens_combattants"
        case .budget:
            return "ic_budget"
        case .localAuthorities:
            return "ic_collectivites_territoriales"
        case .culture:
            return "ic_culture"
        case .defense:
            return "ic_defense"
        case .economyAndFinanceTaxation:
            return "ic_economie"
        case .education:
            return "ic_education"
        case .energy:
            return "ic_energie"
        case .companies:
            return "ic_entreprises"
        case .environment:
            return "ic_environnement"
        case .family:
            return "ic_famille"
        case .publicFunction:
            return "ic_fonction_publique"
        case .justice:
            return "ic_justice"
        case .housingAndUrbanism:
            return "ic_logement_urbanisme"
        case .overseas:
            return "ic_outre_mer"
        case .smeTradeAndCrafts:
            return "ic_pme_commerce_artisanat"
        case .policeAndSecurity:
            return "ic_police_securite"
        case .powersAndConstitution:
            return "ic_pouvoirs_publics"
        case .socialIssuesAndHealth:
            return "ic_questions_sociales_et_sante"
        case .researchScienceAndTechnology:
            return "ic_recherche_sciences_techniques"
        case .socialSecurity:
            return "ic_securite_sociale"
        case .society:
            return "ic_societe"
        case .sports:
            return "ic_sport"
        case .treatiesAndConventions:
            return "ic_traites_conventions"
        case .transportNetwork:
            return "ic_transport"
        case .job:
            return "ic_travail"
        case .europeanUnion:
            return "ic_europe"
        case .generalPolicy:
            return "ic_politique_generale"
        }
    }
    
}

struct UserDeputy {
    var deputyFirstName:String
    var deputyLastName:String
}

struct UserDeputyVote {
    var voteResult:VoteResult
    var userDeputy:UserDeputy
}

struct TimelineEventVoteInfo {
    
    var numberOfTotalVotes = 0
    var numberOfAgreeVotes = 0
    var numberOfAgainstVotes = 0
    var numberOfBlankVotes = 0
    var numberOfNonVoting = 0
    var numberOfMissingVotes = 0
    var userDeputyVote:UserDeputyVote
    var isAdopted:Bool
    
    init(userDeputyVote: UserDeputyVote, isAdopted:Bool) {
        self.isAdopted = isAdopted
        self.userDeputyVote = userDeputyVote
    }
}


struct TimelineEvent:Equatable {
    
    var id:Int
    var date:Date
    var title:String
    var theme = TimelineEventTheme(type: .none, defaultName: "", fullName:nil, shortName:nil)
    var description = ""
    var fileUrl:String?
    var type:TimelineEventType
    var voteInfo:TimelineEventVoteInfo?
    var extraInfo = [String:Any]()
    
    init(id:Int, type:TimelineEventType, date:Date, title:String) {
        self.id = id
        self.type = type
        self.date = date
        self.title = title
    }
    
    static func ==(event1: TimelineEvent, event2: TimelineEvent) -> Bool {
        return event1.id == event2.id
    }
    
}

struct TimelineEventTheme {
    var type:TimelineEventThemeType = .none
    
    var name: String {
        return self.shortName ?? self.fullName ?? self.defaultName
    }
    
    private var defaultName:String
    private var fullName:String?
    private var shortName:String?
    
    init(type: TimelineEventThemeType, defaultName: String, fullName: String?, shortName: String?) {
        self.type = type
        self.defaultName = defaultName
        self.fullName = fullName
        self.shortName = shortName
    }
}
