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
import Photos

var totalData:[String:Any] = [:]
var myTransportType:MKDirectionsTransportType = MKDirectionsTransportType.automobile
var individualData:[[String:Any]] = [[:]]

class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    var dkAssetsList:[DKAsset] = []
    var myAddressList:[String] = []
    var myRoute:MKRoute!
    var imageList:[UIImage] = []
    var currentIndex:Int = 0
    var tossList:[DKAsset] = []
    var locationInfo:[CLLocationCoordinate2D] = []
    var timeList:[String] = []
    var imageUrlList:[String] = []
    var sortedImageUrlList:[String] = []
    
    @IBOutlet weak var myMapView: MKMapView!
    
    var locationManager = CLLocationManager()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tossList = dkAssetsList
   
        for asset in tossList {
            
            asset.originalAsset?.requestContentEditingInput(with: PHContentEditingInputRequestOptions(), completionHandler: { (input, _) in
                
                guard let input = input else {return}
                
                print("~~~~~")
                print(input.fullSizeImageURL?.absoluteURL)
                print("XXXXX")
                print(input.fullSizeImageURL?.absoluteString)
                print("VVVVV")
                self.imageUrlList.append((input.fullSizeImageURL?.absoluteString)!)
                self.sortedImageUrlList = self.imageUrlList.sorted()
            })
            
        }
        
        
        while currentIndex < locationInfo.count {
            
            let currentAsset = dkAssetsList[currentIndex]
            let myPoint = CustomAnnotation()
            let dateformatter:DateFormatter = DateFormatter()
            let assetLocation = currentAsset.location?.coordinate
            
            if assetLocation != nil {
            dateformatter.dateFormat = "yyyy-MM-dd"
            
            myPoint.coordinate = (currentAsset.originalAsset?.location?.coordinate)!
            myPoint.image = self.imageList[self.currentIndex]

            currentIndex += 1

                DispatchQueue.main.async {
                    self.myMapView.addAnnotation(myPoint)
                }
                
            Server.cellLocation(myLocation: (currentAsset.originalAsset?.location)!, completionHandler: { (placemark) in

                print("Placemark")
                myPoint.customtitle = "\((placemark?.locality) ?? "")"
                myPoint.customsubtitle = "\((placemark?.name) ?? "")"
                print("end")
            })
            }
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
            let endLocation = dkAssetsList.last!.originalAsset?.location?.coordinate
            let startPlacemark = MKPlacemark(coordinate: startLocation!)
            let endPlacemark = MKPlacemark(coordinate: endLocation!)
            let startItem = MKMapItem(placemark: startPlacemark)
            let desItem = MKMapItem(placemark: endPlacemark)
            let directionRequest = MKDirectionsRequest()
            
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

        /*

         저장해야할 것
         이미지데이터(개인적으로만 사용시에는 파이어베이스 대신 이미지 url 만 보내는걸로, 공유 시에는 이미지 업로드 이후 데이터베이스 url list 가 필요) 이미지 url 추출 완료
         촬영시간 ok
         위치정보(위경도) ok 
         주소(역지오코딩 완료된 건들) ok
         코멘트리스트 ok
         별점(추가예정)
         
         전부 다 오름차순으로 정렬된 건으로 함께 올라가야함!
         
         */
        
        totalData.updateValue(sortedImageUrlList, forKey: "imageList") // string
        totalData.updateValue(timeList, forKey: "timeList") // string
//        totalData.updateValue(locationInfo, forKey: "locationList") // longitude
        totalData.updateValue(myAddressList, forKey: "addressList") // string
        totalData.updateValue(commentList, forKey: "commentList") // string
        
        print("SendDatA")
        print(totalData)
        print("~~~~~~")
        
        let mvc = storyboard?.instantiateViewController(withIdentifier: "ResultViewController") as! ResultViewController
        mvc.uiImageList = imageList
        self.navigationController?.pushViewController(mvc, animated: true)
        
    }
}
