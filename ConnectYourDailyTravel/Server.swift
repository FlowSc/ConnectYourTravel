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
}
