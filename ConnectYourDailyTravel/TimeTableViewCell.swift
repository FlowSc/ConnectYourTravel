//
//  TimeTableViewCell.swift
//  ConnectYourDailyTravel
//
//  Created by Kang Seongchan on 2017. 9. 15..
//  Copyright © 2017년 Kang Seongchan. All rights reserved.
//

import UIKit

class TimeTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBOutlet weak var commentTv: UITextView!
    @IBOutlet weak var titleLb: UILabel!
    @IBOutlet weak var thumnailImageView: UIImageView!
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
