//
//  ResultViewController.swift
//  ConnectYourDailyTravel
//
//  Created by Kang Seongchan on 2017. 10. 3..
//  Copyright © 2017년 Kang Seongchan. All rights reserved.
//

import UIKit
import TimelineTableViewCell


class ResultViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    
    let imageList = totalData["imageList"] as! [String]
    let timeList = totalData["timeList"] as! [String]
    @IBOutlet weak var myTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        let bundle = Bundle(for: TimelineTableViewCell.self)
        let nibUrl = bundle.url(forResource: "TimelineTableViewCell", withExtension: "bundle")
        let timelineTableViewCellNib = UINib(nibName: "TimelineTableViewCell",
                                             bundle: Bundle(url: nibUrl!)!)
        myTableView.register(timelineTableViewCellNib, forCellReuseIdentifier: "TimelineTableViewCell")
        
        myTableView.delegate = self
        myTableView.dataSource = self

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return imageList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TimelineTableViewCell", for: indexPath) as! TimelineTableViewCell
        

        cell.textLabel?.text = timeList[indexPath.row]
        
        
        return cell
    }
    

    @IBAction func resultButtonTouched(_ sender: UIButton) {
        
//        individualData.append(totalData)
        
        UserDefaults.standard.set(totalData, forKey: "IndividualData")
        
        let mvc = storyboard?.instantiateViewController(withIdentifier: "ShowNavViewController") as! UINavigationController
        
        self.present(mvc, animated: true, completion: nil)
        
        
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
