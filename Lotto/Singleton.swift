//
//  Singleton.swift
//  Lotto2
//
//  Created by Jeonghyun Kim on 6/25/15.
//  Copyright © 2015 Jeonghyun Kim. All rights reserved.
//

import UIKit

class Singleton {
    class var sharedInstance: Singleton {
        struct staticStruct {
            static let instance: Singleton = Singleton()
        }
        return staticStruct.instance
    }
    
    var latestLottoData: [Lotto] = [Lotto]()
    var lottoData: [[Int]] = [[Int]]()
    var lottoLoadCount: Int = 0
    var awardNumberSelected: Int = -1
    var maxLottoLoad: Int = 10
    var lottoLoadTotalCount: Int = 10
    
    var isIncludeBoolean: Bool = false
    var isNotIncludeBoolean: Bool = false
    var isStraightBoolean: Bool = true
    var isMod2Boolean: Bool = false
    var isSameColorBoolean: Bool = true
    var mod2Is1Count: Int = 0
    var isIncludeNumbers: [Int] = [Int]()
    var isNotIncludeNumbers: [Int] = [Int]()
    
    var editCheckBool: Bool = true
}