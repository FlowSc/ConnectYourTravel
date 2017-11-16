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
    
    internal var aspectCons:NSLayoutConstraint? {
        didSet {
            if oldValue != nil {
                myImageView.removeConstraint(oldValue!)
            }
            if aspectCons != nil {
                aspectCons?.priority = 999
                myImageView.addConstraint(aspectCons!)
            }
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        aspectCons = nil
    }
    
    func setMyImage(imageString:String){
        
        let url = URL(string: imageString)
        let data = try? Data(contentsOf: url!)
        
        let image = UIImage(data: data!)
        
        guard let myImage = image else {return}
        
        let aspect = myImage.size.width / myImage.size.height
        
      
        
            self.aspectCons = NSLayoutConstraint(item: self.myImageView, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: self.myImageView, attribute: NSLayoutAttribute.height, multiplier: aspect, constant: 0.0)
            
                self.myImageView.image = myImage
 
        
    }
    
    func setMyImageUI(_ withUIImage:UIImage){
        
        let image = withUIImage
        
        let aspect = image.size.width / image.size.height
        
        
        
        self.aspectCons = NSLayoutConstraint(item: self.myImageView, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: self.myImageView, attribute: NSLayoutAttribute.height, multiplier: aspect, constant: 0.0)
        
        self.myImageView.image = image
        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
