//
//  TimelineEventResponseHandler.swift
//  direct-assemblee
//
//  Created by COUDSI Julien on 06/06/2017.
//  Copyright © 2018 Direct Assemblée. All rights reserved.
//
//  Refer to the LICENSE file of the official project for license.

import Foundation
import SwiftyJSON

struct TimelineEventResponseHandler {
    
    static func timelineEvents(fromJson json:Any) -> [TimelineEvent] {
        
        var timelineEvents = [TimelineEvent]()
        
        guard let timelineEventsJsonArray = json as? [Any] else {
            return timelineEvents
        }
        
        for timelineEventsJson in timelineEventsJsonArray {
            
            if let timelineEvent = TimelineEventResponseHandler.timelineEvent(fromJson: timelineEventsJson) {
                timelineEvents.append(timelineEvent)
            }
        }
        
        return timelineEvents
    }
    
    static func timelineEvent(fromJson json:Any) -> TimelineEvent? {
        
        let timelineEventJsonDictionary = JSON(json)
        
        guard let id = timelineEventJsonDictionary["id"].int,
            let type = timelineEventJsonDictionary["type"].string,
            let date = Date.from(string: timelineEventJsonDictionary["date"].string ?? ""),
            let title = timelineEventJsonDictionary["title"].string else {
                
                return nil
        }
        
        var timelineEvent = TimelineEvent(id: id, type: TimelineEventType(string:type), date: date, title: title)
        timelineEvent.theme = TimelineEventResponseHandler.timelineEventTheme(fromJson: timelineEventJsonDictionary["theme"].dictionaryObject ?? [:])
        timelineEvent.description = timelineEventJsonDictionary["description"].string ?? ""
        timelineEvent.fileUrl = timelineEventJsonDictionary["fileUrl"].string
        timelineEvent.voteInfo = TimelineEventResponseHandler.timelineEventVoteInfo(fromJson: timelineEventJsonDictionary["extraBallotInfo"].dictionaryObject ?? [:])
        timelineEvent.extraInfo = timelineEventJsonDictionary["extraInfos"].dictionaryObject ?? [:]
        return timelineEvent
    }
    
    // MARK: - Helpers
    
    private static func timelineEventVoteInfo(fromJson json:Any) -> TimelineEventVoteInfo? {
        
        let timelineVoteEventJsonDictionary = JSON(json)
        
        guard let isAdopted = timelineVoteEventJsonDictionary["isAdopted"].bool,
            let userDeputyVote = self.userDeputyVote(fromJson:timelineVoteEventJsonDictionary["deputyVote"].dictionaryObject ?? [:])else {
                return nil
        }
        
        var timelineEventVoteInfo = TimelineEventVoteInfo(userDeputyVote:userDeputyVote, isAdopted: isAdopted)
        
        timelineEventVoteInfo.numberOfTotalVotes = timelineVoteEventJsonDictionary["totalVotes"].int ?? 0
        timelineEventVoteInfo.numberOfAgreeVotes = timelineVoteEventJsonDictionary["yesVotes"].int ?? 0
        timelineEventVoteInfo.numberOfAgainstVotes = timelineVoteEventJsonDictionary["noVotes"].int ?? 0
        timelineEventVoteInfo.numberOfBlankVotes = timelineVoteEventJsonDictionary["blankVotes"].int ?? 0
        timelineEventVoteInfo.numberOfNonVoting = timelineVoteEventJsonDictionary["nonVoting"].int ?? 0
        timelineEventVoteInfo.numberOfMissingVotes =  timelineVoteEventJsonDictionary["missing"].int ?? 0
        
        return timelineEventVoteInfo
    }

    private static func timelineEventTheme(fromJson json:Any) -> TimelineEventTheme {
        
        let timelineEventThemeJsonDictionary = JSON(json)
        
        guard let type = TimelineEventThemeType(rawValue: timelineEventThemeJsonDictionary["id"].int ?? 0),
            let name = timelineEventThemeJsonDictionary["name"].string else {
                return TimelineEventTheme(type: .none, defaultName: "", fullName: nil, shortName: nil)
        }
        
        let fullName = timelineEventThemeJsonDictionary["fullName"].string
        let shortName = timelineEventThemeJsonDictionary["shortName"].string
        
        return TimelineEventTheme(type: type, defaultName: name, fullName: fullName, shortName: shortName)
    }
    
    private static func userDeputyVote(fromJson json:Any) -> UserDeputyVote? {
        
        let userDeputyVoteJsonDictionary = JSON(json)
        
        guard let voteResultValue = userDeputyVoteJsonDictionary["voteValue"].string,
            let deputyFirstName = userDeputyVoteJsonDictionary["deputy"]["firstname"].string,
            let deputyLastName = userDeputyVoteJsonDictionary["deputy"]["lastname"].string else {
                return nil
        }
        
        return UserDeputyVote(voteResult: VoteResult(string: voteResultValue), userDeputy: UserDeputy(deputyFirstName: deputyFirstName, deputyLastName: deputyLastName))
    }
    
}
