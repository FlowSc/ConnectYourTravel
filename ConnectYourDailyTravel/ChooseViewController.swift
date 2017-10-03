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
import FirebaseAuth
import Firebase
import FirebaseDatabase
import Photos

class ChooseViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{

    @IBOutlet weak var imageCollectionView: UICollectionView!
    
    let loginUser = Auth.auth().currentUser
    var imageList:[UIImage] = []
    var addressList:[String] = []
    var dkAssetsList:[DKAsset] = []
    var locationInfo:[CLLocationCoordinate2D] = []
    var dateList:[Date] = []
    var locationManager:CLLocationManager = CLLocationManager()
    var thumnailDate:String?
    let dateFormatter = DateFormatter()
    var arrangeDK:[DKAsset]!
    var arragnedImage:[UIImage]!
    
    @IBAction func moveToMapView(_ sender: UIButton) {
        
        
        if locationInfo.count >= 2 {
            
            let mvc = storyboard?.instantiateViewController(withIdentifier: "MapViewController") as! MapViewController
            
            mvc.myAddressList = addressList
            mvc.dkAssetsList = arrangeDK
            mvc.imageList = imageList
            
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
        
        let filterDate1 = selectedDate.addingTimeInterval(-86400)
        let filterDate2 = selectedDate.addingTimeInterval(86400)
        let filterPridicate = NSPredicate(format: "creationDate > %@ && creationDate < %@", filterDate1 as CVarArg, filterDate2 as CVarArg)
        let pickerController = DKImagePickerController()
        
        pickerController.imageFetchPredicate = filterPridicate
        pickerController.assetType = .allPhotos
        pickerController.didSelectAssets = {[unowned self](assets: [DKAsset]) in
            
            self.arrangeDK = assets.sorted { (aa, bb) -> Bool in
                
                let aaDate = aa.originalAsset?.creationDate!
                let bbDate = bb.originalAsset?.creationDate!
                
                return aaDate! < bbDate!
            }
          
            for asset in self.arrangeDK {
                
                print("ASSET START")
                print(asset)
                print("ASSET END")
                
                if asset.location?.coordinate != nil {
                    
                    self.dkAssetsList.append(asset)
                    
                    let assetLocation = asset.location?.coordinate
                    
                    self.locationInfo.append(assetLocation!)
                    
                    self.dateList.append((asset.originalAsset?.creationDate)!)
                    
                    print(self.dateList)
                    print(self.locationInfo)
                    
                    asset.fetchFullScreenImage(true, completeBlock: { [unowned self](image, info) in
                        self.imageList.append(image!)
                        self.imageCollectionView.reloadData()
                    })
                }else{
                    let alertC = UIAlertController.init(title: "선택한 사진 중 위치 정보가 없는 사진은 제외됩니다", message: "경로 설정을 위한 위치정보가 없으면 포함될수가 없습니다..", preferredStyle: .alert)
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
        
        
        if selectedDate == nil {
            selectedDate = Date()
        }
        
        print("DATE!!!")
        print(selectedDate)
        print("AAAAA")
        imageCollectionView.delegate = self
        imageCollectionView.dataSource = self
        self.imageCollectionView.register(UINib.init(nibName: "ThumnailImageCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "Cell")
        self.imageCollectionView.register(UINib.init(nibName: "TimeLineCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "TimeLineCollectionViewCell")

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageList.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TimeLineCollectionViewCell", for: indexPath) as! TimeLineCollectionViewCell
        
        let cellItem = self.arrangeDK[indexPath.item]
        let dateFormatter = DateFormatter()
        print("cellforRowAt")
        print(cellItem)
        print("~~~~~~")
        
        dateFormatter.dateFormat = "yyyy년 MM월 dd일 HH 시 mm 분"
        dateFormatter.timeZone = TimeZone.current
        
        Server.cellLocation(myLocation: (cellItem.originalAsset?.location)!) { (placemark) in
            
            cell.timeLb.text = dateFormatter.string(from: (cellItem.originalAsset?.creationDate)!)
            cell.addressLb.text = "\((placemark?.locality) ?? "") \((placemark?.name) ?? "")"
            
        }
        
        cellItem.fetchOriginalImageWithCompleteBlock { (image, _) in
            cell.photiImageView.image = image
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = view.bounds.width
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath.item)

        let mvc = storyboard?.instantiateViewController(withIdentifier: "CommentAddViewController") as! CommentAddViewController
        
        print(imageList[indexPath.item])
        
        mvc.myImage = imageList[indexPath.item]

    
        self.present(mvc, animated: true, completion: nil)
        
    }
}
