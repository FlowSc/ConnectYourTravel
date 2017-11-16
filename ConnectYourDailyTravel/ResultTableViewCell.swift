//
//  ResultTableViewCell.swift
//  ConnectYourDailyTravel
//
//  Created by Kang Seongchan on 2017. 10. 8..
//  Copyright © 2017년 Kang Seongchan. All rights reserved.
//

import UIKit

class ResultTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        
        timeLb.numberOfLines = 0
        commentLb.numberOfLines = 0
        // Initialization code
    }
    @IBOutlet weak var resultImageView: UIImageView!
    @IBOutlet weak var commentLb: UILabel!
    @IBOutlet weak var timeLb: UILabel!
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
