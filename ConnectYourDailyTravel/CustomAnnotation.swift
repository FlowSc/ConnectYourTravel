//
//  CustomAnnotation.swift
//  ConnectYourDailyTravel
//
//  Created by Kang Seongchan on 2017. 9. 14..
//  Copyright © 2017년 Kang Seongchan. All rights reserved.
//

import UIKit
import MapKit

class CustomAnnotation: MKPointAnnotation {
    
    var image:UIImage?
    var customTitle:String!
    var customCoordinate: CLLocationCoordinate2D
    
    init(image:UIImage, customTitle:String, customCoordinate:CLLocationCoordinate2D) {
        self.image = image
        image.size.equalTo(CGSize(width: 100, height: 100))
        self.customTitle = customTitle
        self.customCoordinate = customCoordinate
    }


}
