//
//  ResultViewController.swift
//  ConnectYourDailyTravel
//
//  Created by Kang Seongchan on 2017. 10. 3..
//  Copyright © 2017년 Kang Seongchan. All rights reserved.
//

import UIKit
import TimelineTableViewCell
import Kingfisher
import Firebase
import PromiseKit
import MapKit

class ResultViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var uploadOutlet: UIButton!
    @IBOutlet weak var uploadIndicator: UIActivityIndicatorView!
    
    var timeList:[String] = []
    var addressLst:[String] = []
    var uiImageList:[UIImage] = []
    var locationList:[CLLocationCoordinate2D] = []
    var locationStringList:[String] = []
    
    @IBOutlet weak var myTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        myTableView.rowHeight = UITableViewAutomaticDimension
        
        uploadOutlet.setAzure()
        
        uploadIndicator.isHidden = true
        myTableView.register(UINib.init(nibName: "DetailShowTableViewCell", bundle: nil), forCellReuseIdentifier: "Cell")
        myTableView.register(UINib.init(nibName: "ResultTableViewCell", bundle: nil), forCellReuseIdentifier: "ResultTableViewCell")
        myTableView.delegate = self
        myTableView.dataSource = self
        myTableView.reloadData()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return uiImageList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! DetailShowTableViewCell
        
        let sortedTimeList = timeList.sorted()
        
        cell.timeLb.text = sortedTimeList[indexPath.row]
        cell.commentLb.text = commentList[indexPath.row]
        cell.setMyImageUI(uiImageList[indexPath.row])
        cell.locationLb.text = addressLst[indexPath.row]

//        cell.timeLb.text = sortedTimeList[indexPath.row]
//        cell.resultImageView.image = uiImageList[indexPath.row]
//        cell.commentLb.text = commentList[indexPath.row]
        
        return cell
    }
    
    
    @IBAction func resultButtonTouched(_ sender: UIButton) {

        uploadIndicator.isHidden = false
        uploadIndicator.startAnimating()
        myTableView.isHidden = true
        uploadOutlet.isHidden = true
        
        savedImages(imagrArray: uiImageList)
        
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 300
    }
    
    func savedImages(imagrArray:[UIImage]){
        
        let currentTime = Date()
        let scDateformatter = DateFormatter()
        let myDateformatter = DateFormatter()
        scDateformatter.dateFormat = "YYYYMMddHHmm"
        let timeString = scDateformatter.string(from: currentTime)
//        self.timeString = timeString
        let userUid:String = (loginUser?.uid)!
        var latitudes:[Double] = []
        var longitude:[Double] = []
        myDateformatter.dateFormat = "YYYY.MM.dd"
        let updateDate = myDateformatter.string(from: currentTime)
    
        
        for location in self.locationList {
            
            latitudes.append(Double(location.latitude))
            longitude.append(Double(location.longitude))
        }

        uploadMyImage(userUid: userUid, imageArray: imagrArray) { (urlArray) in
            
//            let uploadChild = Database.database().reference().child("users").child(userUid).child("travelList").child(timeString)
//
//            uploadChild.child("images").setValue(urlArray.sorted())
//            uploadChild.child("timeList").setValue(self.timeList.sorted())
//            uploadChild.child("addressList").setValue(self.addressLst)
//            uploadChild.child("commentList").setValue(commentList)
//            uploadChild.child("latitudes").setValue(latitudes)
//            uploadChild.child("longitudes").setValue(longitude)
//            uploadChild.child("uploadDate").setValue(updateDate)
//            uploadChild.child("country").setValue(countryString)

            
           let travelListDataBase = Database.database().reference().child("travelList").child(userUid).child(timeString)
            
            travelListDataBase.child("images").setValue(urlArray.sorted())
            travelListDataBase.child("timeList").setValue(self.timeList.sorted())
            travelListDataBase.child("addressList").setValue(self.addressLst)
            travelListDataBase.child("commentList").setValue(commentList)
            travelListDataBase.child("latitudes").setValue(latitudes)
            travelListDataBase.child("longitudes").setValue(longitude)
            travelListDataBase.child("uploadDate").setValue(updateDate)
            travelListDataBase.child("country").setValue(countryString)
            travelListDataBase.child("uploader").setValue(loginUserName)
            
            if self.uiImageList.count == urlArray.count {
                
                self.uploadIndicator.stopAnimating()
            
            let mvc = self.storyboard?.instantiateViewController(withIdentifier: "CompleteViewController") as! CompleteViewController
//
                mvc.timeString = timeString
                mvc.userUid = userUid
            
            self.present(mvc, animated: true, completion: nil)
//
            }
        }
    }
    
    func uploadMyImage(userUid:String, imageArray:[UIImage], completionHandler: @escaping ([String]) -> ()){
        var urlArray:[String] = []

        var count = 0
        
        while uiImageList.count > count {
            
            let currentTime = Date()
            let scDateformatter = DateFormatter()
            scDateformatter.dateFormat = "YYYYMMddHHmm"
            let timeString = scDateformatter.string(from: currentTime)
            
            let scStorage = Storage.storage().reference().child(userUid).child("travelList").child(timeString).child("image\(count).jpg")
            
            let uploadData = UIImageJPEGRepresentation(uiImageList[count], 0.8)
            
            scStorage.putData(uploadData!, metadata: nil){ (metaData, error) in
                
                if error != nil {
                    print(error as Any)
                    return
                }
                guard let metaData = metaData else {
                    return
                }
                
                let uploadImage = (metaData.downloadURL()?.absoluteString)!
                
                urlArray.append(uploadImage)
                
                print("~~~~~")
                print(uploadImage)
                print("XXXXX")
                
                completionHandler(urlArray)
                //
                
            }
            count += 1
            
        }
    }
    
}
