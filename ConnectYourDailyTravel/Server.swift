//
//  Server.swift
//  ScTravelDiary
//
//  Created by Kang Seongchan on 2017. 9. 13..
//  Copyright © 2017년 Kang Seongchan. All rights reserved.
//

import Foundation
import GoogleMaps
import SwiftyJSON
import Alamofire
import DKImagePickerController

class Server {
    
    static var locationInfoList:[CLLocationCoordinate2D] = []
    static var addressList:[String] = []
    static var dkAddressList:[DKAsset] = []
    
    static func getAddressData(_ urlString:String, completion: @escaping (Bool, [DKAsset]) -> Void) {
        
        Alamofire.request(urlString).responseJSON { (response) in
            
            guard let data = response.result.value else {return}
            
            if response.result.isSuccess {
                let myData = JSON(data)
                
                print(myData["results"][0]["formatted_address"].stringValue)
                addressList.append(myData["results"][0]["formatted_address"].stringValue)
                print("~~~~~~~~")
                print(self.addressList)
                print("~~~~~~")
                
                DispatchQueue.main.async {
                    completion(true, dkAddressList)
                }
            }
        }
        
    }
    
}
