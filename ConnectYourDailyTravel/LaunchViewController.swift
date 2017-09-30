//
//  LaunchViewController.swift
//  ConnectYourDailyTravel
//
//  Created by Kang Seongchan on 2017. 9. 18..
//  Copyright © 2017년 Kang Seongchan. All rights reserved.
//

import UIKit
import FacebookLogin
import Firebase
import FirebaseAuth
import SnapKit
import SwiftyJSON
import Alamofire


class LaunchViewController: UIViewController {
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if let alreadySignedIn = Auth.auth().currentUser {
            
            print(alreadySignedIn)
            
            let mvc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MainTabbar") as! MyTabbarViewController
            
            self.present(mvc, animated: false, completion: nil)
            
        } else {
            
            print("User Login Required")
        }

    }
    @IBAction func facebookLoginTouched(_ sender: UIButton) {
        loginButtonClicked()
    }
    
    @IBAction func emailLoginTouched(_ sender: Any) {
        emailLoginTouched()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loginButtonClicked() {
        
        let loginManager = LoginManager()
        loginManager.logIn([ .publicProfile ], viewController: self) {[unowned self] loginResult in
            switch loginResult {
            case .failed(let error):
                print(error)
            case .cancelled:
                print("User cancelled login.")
            case .success(let grantedPermissions, let _, let accessToken):
                
                let credential = FacebookAuthProvider.credential(withAccessToken: accessToken.authenticationToken)
                
                // Perform login by calling Firebase APIs
                let ref = Database.database().reference().root

                Auth.auth().signIn(with: credential, completion: {(user, error) in
                    
                        guard let url = user?.photoURL else {return}
                        print(user?.photoURL)
    
                        ref.child("users").child((user?.uid)!).child("userName").setValue(user?.displayName)
                        ref.child("users").child((user?.uid)!).child("photoUrl").setValue(String(describing: url))
                    
                })
                
                print("Logged in!")
                
                
                let mvc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MainTabbar") as! MyTabbarViewController
                
                self.present(mvc, animated: true, completion: nil)
                
            }
        }
    }
    
    func emailLoginTouched() {
        
        let mvc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "EmailLoginViewController") as! EmailLoginViewController
        
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
