//
//  TimelineEventThemeTests.swift
//  direct-assembleeTests
//
//  Created by Julien Coudsi on 26/06/2018.
//  Copyright © 2018 Direct Assemblée. All rights reserved.
//
//  Refer to the LICENSE file of the official project for license.

import XCTest

@testable import direct_assemblee

class TimelineEventThemeTests: BaseTests {
    
    func testTimelineEventThemeShouldDisplayDefaultName() {
        let theme = TimelineEventTheme(type: .agriculture, defaultName: "blop", fullName: nil, shortName: nil)
        XCTAssertEqual(theme.name, "blop")
    }
    
    func testTimelineEventThemeShouldDisplayFullName() {
        let theme = TimelineEventTheme(type: .agriculture, defaultName: "blop", fullName: "fullName", shortName: nil)
        XCTAssertEqual(theme.name, "fullName")
    }
    
    func testTimelineEventThemeShouldDisplayShortName() {
        let theme = TimelineEventTheme(type: .agriculture, defaultName: "blop", fullName: "fullName", shortName: "shortName")
        XCTAssertEqual(theme.name, "shortName")
    }
    
}
