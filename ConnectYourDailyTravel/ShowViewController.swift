//
//  ShowViewController.swift
//  ConnectYourDailyTravel
//
//  Created by Kang Seongchan on 2017. 10. 8..
//  Copyright © 2017년 Kang Seongchan. All rights reserved.
//

import UIKit
import SnapKit

class ShowViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        var myTableView = UITableView()
        myTableView.delegate = self
        myTableView.dataSource = self
        
        myTableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        
        view.addSubview(myTableView)

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
        return 10
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        return cell
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
