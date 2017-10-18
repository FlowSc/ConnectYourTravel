//
//  InfoModifiedViewController.swift
//  ConnectYourDailyTravel
//
//  Created by Kang Seongchan on 2017. 10. 18..
//  Copyright © 2017년 Kang Seongchan. All rights reserved.
//

import UIKit
import SwiftyJSON
import Firebase
import SnapKit

class InfoModifiedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let myTableView:UITableView = {
        
        let tv = UITableView()
        
        return tv
        
    }()
    
    let myButton:UIButton = {
        
        let btn = UIButton(type: UIButtonType.system)
        
        return btn
    
    }()
    
    let user = Firebase.Auth.auth().currentUser

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(myTableView)
        view.addSubview(myButton)
        myTableView.delegate = self
        myTableView.dataSource = self
        myButton.setAzure()
        myButton.setTitle("수정 완료", for: UIControlState.normal)
        
        myButton.snp.makeConstraints { (make) in
            make.bottom.equalTo(60)
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.height.equalTo(60)
        }
        myTableView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
            make.bottom.equalTo(myButton.snp.top)
        }
        
        guard let user = user else {return}
        
        print(user.uid)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        return UITableViewCell()
    }
}
