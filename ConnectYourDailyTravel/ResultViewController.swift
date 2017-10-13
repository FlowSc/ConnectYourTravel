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

class ResultViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    
    let imageList = totalData["imageList"] as! [String]
    let timeList = totalData["timeList"] as! [String]
    var uiImageList:[UIImage] = []
    
    @IBOutlet weak var myTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        return imageList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ResultTableViewCell", for: indexPath) as! ResultTableViewCell
        
        let sortedTimeList = timeList.sorted()
        let sortedImageList = imageList.sorted()
        
        cell.timeLb.text = sortedTimeList[indexPath.row]
        cell.resultImageView.image = uiImageList[indexPath.row]
//        cell.commentLb.text = commentList[indexPath.row] ?? ""
        
        return cell
    }
    
    
    @IBAction func resultButtonTouched(_ sender: UIButton) {

        savedImages(imagrArray: uiImageList)
        
        let mvc = self.storyboard?.instantiateViewController(withIdentifier: "CompleteViewController") as! CompleteViewController
        
        self.present(mvc, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    func savedImages(imagrArray:[UIImage]){
        
        let currentTime = Date()
        let scDateformatter = DateFormatter()
        scDateformatter.dateFormat = "YYYYMMddhhmm"
        let timeString = scDateformatter.string(from: currentTime)
        let userUid:String = (loginUser?.uid)!

        uploadMyImage(userUid: userUid, imageArray: imagrArray) { (urlArray) in
            
            for url in urlArray {
                
                print(url)
                Database.database().reference().child("users").child(userUid).child("travelList").child(timeString).child("image\((urlArray.count - 1))").setValue(url)
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
            
            let scStorage = Storage.storage().reference().child(userUid).child("travelList").child(timeString).child("image\(count).png")
            
            let uploadData = UIImagePNGRepresentation(imageArray[count])
            
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
