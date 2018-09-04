//
//  TaggageManager.swift
//  direct-assemblee
//
//  Created by COUDSI Julien on 29/01/2018.
//  Copyright © 2018 Direct Assemblée. All rights reserved.
//
//  Refer to the LICENSE file of the official project for license.

import Foundation
import FirebaseAnalytics

struct TaggageManager {

    static func sendEvent(eventName:String, forDeputy deputy:Deputy, parameters:[String:NSObject] = [:]) {
        
        var deputyParameters = TaggageManager.getParametersForDeputy(deputy)
        for (key, value) in parameters {
            deputyParameters[key] = value
        }
        
        Analytics.logEvent(eventName, parameters:deputyParameters)
    }
    
    static func sendEvent(eventName:String, forTimelineEvent timelineEvent:TimelineEvent, parameters:[String:NSObject] = [:]) {
        
        var timelineEventParameters = TaggageManager.getParametersForTimelineEvent(timelineEvent)
        for (key, value) in parameters {
            timelineEventParameters[key] = value
        }
        
        Analytics.logEvent(eventName, parameters:timelineEventParameters)
    }
    
    static func sendEvent(eventName:String, parameters:[String:NSObject] = [:]) {
        Analytics.logEvent(eventName, parameters:parameters)
    }
    
    static func sendShareEvent(contentType: String) {
        Analytics.logEvent(AnalyticsEventShare, parameters: [
            AnalyticsParameterContentType: contentType as NSObject,
            ])
    }
    
    static func sendUserProperty(_ name:String, value: String) {
        Analytics.setUserProperty(value, forName: name)
    }
    
    
    //MARK: - Private helpers
    
    private static func getParametersForDeputy(_ deputy: Deputy) -> [String: NSObject] {
        
        return [
            "deputy_id" : deputy.id as NSObject,
            "complete_name" : "\(deputy.firstName) \(deputy.lastName)" as NSObject,
            "district" : "\(deputy.department?.code ?? "")-\(deputy.districtNumber.value ?? 0)" as NSObject,
            "parliament_group" : (deputy.parliamentGroup ?? "") as NSObject
        ]
    }
    
    private static func getParametersForTimelineEvent(_ timelineEvent: TimelineEvent) -> [String: NSObject] {
        
        var parameters = ["timeline_event_id" : timelineEvent.id as NSObject,
                          "timeline_event_title" : timelineEvent.title as NSObject,
                          "timeline_event_theme" : (timelineEvent.theme.name) as NSObject,
                          "timeline_event_date" : timelineEvent.date.toString(withFormat: "dd/MM/yyyy") as NSObject]
        
        if let voteInfo = timelineEvent.voteInfo {
            parameters["timeline_event_is_adopted"] = voteInfo.isAdopted as NSObject
        }
        
        return parameters;
    }
}
