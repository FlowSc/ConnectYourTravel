//
//  detailViewController.swift
//  ConnectYourDailyTravel
//
//  Created by Kang Seongchan on 2017. 10. 15..
//  Copyright © 2017년 Kang Seongchan. All rights reserved.
//

import UIKit
import SnapKit
import MapKit
import SwiftyJSON
import SwiftIcons
import Firebase


class DetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, MKMapViewDelegate, CLLocationManagerDelegate {
    
    var ref: DatabaseReference!
    let myTableVIew = UITableView()
    var source:JSON!
    var rowCount:Int?
    var clLocationList:[CLLocationCoordinate2D] = []
    var detailData:(String, JSON)?
    var locationManager = CLLocationManager()
    var myMapView = MKMapView()
    var currentIndex:Int = 0
    var myRoute:MKRoute!
    let userId = Auth.auth().currentUser?.uid
    
    let button1:UIButton = {
        
        let btn:UIButton = UIButton(type: UIButtonType.system)
        
        return btn
    }()
    
    let scMapView:MKMapView = {
        
        let mapView = MKMapView()
        
        return mapView
        
    }()
    
    func removeData(){
        print("remove")
        
        let mvc = storyboard?.instantiateViewController(withIdentifier: "MainTabbar") as! MyTabbarViewController
        let scStorage = Storage.storage().reference().child(self.userId!).child("travelList").child(self.detailData!.0)
        
        let alert = UIAlertController.init(title: "삭제 확인", message: "정말 삭제하시겠어요?", preferredStyle: UIAlertControllerStyle.alert)
        let alertAc = UIAlertAction.init(title: "네, 삭제할게요", style: UIAlertActionStyle.default) { (action) in
            self.ref.child("travelList").child(self.userId!).child(self.detailData!.0).removeValue()
            scStorage.delete(completion: { (error) in
                if error != nil {
                    print(error)
                }else{
                    print("delete OK!")
                }
            })
            

            self.present(mvc, animated: true, completion: nil)
        }
        let cancelAc = UIAlertAction.init(title: "다시 생각해볼게요", style: UIAlertActionStyle.cancel, handler: nil)
        alert.addAction(alertAc)
        alert.addAction(cancelAc)
        
        self.present(alert, animated: true, completion: nil)
        

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        let removeIcon:UIBarButtonItem = UIBarButtonItem(image: nil, landscapeImagePhone: nil, style: UIBarButtonItemStyle.plain, target: self, action: #selector(removeData))
        removeIcon.setIcon(icon: FontType.googleMaterialDesign(GoogleMaterialDesignType.removeCircle), iconSize: 25)

        self.navigationItem.rightBarButtonItem = removeIcon
        
        
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        
        
        locationManager.requestWhenInUseAuthorization()
        scMapView.showsUserLocation = true
        scMapView.showsCompass = true
        scMapView.delegate = self
        myTableVIew.delegate = self
        myTableVIew.dataSource = self
//        myTableVIew.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        myTableVIew.register(UINib.init(nibName: "DetailShowTableViewCell", bundle: nil), forCellReuseIdentifier: "Cell")
        scMapView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 400)
        myTableVIew.tableFooterView = scMapView
        myTableVIew.rowHeight = UITableViewAutomaticDimension
        
        view.addSubview(myTableVIew)
        
        myTableVIew.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalToSuperview()
        }
        
        guard let detail = detailData else {return}
        
        print(detail)
        
        self.navigationItem.title = (detail.1)["title"].stringValue
        
        source = detail.1
        
        for myIndex in 0..<source["longitudes"].count {
            
            print(myIndex)
        
            let myLocation:CLLocationCoordinate2D =
                
                CLLocationCoordinate2DMake(CLLocationDegrees(source["latitudes"][myIndex].doubleValue), CLLocationDegrees(source["longitudes"][myIndex].doubleValue))
            
            clLocationList.append(myLocation)
        
            print(myLocation)
            
            let point = MKPointAnnotation()
            point.title = "\(myIndex + 1) 번째 장소"
            point.subtitle = source["addressList"][myIndex].stringValue
            
            point.coordinate = myLocation
            
            scMapView.addAnnotation(point)

        }
        
        myTableVIew.reloadData()
        getMultipleLocationRoute()

        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return detailData!.1["addressList"].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! DetailShowTableViewCell
        
        let address = source["addressList"][indexPath.row]
        let image = source["images"][indexPath.row]
        let comment = source["commentList"][indexPath.row]
        let time = source["timeList"][indexPath.row]
        
        cell.locationLb.text = address.stringValue
        cell.setMyImage(imageString: image.stringValue)
//        cell.myImageView.kf.setImage(with: URL(string: image.stringValue))
        cell.commentLb.text = comment.stringValue
        cell.timeLb.text = time.stringValue
        
        
        
        return cell
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        
        let myLineRenderer = MKPolylineRenderer(polyline: (myRoute?.polyline)!)
        myLineRenderer.strokeColor = UIColor.cnnAzul
        myLineRenderer.lineWidth = 2
        return myLineRenderer
    }
    
//    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
//        if annotation.isKind(of: MKUserLocation.self) {  //Handle user location annotation..
//            return nil  //Default is to let the system handle it.
//        }
//
//        if !annotation.isKind(of: CustomAnnotation.self) {  //Handle non-ImageAnnotations..
//            var pinAnnotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "DefaultPinView")
//            if pinAnnotationView == nil {
//                pinAnnotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "DefaultPinView")
//            }
//            return pinAnnotationView
//        }
//
//        //Handle ImageAnnotations..
//        var view: ImageAnnotationView? = scMapView.dequeueReusableAnnotationView(withIdentifier: "imageAnnotation") as? ImageAnnotationView
//        if view == nil {
//            view = ImageAnnotationView(annotation: annotation, reuseIdentifier: "imageAnnotation")
//            view?.canShowCallout = false
//        }
//
//        let annotation = annotation as! CustomAnnotation
//        view?.image = annotation.image
//        view?.annotation = annotation
//
//        return view
//    }
    
    func getMultipleLocationRoute(){
        
        var locations = clLocationList
        
        while locations.count > 1 {
            
            let startLocation = locations.removeLast()
            let endLocation = locations.last!
            let startPlacemark = MKPlacemark(coordinate: startLocation)
            let endPlacemark = MKPlacemark(coordinate: endLocation)
            let startItem = MKMapItem(placemark: startPlacemark)
            let desItem = MKMapItem(placemark: endPlacemark)
            let directionRequest = MKDirectionsRequest()
            
            directionRequest.source = startItem
            directionRequest.destination = desItem
            directionRequest.transportType = myTransportType
            
            let directions = MKDirections(request: directionRequest)
            
            directions.calculate { (response, error) in
                
                guard let response = response else {return}
                
                let route = response.routes[0]
                self.myRoute = route
                self.scMapView.add((route.polyline), level: .aboveRoads)
                let rekt = route.polyline.boundingMapRect
                self.scMapView.setRegion(MKCoordinateRegionForMapRect(rekt), animated: true)
            }
        }
    }
    
    func moveToDetailMap(){
        
        let mvc = storyboard?.instantiateViewController(withIdentifier: "DetailMapViewController") as! DetailMapViewController
        
        mvc.locationList = clLocationList
        
        self.navigationController?.pushViewController(mvc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 300
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
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
