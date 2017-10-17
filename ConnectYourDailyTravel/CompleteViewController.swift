//
//  CompleteViewController.swift
//  ConnectYourDailyTravel
//
//  Created by Kang Seongchan on 2017. 10. 13..
//  Copyright © 2017년 Kang Seongchan. All rights reserved.
//

import UIKit
import FirebaseDatabase
import SwiftyJSON
import SnapKit

class CompleteViewController: UIViewController {
    
    var timeString:String!
    var userUid:String!
    
    @IBOutlet weak var scTextField: UITextField!
    
    @IBOutlet weak var hashTagTf: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backToMainViewTouched(_ sender: UIButton) {
        let uploadChild = Database.database().reference().child("users").child(userUid).child("travelList").child(timeString)
        
        if scTextField.text != nil {
         uploadChild.child("title").setValue(scTextField.text)
        }
       
        if hashTagTf.text != nil {
        uploadChild.child("hashtag").setValue(hashTagTf.text)
        }
        
        let mvc = self.storyboard?.instantiateViewController(withIdentifier: "MainTabbar") as! MyTabbarViewController
        
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
