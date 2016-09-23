//
//  LottoTableViewCell.swift
//  Lotto2
//
//  Created by Jeonghyun Kim on 6/25/15.
//  Copyright © 2015 Jeonghyun Kim. All rights reserved.
//

import UIKit

class LottoTableViewCell: UITableViewCell {

    var lottoNumber: UILabel!
    var number1: UIImageView!
    var number2: UIImageView!
    var number3: UIImageView!
    var number4: UIImageView!
    var number5: UIImageView!
    var number6: UIImageView!
    var bonusNumber: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
