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
        
        commentTv.delegate = self
        
        if commentList[commentIndex!] == "" {
        
        commentTv.placeholder = "여행을 기록하세요"
        }else{
            commentTv.text = commentList[commentIndex!]
        }
        print(commentList)

    }

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
