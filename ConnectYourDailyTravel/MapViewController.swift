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

var myTransportType:MKDirectionsTransportType = MKDirectionsTransportType.automobile

class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    var dkAssetsList:[DKAsset] = []
    var myAddressList:[String] = []
    var myRoute:MKRoute!
    var imageList:[UIImage] = []
    var currentIndex:Int = 0
    var tossList:[DKAsset] = []
    
    @IBOutlet weak var myMapView: MKMapView!
    
    var locationManager = CLLocationManager()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        tossList = dkAssetsList
        
        var myIndex = 0
        
        while myIndex < dkAssetsList.count {
            
            
            var currentAsset = dkAssetsList[myIndex]
            
            let myPoint = CustomAnnotation()
            let dateformatter:DateFormatter = DateFormatter()
            let assetLocation = currentAsset.location?.coordinate
            
            
            
            if assetLocation != nil {
            dateformatter.dateFormat = "yyyy-MM-dd"
            
            myPoint.coordinate = (currentAsset.originalAsset?.location?.coordinate)!
                
            Server.cellLocation(myLocation: (currentAsset.originalAsset?.location)!, completionHandler: { (placemark) in
                
                print("Placemark")
                myPoint.customtitle = "\((placemark?.locality) ?? "")"
                myPoint.customsubtitle = "\((placemark?.name) ?? "")"
                myPoint.image = self.imageList[myIndex]
                print("end")

                DispatchQueue.main.async {
                    self.myMapView.addAnnotation(myPoint)
                }


            })
            }
            myIndex += 1
            
        }
        
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
        myLineRenderer.lineWidth = 1
        return myLineRenderer
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation.isKind(of: MKUserLocation.self) {  //Handle user location annotation..
            return nil  //Default is to let the system handle it.
        }
        
        if !annotation.isKind(of: CustomAnnotation.self) {  //Handle non-ImageAnnotations..
            var pinAnnotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "DefaultPinView")
            if pinAnnotationView == nil {
                pinAnnotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "DefaultPinView")
            }
            return pinAnnotationView
        }
        
        //Handle ImageAnnotations..
        var view: ImageAnnotationView? = myMapView.dequeueReusableAnnotationView(withIdentifier: "imageAnnotation") as? ImageAnnotationView
        if view == nil {
            view = ImageAnnotationView(annotation: annotation, reuseIdentifier: "imageAnnotation")
            view?.canShowCallout = false
        }
        
        let annotation = annotation as! CustomAnnotation
        view?.image = annotation.image
        view?.annotation = annotation
        
        return view
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getMultipleLocationRoute(){
        
        while dkAssetsList.count > 1 {
            
            let startLocation = dkAssetsList.removeLast().originalAsset?.location?.coordinate
            
            print(startLocation)
            
            let endLocation = dkAssetsList.last!.originalAsset?.location?.coordinate
            
            print(endLocation)
            
            let startPlacemark = MKPlacemark(coordinate: startLocation!)
            let endPlacemark = MKPlacemark(coordinate: endLocation!)
            
            let startItem = MKMapItem(placemark: startPlacemark)
            let desItem = MKMapItem(placemark: endPlacemark)
            
            let directionRequest = MKDirectionsRequest()
            print(myTransportType)
            
            directionRequest.source = startItem
            directionRequest.destination = desItem
            directionRequest.transportType = myTransportType
            
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
    
    @IBAction func moveToTimeLine(_ sender: UIButton) {
        
        let mvc = storyboard?.instantiateViewController(withIdentifier: "TimeLineCollectionViewController") as! TimeLineCollectionViewController
        
        mvc.dkAssetList = tossList
        mvc.myAddressList = myAddressList
        
        self.navigationController?.pushViewController(mvc, animated: true)
        
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
