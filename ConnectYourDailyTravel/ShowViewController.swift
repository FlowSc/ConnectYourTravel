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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "모아보기"
        
        let myTableView = UITableView()
        myTableView.delegate = self
        myTableView.dataSource = self
        myTableView.ept.dataSource = self
        
        myTableView.register(UINib.init(nibName: "SHTableViewCell", bundle: nil), forCellReuseIdentifier: "Cell")
        
        view.addSubview(myTableView)
        
        myTableView.reloadData()
        ref = Database.database().reference()
        let userId = Auth.auth().currentUser?.uid
        
        ref.child("users").child(userId!).child("travelList").observe(DataEventType.value, with: { (snapshot) in
            
            let jsonData = JSON(snapshot.value)
            
            for i in jsonData {
                
                self.tupleArray.append(i)

            }
            
            myTableView.reloadData()
        })
        
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
        return tupleArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! SHTableViewCell
        
        let sortedArray = tupleArray.sorted { (a, b) -> Bool in
            a.0 > b.0
        }
        
        let data = sortedArray[indexPath.row]
        
        print((data.0))
        
        cell.textLb.text = (data.1)["title"].stringValue
        cell.routeLb.text = "\(((data.1)["addressList"].array?.first?.stringValue)!) 에서 " + "\(((data.1)["addressList"].array?.last?.stringValue)!) 까지" + "\n" + "\((data.1)["country"].stringValue)"
        cell.thumnailImage.kf.setImage(with: URL.init(string: (data.1)["images"][0].stringValue))
        cell.timeLb.text = "\(((data.1)["timeList"].array?.first?.stringValue)!) 부터 " + "\(((data.1)["timeList"].array?.last?.stringValue)!) 까지"
        cell.uploadTimeLb.text = (data.1)["uploadDate"].stringValue
        
        cell.tag = indexPath.row
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let sortedArray = tupleArray.sorted { (a, b) -> Bool in
            a.0 > b.0
        }
        
        let data = sortedArray[indexPath.row]
        
        print(data)
        
        let mvc = storyboard?.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
        
        mvc.detailData = data
        
        self.navigationController?.pushViewController(mvc, animated: true)
        
    }
}

extension ShowViewController: EmptyDataSource {
    
//    func imageForEmpty(in view: UIView) -> UIImage? {
//        return  #imageLiteral(resourceName: "YeogiBackground.png")
//    }
    
    func titleForEmpty(in view: UIView) -> NSAttributedString? {
        let title = "아직 데이터가 없네용!"
        let font = UIFont.systemFont(ofSize: 14)
        let attributes: [String : Any] = [NSForegroundColorAttributeName: UIColor.black, NSFontAttributeName: font]
        return NSAttributedString(string: title, attributes: attributes)
    }
    
//    func buttonTitleForEmpty(forState state: UIControlState, in view: UIView) -> NSAttributedString? {
//        let title = "click me"
//        let font = UIFont.systemFont(ofSize: 17)
//        let attributes: [String : Any] = [NSForegroundColorAttributeName: UIColor.white, NSFontAttributeName: font]
//        return NSAttributedString(string: title, attributes: attributes)
//    }
    
    func buttonBackgroundColorForEmpty(in view: UIView) -> UIColor {
        return UIColor.blue
    }
    
}
