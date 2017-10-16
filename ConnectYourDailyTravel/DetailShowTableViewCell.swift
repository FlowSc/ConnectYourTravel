//
//  DetailShowTableViewCell.swift
//  ConnectYourDailyTravel
//
//  Created by Kang Seongchan on 2017. 10. 16..
//  Copyright © 2017년 Kang Seongchan. All rights reserved.
//

import UIKit

class DetailShowTableViewCell: UITableViewCell {
    @IBOutlet weak var myImageView: UIImageView!
    @IBOutlet weak var timeLb: UILabel!
    
    @IBOutlet weak var commentLb: UILabel!
    @IBOutlet weak var locationLb: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
