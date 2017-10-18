//
//  Server.swift
//  ScTravelDiary
//
//  Created by Kang Seongchan on 2017. 9. 13..
//  Copyright © 2017년 Kang Seongchan. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire
import MapKit
import DKImagePickerController

class Server {
    
    static var locationInfoList:[CLLocationCoordinate2D] = []
    static var serverAdressList:[String] = []
    static var dkAddressList:[DKAsset] = []
    static var cellAddress:String = ""
    
    static func getAddressData(_ urlString:String, completion: @escaping (Bool, [String]) -> Void) {
        
        Alamofire.request(urlString).responseJSON { (response) in
            
            guard let data = response.result.value else {return}
            
            if response.result.isSuccess {
                let myData = JSON(data)
                
                serverAdressList.append(myData["results"][1]["formatted_address"].stringValue)

                
                DispatchQueue.main.async {
                    completion(true, serverAdressList)
                }
            }
        }
        
    }
    
    static func getEachAddress(_ urlString:String, completion: @escaping (Bool, String) -> Void) {
        
        Alamofire.request(urlString).responseJSON { (response) in
            
            guard let data = response.result.value else {return}
            
            if response.result.isSuccess {
                let myData = JSON(data)
                
                cellAddress = myData["results"][1]["formatted_address"].stringValue
                print(cellAddress)
                
                
                DispatchQueue.main.async {

                completion(true, cellAddress)
                
                }
            }
        }

    }
    
    static func cellLocation(myLocation :CLLocation, completionHandler: @escaping (CLPlacemark?) -> Void) {
        
        let geocoder = CLGeocoder()
        
        geocoder.reverseGeocodeLocation(myLocation) { (placemarks, error) in
            if error == nil {
                let firstLocation = placemarks?[0]
                completionHandler(firstLocation)
            }else{
                completionHandler(nil)
            }
        }
    }

    static func getMultipleLocationRoute(assetList:[DKAsset], myMapView:MKMapView){
        
        var myAssetLst = assetList
        var myRoute:MKRoute!

        
        while myAssetLst.count > 1 {
            
            let startLocation = myAssetLst.removeLast().originalAsset?.location?.coordinate
            let endLocation = myAssetLst.last!.originalAsset?.location?.coordinate
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
                myRoute = route
                myMapView.add((route.polyline), level: .aboveRoads)
                let rekt = route.polyline.boundingMapRect
                myMapView.setRegion(MKCoordinateRegionForMapRect(rekt), animated: true)
            }
        }
    }
}


