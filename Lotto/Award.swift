//
//  Award.swift
//  Lotto2
//
//  Created by Jeonghyun Kim on 6/26/15.
//  Copyright © 2015 Jeonghyun Kim. All rights reserved.
//

import Foundation

class Award {
    var rank: Int = 0
    var awardedPeople: Int = 0
    var totalAward: Int = 0
    var eachAward: Int = 0
    init(rank: Int, awardedPeople: Int, totalAward: Int, eachAward: Int) {
        self.rank = rank
        self.awardedPeople = awardedPeople
        self.totalAward = totalAward
        self.eachAward = eachAward
    }
    init() {
        self.rank = 0
        self.awardedPeople = 0
        self.totalAward = 0
        self.eachAward = 0
    }
}