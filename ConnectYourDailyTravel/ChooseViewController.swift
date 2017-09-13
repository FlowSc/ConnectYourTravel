//
//  ChooseViewController.swift
//  ConnectYourDailyTravel
//
//  Created by Kang Seongchan on 2017. 9. 13..
//  Copyright © 2017년 Kang Seongchan. All rights reserved.
//

import UIKit
import MapKit
import DKImagePickerController
import SwiftyJSON

class ChooseViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet weak var imageCollectionView: UICollectionView!
    
    var imageList:[UIImage] = []
    var addressList:[String] = []
    var dkAssetsList:[DKAsset] = []
    var locationInfo:[CLLocationCoordinate2D] = []
    var dateList:[Date] = []
    var locationManager:CLLocationManager = CLLocationManager()
    
    @IBAction func moveToMapView(_ sender: UIButton) {
        
        if locationInfo.count >= 2 {
            
            let mvc = storyboard?.instantiateViewController(withIdentifier: "MapViewController") as! MapViewController
            
            mvc.addressList = addressList
            mvc.dkAssetList = dkAssetsList
            mvc.locationInfoList = locationInfo
            
            
            self.navigationController?.pushViewController(mvc, animated: true)}
        else{
            let alertC = UIAlertController.init(title: "사진이 선택되지 않았습니다", message: "경로 설정을 위해 두개 이상의 사진을 선택해주세요!", preferredStyle: .alert)
            let alertAction = UIAlertAction.init(title: "확인", style: .cancel, handler: nil)
            
            alertC.addAction(alertAction)
            
            self.present(alertC, animated: true, completion: nil)
        }
        
    }

    
    @IBAction func imageSelectButton(_ sender: UIButton) {
        
        imageList = []
        addressList = []
        dkAssetsList = []
        locationInfo = []
        dateList = []
        
        let pickerController = DKImagePickerController()
        
        pickerController.didSelectAssets = {[unowned self](assets: [DKAsset]) in
            
            
            for asset in assets {
                
                print("ASSET START")
                print(asset)
                print("ASSET END")
                
                if asset.location?.coordinate != nil {
                    
                    self.dkAssetsList.append(asset)
                    print(self.dkAssetsList)
                    let assetLocation = asset.location?.coordinate
                    let assetLongitude = assetLocation?.longitude
                    let assetLatitude = assetLocation?.latitude
                    
                    self.locationInfo.append(assetLocation!)
                    
                    self.dateList.append((asset.originalAsset?.creationDate)!)
                    
                    print(self.dateList)
                    print(self.locationInfo)
                    
                    asset.fetchFullScreenImage(true, completeBlock: { [unowned self](image, info) in
                        self.imageList.append(image!)
                        self.imageCollectionView.reloadData()
                    })
                }else{
                    let alertC = UIAlertController.init(title: "선택된 사진은 위치정보가 기재되어 있지 않습니다", message: "경로 설정을 위해 위치정보가 저장된 사진을 선택해주세요!", preferredStyle: .alert)
                    let alertAction = UIAlertAction.init(title: "확인", style: .cancel, handler: nil)
                    
                    alertC.addAction(alertAction)
                    
                    self.present(alertC, animated: true, completion: nil)
                    
                }
            }
            
        }
        self.present(pickerController, animated: true, completion: nil)
        self.imageCollectionView.reloadData()

    }
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageCollectionView.delegate = self
        imageCollectionView.dataSource = self
        self.imageCollectionView.register(UINib.init(nibName: "ThumnailImageCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "Cell")

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageList.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! ThumnailImageCollectionViewCell
        
        cell.imageView.image = imageList[indexPath.item]
        
        return cell
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
