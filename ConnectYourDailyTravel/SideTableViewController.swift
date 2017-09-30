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
import FirebaseDatabase

class SideTableViewController: UITableViewController {
    
    
    var ref: DatabaseReference!

    @IBOutlet weak var userInfoView: UserProfileView!
    let settingMenu:[String] = ["저장된 여행 기록 보기", "계정관리", "설정", "개발자에게", "로그아웃"]
//    var photoUrl = UserDefaults.standard.url(forKey: "UserPhoto")
//    var loginUserName =  UserDefaults.standard.string(forKey: "UserName")
    
    @IBOutlet var settingTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = Database.database().reference()
        self.userInfoView.profileImageView.image = #imageLiteral(resourceName: "default-user-image.png")
        self.userInfoView.nameLb.text = "User"

        
        settingTableView.delegate = self
        settingTableView.dataSource = self

        
          }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        let loginUser = Auth.auth().currentUser?.uid
        print(loginUser)

        guard let loginUser1 = loginUser else {return}
        
        ref.child("users").child(loginUser1).observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary
            let userName = value?["userName"] as? String ?? ""
            self.userInfoView.nameLb.text = userName
            let profileImage = value?["photoUrl"] as? String ?? ""
            self.userInfoView.profileImageView.image = #imageLiteral(resourceName: "default-user-image.png")
            
            
            if profileImage != "" {
                self.userInfoView.profileImageView.kf.setImage(with: URL.init(string: profileImage))
            }
            
        })
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
    
    override func awakeFromNib() {
        self.profileImageView.layer.cornerRadius = self.profileImageView.bounds.width / 2
        self.profileImageView.clipsToBounds = true
    }
}
