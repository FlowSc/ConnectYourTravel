//
//  ShareViewController.swift
//  ConnectYourDailyTravel
//
//  Created by Kang Seongchan on 2017. 10. 22..
//  Copyright © 2017년 Kang Seongchan. All rights reserved.
//

import UIKit
import Firebase
import SwiftyJSON
import SnapKit
import Kingfisher


class ShareViewController: UIViewController {
    
    var userUidArray:[String] = []
    let ref = Database.database().reference()
    var allTupleArray:[(String,JSON)] = []

    var myTableView:UITableView = {
        
        
        var tv:UITableView = UITableView()
        
        return tv
        
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        myTableView.reloadData()
    }

    override func viewDidLoad() {
        
        super.viewDidLoad()
    
        Server.getAllId { (isSuccess, allUserId) in
            
            var allArray:[(String, JSON)] = []
            if isSuccess {
                
                for userId in allUserId {
                    self.ref.child("travelList").child(userId).observe(DataEventType.value, with: { (snapshot) in
                        
                        let jsonData = JSON(snapshot.value)
                        
                        for i in jsonData {
                            
                            allArray.append(i)
                            
                        }
                        
                        self.allTupleArray = allArray.sorted(by: { (aa, bb) -> Bool in
                            return aa.0 > bb.0
                        })
                
                        self.myTableView.reloadData()
                    })
                    
                }

            }
        }
        
        myTableView.delegate = self
        myTableView.dataSource = self
        myTableView.register(UINib.init(nibName: "ShareTableViewCell", bundle: nil), forCellReuseIdentifier: "ShareTableViewCell")
        
        
        view.addSubview(myTableView)
        
        
        myTableView.snp.makeConstraints { (make) in
            make.size.equalToSuperview()
            make.center.equalToSuperview()
        }
        
        myTableView.reloadData()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

extension ShareViewController:UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allTupleArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 450
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ShareTableViewCell", for: indexPath) as! ShareTableViewCell
        
        let cellData = allTupleArray[indexPath.row].1
        

        print("~~~~")
        let thumnailImage:String = cellData["images"][0].stringValue
        let thumnailUrl:URL = URL(string: thumnailImage)!
        print(thumnailUrl)
        print("~~~~")
        
        cell.thumnailImageView.kf.setImage(with: thumnailUrl)
        

        cell.uploaderLb.text = "\(cellData["uploader"].stringValue)"
        cell.uploadDateLb.text = "\(cellData["uploadDate"].stringValue)"
//        cell.travelLocationLb.text = cellData["addressList"][0].stringValue
//        cell.travelTimeLb.text = cellData["timeList"][0].stringValue
        cell.hashtagLb.text = cellData["hashtag"].stringValue
        cell.titleLb.text = cellData["title"].stringValue
        cell.countryLb.text = cellData["country"].stringValue
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let sortedArray = allTupleArray.sorted { (a, b) -> Bool in
            a.0 > b.0
        }
        let data = sortedArray[indexPath.row]
        
        print(data)
        
        let mvc = storyboard?.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
        
        mvc.detailData = data
        
        self.navigationController?.pushViewController(mvc, animated: true)
    }
    
    
    
}
