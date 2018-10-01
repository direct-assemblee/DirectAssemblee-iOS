//
//  Group.swift
//  direct-assemblee
//
//  Created by COUDSI Julien on 01/10/2018.
//  Copyright © 2018 Direct Assemblée. All rights reserved.
//

import Foundation

struct Ranking: Codable {
    let activityRatesByGroup: [Activity]
}

struct ParliamentGroup: Codable {
    let id: Int
    let name: String
}

struct Activity: Codable {
    let parliamentGroup: ParliamentGroup
    let activityRate: Int
    
    enum CodingKeys: String, CodingKey {
        case parliamentGroup = "group"
        case activityRate = "activityRate"
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.parliamentGroup = try! container.decode(ParliamentGroup.self, forKey: .parliamentGroup)
        self.activityRate = try! container.decode(Int.self, forKey: .activityRate)
    }
}
