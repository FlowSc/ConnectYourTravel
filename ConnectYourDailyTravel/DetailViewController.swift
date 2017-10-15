//
//  detailViewController.swift
//  ConnectYourDailyTravel
//
//  Created by Kang Seongchan on 2017. 10. 15..
//  Copyright © 2017년 Kang Seongchan. All rights reserved.
//

import UIKit
import SnapKit
import MapKit
import SwiftyJSON


class DetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, MKMapViewDelegate, CLLocationManagerDelegate {
    
    let myTableVIew = UITableView()
    var source:JSON!
    var rowCount:Int?
    var clLocationList:[CLLocationCoordinate2D] = []
    var detailData:(String, JSON)?
    var locationManager = CLLocationManager()

    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        rowCount = source["images"].count

    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        }
        
        myTableVIew.delegate = self
        myTableVIew.dataSource = self
        myTableVIew.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        
        view.addSubview(myTableVIew)
        myTableVIew.reloadData()
        
        myTableVIew.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalToSuperview()
        }
        
        guard let detail = detailData else {return}
        
        print(detail)
        
        self.navigationItem.title = detail.0
        
        source = detail.1
        
        
        for myIndex in 0...(source["longitudes"].count - 1) {
            
            print(myIndex)
        
            let myLocation:CLLocationCoordinate2D = CLLocationCoordinate2DMake(CLLocationDegrees(source["longitudes"][myIndex].doubleValue), CLLocationDegrees(source["latitudes"][myIndex].doubleValue))
            
            clLocationList.append(myLocation)
        
            print(myLocation)

        }
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return detailData!.1["addressList"].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        let address = source["addressList"][indexPath.row]
        let image = source["images"][indexPath.row]
        let comment = source["commentList"][indexPath.row]
        let time = source["timeList"][indexPath.row]
        
        
        cell.textLabel?.text = address.stringValue
        cell.imageView?.kf.setImage(with: URL(string: image.stringValue))
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        let mapView = MKMapView()
        let point = MKPointAnnotation()
        var annoations:[MKPointAnnotation] = []
        
        mapView.delegate = self
        mapView.showsCompass = true
        mapView.showsBuildings = true
        mapView.showsUserLocation = true
        mapView.showsPointsOfInterest = true
        
        for annotation in clLocationList {
            
            
            print(annotation)
            
            point.coordinate = annotation
            
            DispatchQueue.main.async {
                mapView.addAnnotation(point)
            }
        }
        
        
    
        
        return mapView
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 300
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
