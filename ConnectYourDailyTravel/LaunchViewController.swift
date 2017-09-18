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


class LaunchViewController: UIViewController {
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if let alreadySignedIn = Auth.auth().currentUser {
            
            print(alreadySignedIn)
            
            let mvc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "FirstNavController") as! UINavigationController
            
            self.present(mvc, animated: false, completion: nil)
            
        } else {
            
            print("User Login Required")
        }

    }
        
    
        
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let myLoginButton = UIButton.init(frame: CGRect(x: 0, y: 0, width: 180, height: 40))
        myLoginButton.backgroundColor = UIColor.red
        myLoginButton.center = view.center;
        myLoginButton.setTitle("My Login Button", for: .normal)
        // Handle clicks on the button
        myLoginButton.addTarget(self, action: #selector(loginButtonClicked), for: .touchUpInside)
        
        // Add the button to the view
        view.addSubview(myLoginButton)

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
            case .success(let grantedPermissions, let declinedPermissions, let accessToken):
                
                let credential = FacebookAuthProvider.credential(withAccessToken: accessToken.authenticationToken)
                
                // Perform login by calling Firebase APIs
                
                Auth.auth().signIn(with: credential, completion: {(user, error) in
                    
                    DispatchQueue.main.async {
                        print(user?.displayName)
                        print(user?.photoURL)
    
                        UserDefaults.standard.set(user?.displayName!, forKey: "UserName")
                        UserDefaults.standard.set(user?.photoURL!, forKey: "UserPhoto")
                    }
                })
                
                print("Logged in!")
                
                
                let mvc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "FirstNavController") as! UINavigationController
                
                self.present(mvc, animated: true, completion: nil)
                
            }
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
