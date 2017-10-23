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
            if isSuccess {
                
                for userId in allUserId {
                    self.ref.child("users").child(userId).child("travelList").observe(DataEventType.value, with: { (snapshot) in
                        
                        let jsonData = JSON(snapshot.value)
                        
                        for i in jsonData {
                            
                            self.allTupleArray.append(i)
                            
                        }
                        
                        print(self.allTupleArray)
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

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

extension ShareViewController:UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 300
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ShareTableViewCell", for: indexPath) as! ShareTableViewCell
        
        return cell
    }
    
    
}
