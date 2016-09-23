//
//  Lotto.swift
//  Lotto2
//
//  Created by Jeonghyun Kim on 6/25/15.
//  Copyright © 2015 Jeonghyun Kim. All rights reserved.
//

import Foundation

class Lotto {
    var lottoNumber: Int = 0
    var number1: Int = 0
    var number2: Int = 0
    var number3: Int = 0
    var number4: Int = 0
    var number5: Int = 0
    var number6: Int = 0
    var bonusNumber: Int = 0
    
    init(lottoNumber: Int, number1: Int, number2: Int, number3: Int, number4: Int, number5: Int, number6: Int, bonusNumber: Int) {
        self.lottoNumber = lottoNumber
        self.number1 = number1
        self.number2 = number2
        self.number3 = number3
        self.number4 = number4
        self.number5 = number5
        self.number6 = number6
        self.bonusNumber = bonusNumber
    }
    
    init () {
        self.lottoNumber = 0
        self.number1 = 0
        self.number2 = 0
        self.number3 = 0
        self.number4 = 0
        self.number5 = 0
        self.number6 = 0
        self.bonusNumber = 0
    }
}