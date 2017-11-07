//
//  ShareTableViewCell.swift
//  ConnectYourDailyTravel
//
//  Created by Kang Seongchan on 2017. 10. 22..
//  Copyright © 2017년 Kang Seongchan. All rights reserved.
//

import UIKit

class ShareTableViewCell: UITableViewCell {
    @IBOutlet weak var thumnailImageView: UIImageView!
    
    @IBOutlet weak var countryLb: UILabel!
    @IBOutlet weak var titleLb: UILabel!
    @IBOutlet weak var hashtagLb: UILabel!
//    @IBOutlet weak var travelLocationLb: UILabel!
//    @IBOutlet weak var travelTimeLb: UILabel!
    @IBOutlet weak var uploadDateLb: UILabel!
    @IBOutlet weak var uploaderLb: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        uploaderLb.numberOfLines = 0
        hashtagLb.numberOfLines = 0
//        travelLocationLb.numberOfLines = 0
//        travelTimeLb.numberOfLines = 0
        uploadDateLb.numberOfLines = 0
        
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
