//
//  TimeLineCollectionViewController.swift
//  ConnectYourDailyTravel
//
//  Created by Kang Seongchan on 2017. 9. 18..
//  Copyright © 2017년 Kang Seongchan. All rights reserved.
//

import UIKit
import DKImagePickerController
import MapKit
import SwiftyJSON
import Alamofire

class TimeLineCollectionViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UITextViewDelegate, UICollectionViewDelegateFlowLayout {

    var dkAssetList:[DKAsset] = []
    var myAddressList:[String] = []
    var commentList:[String] = []
    var realCommentList:[String] = ["aa", "bb", "cc", "dd", "ee", "ff", "GG", "qq", "xx" , "ww", "yy", "tt", "o", "p"]

    
    @IBOutlet weak var myCollectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        myCollectionView.dataSource = self
        myCollectionView.delegate = self
        
        myCollectionView.register(UINib.init(nibName: "TimeLineCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "TimeLineCollectionViewCell")
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        for _ in dkAssetList {
            commentList.append("코멘트를 남겨주세요")
        }
        
        print(commentList.count)
        
        }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dkAssetList.count
    
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TimeLineCollectionViewCell", for: indexPath) as! TimeLineCollectionViewCell
        
        let cellItem = dkAssetList[indexPath.item]
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
    
        cell.commentTv.delegate = self
        cell.commentTv.text = realCommentList[indexPath.item]
        print("~~~~~~")
        print(realCommentList[indexPath.item])
        print(cell.commentTv.text)
        print("~~~~~~~~")
        realCommentList[indexPath.item] = cell.commentTv.text
        print(realCommentList[indexPath.item])

        
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TimeLineCollectionViewCell", for: indexPath) as! TimeLineCollectionViewCell
        
        if cell.commentTv.isFocused == true {
            print(indexPath.item)

        }
        
    
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
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // Compute the dimension of a cell for an NxN layout with space S between
        // cells.  Take the collection view's width, subtract (N-1)*S points for
        // the spaces between the cells, and then divide by N to find the final
        // dimension for the cell's width and height.
        
        let cellsAcross: CGFloat = 1
        let spaceBetweenCells: CGFloat = 0
        let width = view.bounds.width
        return CGSize(width: width, height: width * 1.5)
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
