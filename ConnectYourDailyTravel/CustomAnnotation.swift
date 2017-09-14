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
    
    var customcoordinate: CLLocationCoordinate2D
    var customtitle: String?
    var customsubtitle: String?
    var image: UIImage?
    var colour: UIColor?
    
    override init() {
        self.customcoordinate = CLLocationCoordinate2D()
        self.customtitle = nil
        self.customsubtitle = nil
        self.image = nil
        self.colour = UIColor.white
    }
}

class ImageAnnotationView: MKAnnotationView {
    private var imageView: UIImageView!
    
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        
        self.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        self.imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        self.addSubview(self.imageView)
        
        self.imageView.layer.cornerRadius = 5.0
        self.imageView.layer.masksToBounds = true
    }
    
    override var image: UIImage? {
        get {
            return self.imageView.image
        }
        
        set {
            self.imageView.image = newValue
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
