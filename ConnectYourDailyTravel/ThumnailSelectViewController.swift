//
//  ThumnailSelectViewController.swift
//  ConnectYourDailyTravel
//
//  Created by Kang Seongchan on 2017. 9. 30..
//  Copyright © 2017년 Kang Seongchan. All rights reserved.
//

import UIKit
import DKImagePickerController
import MapKit


var dataParameter:[String:Any] = [:]

class ThumnailSelectViewController: UIViewController {

    @IBOutlet weak var thumnailImage: UIImageView!
    var thumnailDK:DKAsset?
    var thumnailDate:String?
    let dateFormatter = DateFormatter()
    var thumnailDateData:Date?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func thumnailPickerTouched(_ sender: Any) {
        
        let picker = DKImagePickerController()
        picker.autoCloseOnSingleSelect = true
        picker.singleSelect = true
        
        
        self.present(picker, animated: true, completion: nil)
        
        picker.didSelectAssets = {[unowned self](assets: [DKAsset]) in
            
            let thumnailImage = assets[0]
            
            self.dateFormatter.dateFormat = "MM-dd-yyyy"
            
            self.thumnailDate = self.dateFormatter.string(from: (thumnailImage.originalAsset?.creationDate)!)
            
            thumnailImage.fetchOriginalImageWithCompleteBlock({ (image, _) in
                self.thumnailImage.image = image
            })
            self.thumnailDK = thumnailImage
            self.thumnailDateData = thumnailImage.originalAsset?.creationDate
            
        }
        
    }
    
    @IBAction func moveToSelectTouched(_ sender: Any) {
        
        if thumnailDK != nil {
        
        let mv = storyboard?.instantiateViewController(withIdentifier: "ChooseViewController") as! ChooseViewController
        
        mv.thumnailDate = thumnailDate

            
            self.navigationController?.pushViewController(mv, animated: true)
        
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
