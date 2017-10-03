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
    
    @IBOutlet weak var commentTv: UITextView!
    @IBOutlet weak var myImageView: UIImageView!
    var myImage:UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        myImageView.image = myImage
        commentTv.delegate = self
        commentTv.placeholder = "여행을 기록하세요"
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
    }
    
    func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0{
                self.view.frame.origin.y -= (keyboardSize.height - 20)
            }
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y != 0{
                self.view.frame.origin.y += keyboardSize.height
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    @IBAction func cancelActionTouched(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func savedActionTouched(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}
