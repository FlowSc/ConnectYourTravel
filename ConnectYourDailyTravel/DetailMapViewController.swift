//
//  DetailMapViewController.swift
//  ConnectYourDailyTravel
//
//  Created by Kang Seongchan on 2017. 10. 16..
//  Copyright © 2017년 Kang Seongchan. All rights reserved.
//

import UIKit
import MapKit
import SwiftyJSON
import SnapKit
import Photos

class DetailMapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    let scMapView:MKMapView = {
        
        let mapView = MKMapView()
        
        return mapView
        
    }()
    
    var locationList:[CLLocationCoordinate2D] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(scMapView)
        
        scMapView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalToSuperview()
        }

        scMapView.delegate = self
        
        print(locationList[0])
        
        var point = MKPointAnnotation()
        
        point.coordinate = locationList[0]
        point.title = "hi"
        
        scMapView.addAnnotation(point)
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
