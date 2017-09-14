//
//  TimelineViewController.swift
//  ConnectYourDailyTravel
//
//  Created by Kang Seongchan on 2017. 9. 14..
//  Copyright © 2017년 Kang Seongchan. All rights reserved.
//

import UIKit
import TimelineTableViewCell
import DKImagePickerController
import MapKit
import SwiftyJSON
import Alamofire

class TimelineViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var dkAssetList:[DKAsset] = []
    var myAddressList:[String] = []

    @IBOutlet weak var myTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        myTableView.delegate = self
        myTableView.dataSource = self
        
//        self.navigationItem.title = "여행의 흐름"
        
        let bundle = Bundle(for: TimelineTableViewCell.self)
        let nibUrl = bundle.url(forResource: "TimelineTableViewCell", withExtension: "bundle")
        let timelineTableViewCellNib = UINib(nibName: "TimelineTableViewCell",
                                             bundle: Bundle(url: nibUrl!)!)
        myTableView.register(timelineTableViewCellNib, forCellReuseIdentifier: "TimelineTableViewCell")
        myTableView.reloadData()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dkAssetList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        var cellAddress:String = ""
        let cell = tableView.dequeueReusableCell(withIdentifier: "TimelineTableViewCell",
                                                 for: indexPath) as! TimelineTableViewCell
        
        let cellItem = dkAssetList[indexPath.item]
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "yyyy년 MM월 dd일 HH 시 mm 분"
        dateFormatter.timeZone = TimeZone.current

        
        Server.cellLocation(myLocation: (cellItem.originalAsset?.location)!) { (placemark) in
            print("Placemark")
            print(placemark?.name)
            cellAddress = (placemark?.name)!
            cell.titleLabel.text = dateFormatter.string(from: (cellItem.originalAsset?.creationDate)!) + "\n\((placemark?.name)!)"
            cell.titleLabel.textColor = .black
            print("end")
        }
        
        cellItem.fetchOriginalImageWithCompleteBlock { (image, _) in
            cell.thumbnailImageView.image = image
        }
        
        
        
        


        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
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
