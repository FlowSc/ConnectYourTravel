//
//  EmailLoginViewController.swift
//  ConnectYourDailyTravel
//
//  Created by Kang Seongchan on 2017. 9. 18..
//  Copyright © 2017년 Kang Seongchan. All rights reserved.
//

import UIKit
import FirebaseAuth

class EmailLoginViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var emailTf: UITextField!

    @IBOutlet weak var passwordTf: UITextField!
    
    @IBAction func backButtonTouched(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)

        
        emailTf.delegate = self
        passwordTf.delegate = self
        
        emailTf.attributedPlaceholder = NSMutableAttributedString(string: "이메일을 입력해주세요", attributes: [NSForegroundColorAttributeName:UIColor.white])
        
        passwordTf.attributedPlaceholder = NSMutableAttributedString(string: "비밀번호를 입력해주세요", attributes: [NSForegroundColorAttributeName:UIColor.white])
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0{
                self.view.frame.origin.y -= keyboardSize.height
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
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    @IBAction func loginButtonTouched(_ sender: UIButton) {
        
        guard let email = emailTf.text, let password = passwordTf.text else {return}
        
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            if let error = error {
                print(error.localizedDescription)
            }else if let user = Auth.auth().currentUser {
                print(user)
                let mvc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MainTabbar") as! MyTabbarViewController
                
                self.present(mvc, animated: true, completion: nil)

            }
        }
    }

    
}
