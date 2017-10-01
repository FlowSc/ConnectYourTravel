//
//  SignUpViewController.swift
//  ConnectYourDailyTravel
//
//  Created by Kang Seongchan on 2017. 9. 18..
//  Copyright © 2017년 Kang Seongchan. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase
import SwiftyJSON
import FirebaseDatabase

class SignUpViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var emailTf: UITextField!
    @IBOutlet weak var nickNameTf: UITextField!
    @IBOutlet weak var passwordTf: UITextField!
    @IBOutlet weak var confirmTf: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        emailTf.delegate = self
        passwordTf.delegate = self
        confirmTf.delegate = self
        nickNameTf.delegate = self

        emailTf.attributedPlaceholder = NSAttributedString(string: "이메일을 입력해주세요", attributes: [NSForegroundColorAttributeName:UIColor.white])
        nickNameTf.attributedPlaceholder = NSAttributedString(string: "닉네임을 입력해주세요", attributes: [NSForegroundColorAttributeName:UIColor.white])
        passwordTf.attributedPlaceholder = NSAttributedString(string: "비밀번호를 입력해주세요", attributes: [NSForegroundColorAttributeName:UIColor.white])
        confirmTf.attributedPlaceholder = NSAttributedString(string: "비밀번호를 다시 한번 입력해주세요", attributes: [NSForegroundColorAttributeName:UIColor.white])
        
        passwordTf.isSecureTextEntry = true
        confirmTf.isSecureTextEntry = true
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func signUpButtonTouched(_ sender: UIButton) {
        
        guard let email = emailTf.text, !email.isEmpty else {return}
        guard let password = passwordTf.text, !password.isEmpty else{return}
        guard let confirm = confirmTf.text, !confirm.isEmpty else{return}
        guard let nickname = nickNameTf.text, !nickname.isEmpty else {return}
        
        let ref = Database.database().reference().root
        
        if email != "" && (password != "") && (password == confirm) {
            Auth.auth().createUser(withEmail: email, password: password, completion: {(user, error) in
                if error == nil {
                    ref.child("users").child((user?.uid)!).child("userName").setValue(nickname)
                    ref.child("users").child((user?.uid)!).child("userEmail").setValue(email)
                    
                    self.dismiss(animated: true, completion: nil)
                    
                }else{
                    print(error?.localizedDescription)
                }
            })
            
        }
        
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
