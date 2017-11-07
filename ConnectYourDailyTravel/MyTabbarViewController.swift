//
//  MyTabbarViewController.swift
//  ConnectYourDailyTravel
//
//  Created by Kang Seongchan on 2017. 9. 30..
//  Copyright © 2017년 Kang Seongchan. All rights reserved.
//

import UIKit
import Firebase
import SwiftyJSON
import SwiftIcons

var loginUserName:String = ""

class MyTabbarViewController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let individualTab = self.tabBar.items![0]
        let addtab = self.tabBar.items![1]
//        let shareTab = self.tabBar.items![2]
        let accountTab = self.tabBar.items![2]
        
        
        individualTab.setIcon(icon: FontType.googleMaterialDesign(GoogleMaterialDesignType.archive))
        addtab.setIcon(icon: FontType.googleMaterialDesign(GoogleMaterialDesignType.addCircle))
        accountTab.setIcon(icon: FontType.googleMaterialDesign(GoogleMaterialDesignType.accountCircle))

  
        
        let ref = Database.database().reference()
        
        ref.child("users").child((Auth.auth().currentUser?.uid)!).observe(.value, with: { snapshot in
            
            let jsonData = JSON(snapshot.value)
            
            loginUserName = jsonData["userName"].stringValue
            print("~~~~")
            print(loginUserName)
            print("~~~~")
        })
        
//        self.tabBar.barTintColor = UIColor.cnnAzul
        self.tabBar.tintColor = UIColor.cnnWhite
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
