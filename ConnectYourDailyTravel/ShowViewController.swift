//
//  ShowViewController.swift
//  ConnectYourDailyTravel
//
//  Created by Kang Seongchan on 2017. 10. 8..
//  Copyright © 2017년 Kang Seongchan. All rights reserved.
//

import UIKit
import SnapKit
import Firebase
import SwiftyJSON
import EmptyKit

class ShowViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var ref: DatabaseReference!
    var showingData:[JSON] = []
    var uploadTimeList:[String] = []
    var tupleArray:[(String,JSON)] = []
    var loginuserName:String!
    var sortedArray:[(String,JSON)] = []
    let userId = Auth.auth().currentUser?.uid
    let myTableView = UITableView()
    var showArray:[(String, JSON)] = []

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "나의 여기"
        
        myTableView.delegate = self
        myTableView.dataSource = self
        myTableView.ept.dataSource = self
        
        myTableView.register(UINib.init(nibName: "SHTableViewCell", bundle: nil), forCellReuseIdentifier: "Cell")
        
        view.addSubview(myTableView)
        
        
        ref = Database.database().reference()
        
        
        ref.child("travelList").child(userId!).observe(DataEventType.value, with: { (snapshot) in
            
            let jsonData = JSON(snapshot.value)
            
            for i in jsonData {
                
                self.tupleArray.append(i)
                
            }
            
            self.sortedArray = self.tupleArray.sorted { (a, b) -> Bool in
                a.0 > b.0
            }
            
            self.showArray = self.sortedArray
            self.myTableView.reloadData()
        })
        
        print(sortedArray)
        
        myTableView.reloadData()
        
        
        myTableView.snp.makeConstraints { (con) in
            con.width.equalToSuperview()
            con.height.equalToSuperview()
            con.centerX.equalToSuperview()
            con.centerY.equalToSuperview()
        }
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return showArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! SHTableViewCell
        
        if showArray.count != 0 {
        
        let data = showArray[indexPath.row]
        
        print((data.0))
        
            
        DispatchQueue.main.async {
        cell.textLb.text = (data.1)["title"].stringValue
        cell.routeLb.text = "\(((data.1)["addressList"].array?.first?.stringValue)!) 에서 " + "\n" + "\(((data.1)["addressList"].array?.last?.stringValue)!) 까지"
        cell.thumnailImage.kf.setImage(with: URL.init(string: (data.1)["images"][0].stringValue))
        cell.timeLb.text = "\(((data.1)["timeList"].array?.first?.stringValue)!)" + " ~ " + "\(((data.1)["timeList"].array?.last?.stringValue)!)"
        cell.uploadTimeLb.text = (data.1)["uploadDate"].stringValue
            }
        cell.tag = indexPath.row
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 350
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        let data = showArray[indexPath.row]
        
        print(data)
        
        let mvc = storyboard?.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
        
        mvc.detailData = data
        
        self.navigationController?.pushViewController(mvc, animated: true)
        
    }
    
//    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
//        return true
//    }
//
//    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
//
//
//        if editingStyle == .delete{
//
//            
//            print("~~~~~~")
////            print(showArray[indexPath.row].0)
////            print(indexPath.row)
//            print(showArray.count)
//            ref.child("travelList").child(userId!).child(showArray[indexPath.row].0).removeValue()
//            showArray.remove(at: indexPath.row)
//            tableView.reloadData()
//            tableView.reloadInputViews()
//
//            print("~~~~")
//
//
//        }
//    }
    
}

extension ShowViewController: EmptyDataSource {
    
    func titleForEmpty(in view: UIView) -> NSAttributedString? {
        let title = "당신의 여행을 기록하세요"
        let font = UIFont.systemFont(ofSize: 25)
        let attributes: [String : Any] = [NSForegroundColorAttributeName: UIColor.black, NSFontAttributeName: font]
        return NSAttributedString(string: title, attributes: attributes)
    }
 
}
