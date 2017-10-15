//
//  SHTableViewCell.swift
//  ConnectYourDailyTravel
//
//  Created by Kang Seongchan on 2017. 10. 14..
//  Copyright © 2017년 Kang Seongchan. All rights reserved.
//

import UIKit

class SHTableViewCell: UITableViewCell {

    @IBOutlet weak var timeLb: UILabel!
    @IBOutlet weak var routeLb: UILabel!
    @IBOutlet weak var thumnailImage: UIImageView!
    @IBOutlet weak var textLb: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
