//
//  SideTableViewController.swift
//  ConnectYourDailyTravel
//
//  Created by Kang Seongchan on 2017. 9. 18..
//  Copyright © 2017년 Kang Seongchan. All rights reserved.
//

import UIKit
import Kingfisher
import FirebaseAuth

class SideTableViewController: UITableViewController {

    @IBOutlet weak var userInfoView: UserProfileView!
    let settingMenu:[String] = ["저장된 여행 기록 보기", "계정관리", "설정", "개발자에게", "로그아웃"]
    var photoUrl = UserDefaults.standard.url(forKey: "UserPhoto")
    var loginUserName =  UserDefaults.standard.string(forKey: "UserName")
    
    @IBOutlet var settingTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        settingTableView.delegate = self
        settingTableView.dataSource = self
        userInfoView.nameLb.text = "\(loginUserName ?? "Guest") 님 환영합니다!"
        userInfoView.profileImageView.kf.setImage(with: photoUrl)
        userInfoView.profileImageView.layer.cornerRadius = userInfoView.profileImageView.bounds.width / 2
        userInfoView.profileImageView.clipsToBounds = true
        
          }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return settingMenu.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SettingCell", for: indexPath)


        cell.textLabel?.text = settingMenu[indexPath.row]
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 4 {
            
            let fireBaseAuth = Auth.auth()
            
            do {
                try fireBaseAuth.signOut()
                UserDefaults.standard.set("", forKey: "UserName")
                print("Log Out!")
                
                let mvc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LaunchViewController") as! LaunchViewController
                
                self.present(mvc, animated: true, completion: nil)
                
            } catch let signOutError as NSError {
                print ("Error signing out: %@", signOutError)
            }
            
        }
        
    }

}



class UserProfileView:UIView {
    
    @IBOutlet weak var profileImageView:UIImageView!
    @IBOutlet weak var nameLb:UILabel!
    
    
}
