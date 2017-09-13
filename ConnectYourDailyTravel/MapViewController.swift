//
//  MapViewController.swift
//  ConnectYourDailyTravel
//
//  Created by Kang Seongchan on 2017. 9. 13..
//  Copyright © 2017년 Kang Seongchan. All rights reserved.
//

import UIKit
import MapKit
import SwiftyJSON
import DKImagePickerController

class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    var locationInfoList:[CLLocationCoordinate2D] = []
    var dkAssetList:[DKAsset] = []
    var addressList:[String] = []
    var myRoute:MKRoute!
    
    @IBOutlet weak var myMapView: MKMapView!
    
    var locationManager = CLLocationManager()


    override func viewDidLoad() {
        super.viewDidLoad()
        
        var annotations = [MKPointAnnotation]()
        for annotation in dkAssetList {
            let point = MKPointAnnotation()
            
            point.coordinate = (annotation.originalAsset?.location?.coordinate)!
            point.title = String(describing: annotation.originalAsset?.creationDate)
            
            annotations.append(point)
        }
        myMapView.addAnnotations(annotations)
        
        locationManager.requestAlwaysAuthorization()
        myMapView.showsUserLocation = true
        myMapView.showsCompass = true
        myMapView.delegate = self
        
        getMultipleLocationRoute()
        
        if CLLocationManager.locationServicesEnabled() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        }
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        
        let myLineRenderer = MKPolylineRenderer(polyline: myRoute.polyline)
        myLineRenderer.strokeColor = UIColor.blue
        myLineRenderer.lineWidth = 3
        return myLineRenderer
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getMultipleLocationRoute(){
        
        while locationInfoList.count > 1 {
            
            let startLocation = locationInfoList.removeLast()
            
            print(startLocation)

            let endLocation = locationInfoList.last!
            
            print(endLocation)
            
            let startPlacemark = MKPlacemark(coordinate: startLocation)
            let endPlacemark = MKPlacemark(coordinate: endLocation)
            
            let startItem = MKMapItem(placemark: startPlacemark)
            let desItem = MKMapItem(placemark: endPlacemark)
            
            let directionRequest = MKDirectionsRequest()
            
            directionRequest.source = startItem
            directionRequest.destination = desItem
            directionRequest.transportType = .walking
            
            let directions = MKDirections(request: directionRequest)
            
            directions.calculate { (response, error) in
                
                guard let response = response else {return}
                
                let route = response.routes[0]
                self.myRoute = route
                self.myMapView.add((route.polyline), level: .aboveRoads)
                let rekt = route.polyline.boundingMapRect
                self.myMapView.setRegion(MKCoordinateRegionForMapRect(rekt), animated: true)
            }
            
        }
        
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
