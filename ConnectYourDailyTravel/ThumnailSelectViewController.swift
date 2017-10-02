//
//  ThumnailSelectViewController.swift
//  ConnectYourDailyTravel
//
//  Created by Kang Seongchan on 2017. 9. 30..
//  Copyright © 2017년 Kang Seongchan. All rights reserved.
//

import UIKit
import DKImagePickerController
import MapKit


var savedArray:[DKAsset] = []
var selectedDate:Date = Date()


class ThumnailSelectViewController: UIViewController {

    @IBAction func datePickerChanged(_ sender: UIDatePicker) {
        
        sender.date = selectedDate
    }
    var thumnailDK:DKAsset?
    var thumnailDate:String?
    let dateFormatter = DateFormatter()
    var thumnailDateData:Date?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func selectWayToMoveSegment(_ sender: UISegmentedControl) {
        
        if sender.selectedSegmentIndex == 0 {
            myTransportType = MKDirectionsTransportType.automobile
        }else if sender.selectedSegmentIndex == 1 {
            myTransportType = MKDirectionsTransportType.walking
        }else if sender.selectedSegmentIndex == 2 {
            myTransportType = MKDirectionsTransportType.transit
        }
    }
    
    @IBAction func moveToSelectTouched(_ sender: Any) {
        
        let mv = storyboard?.instantiateViewController(withIdentifier: "ChooseViewController") as! ChooseViewController
        
            
            self.navigationController?.pushViewController(mv, animated: true)
        

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
