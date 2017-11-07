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

class CompleteViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate {
        
    var timeString:String!
    var userUid:String!
    
    @IBOutlet weak var backToMainOutlet: UIButton!
    @IBOutlet weak var scTextField: UITextField!
    @IBOutlet weak var hasTagTv: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        backToMainOutlet.setAzure()
        scTextField.delegate = self
        hasTagTv.delegate = self
        hasTagTv.placeholder = "검색어를 입력해주세요(선택사항)"
   
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backToMainViewTouched(_ sender: UIButton) {
             let travelListDataBase = Database.database().reference().child("travelList").child(userUid).child(timeString)
        
        if scTextField.text == "" {
            let alert = UIAlertController.init(title: "제목을 입력해주세요!", message: nil, preferredStyle: UIAlertControllerStyle.alert)
            let alertAction = UIAlertAction.init(title: "확인", style: UIAlertActionStyle.cancel, handler: nil)
            alert.addAction(alertAction)
            self.present(alert, animated: true, completion: nil)
        }
        
        if hasTagTv.text != "" {
            travelListDataBase.child("hashtag").setValue(hasTagTv.text)
        }
    
        if scTextField.text != "" {
            travelListDataBase.child("title").setValue(scTextField.text)
            let mvc = self.storyboard?.instantiateViewController(withIdentifier: "MainTabbar") as! MyTabbarViewController
            self.present(mvc, animated: true, completion: nil)
        }
        
    }

    @IBAction func keyboardDisappear(_ sender: UITapGestureRecognizer) {
        
        hasTagTv.resignFirstResponder()
        scTextField.resignFirstResponder()
        
    }
}
