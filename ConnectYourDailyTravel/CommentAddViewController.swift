//
//  CommentAddViewController.swift
//  ConnectYourDailyTravel
//
//  Created by Kang Seongchan on 2017. 10. 3..
//  Copyright © 2017년 Kang Seongchan. All rights reserved.
//

import UIKit

var commentList:[String] = []

class CommentAddViewController: UIViewController, UITextViewDelegate {
    
    @IBOutlet weak var cancelOutlet: UIButton!
    @IBOutlet weak var saveOutlet: UIButton!
    var commentIndex:Int?

    @IBAction func ScreenTouched(_ sender: UITapGestureRecognizer) {
        commentTv.resignFirstResponder()
    }
    
    @IBOutlet weak var addressLb: UILabel!
    @IBOutlet weak var timeLb: UILabel!
    @IBOutlet weak var commentTv: UITextView!
    @IBOutlet weak var myImageView: UIImageView!
    var myImage:UIImage?
    var timeString:String?
    var addressString:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        saveOutlet.setAzure()
        cancelOutlet.setAzure()
        
        myImageView.image = myImage
        timeLb.text = timeString
        addressLb.text = addressString
        
        commentTv.delegate = self
        commentTv.placeholder = "여행을 기록하세요"
        print(commentList)
        
//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
//
    }
    
//    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
//        commentTv.becomeFirstResponder()
//
//        return true
//    }
//
//    func keyboardWillShow(notification: NSNotification) {
//        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
//            if self.view.frame.origin.y == 0{
//                self.view.frame.origin.y -= (keyboardSize.height - 20)
//            }
//        }
//    }
//
//    func keyboardWillHide(notification: NSNotification) {
//        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
//            if self.view.frame.origin.y != 0{
//                self.view.frame.origin.y += (keyboardSize.height - 20)
//            }
//        }
//    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    @IBAction func cancelActionTouched(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func savedActionTouched(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
        
            commentList.remove(at: commentIndex!)
        
        commentList.insert(commentTv.text, at: commentIndex!)
        
    }
}
