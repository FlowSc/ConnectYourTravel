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

class ShowViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var ref: DatabaseReference!
    var showingData:[JSON] = []
    var uploadTimeList:[String] = []
    var tupleArray:[(String,JSON)] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let myTableView = UITableView()
        myTableView.delegate = self
        myTableView.dataSource = self
        
        myTableView.register(UINib.init(nibName: "SHTableViewCell", bundle: nil), forCellReuseIdentifier: "Cell")
        
        view.addSubview(myTableView)
        
        myTableView.reloadData()
        ref = Database.database().reference()
        let userId = Auth.auth().currentUser?.uid
        
  
        ref.child("users").child(userId!).child("travelList").observe(DataEventType.value, with: { (snapshot) in
//            print(snapshot)
            
            let jsonData = JSON(snapshot.value)
            
            print(jsonData.count)
            
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
        
        cell.textLb.text = data.0
        cell.routeLb.text = "\(((data.1)["addressList"].array?.first?.stringValue)!) 에서 " + "\(((data.1)["addressList"].array?.last?.stringValue)!) 까지"
        cell.thumnailImage.kf.setImage(with: URL.init(string: (data.1)["images"][0].stringValue))
        cell.timeLb.text = "\(((data.1)["timeList"].array?.first?.stringValue)!) 부터 " + "\(((data.1)["timeList"].array?.last?.stringValue)!) 까지"
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
