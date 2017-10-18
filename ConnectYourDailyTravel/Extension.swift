//
//  Extension.swift
//  ConnectYourDailyTravel
//
//  Created by Kang Seongchan on 2017. 10. 18..
//  Copyright © 2017년 Kang Seongchan. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    class var cnnWhite: UIColor {
        return UIColor(white: 214.0 / 255.0, alpha: 1.0)
    }
    
    class var cnnAzul: UIColor {
        return UIColor(red: 20.0 / 255.0, green: 82.0 / 255.0, blue: 227.0 / 255.0, alpha: 1.0)
    }
}

extension UIButton {
    func setAzure() {
        
        self.backgroundColor = UIColor.cnnAzul
        self.setTitleColor(UIColor.cnnWhite, for: UIControlState.normal)
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.cnnWhite.cgColor
        
    }
}

extension UIFont {
    class func cnnTextStyleFont() -> UIFont? {
        return UIFont(name: ".SFNSDisplay", size: 20.0)
    }
}
