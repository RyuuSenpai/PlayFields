//
//  PlayFieldsVC.swift
//  Elmla3eb
//
//  Created by Macbook Pro on 3/23/17.
//  Copyright © 2017 Killvak. All rights reserved.
//

import UIKit
 import CoreLocation

class PlayFieldsVC: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var searchBarText: UISearchBar!
    @IBOutlet weak var confirmedBtn: UIButton!
    @IBOutlet weak var bookedFieldsBtn: UIButton!
    @IBOutlet weak var unconfirmedBtn: UIButton!
    @IBOutlet weak var nearByFieldsBtn: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var selectionBtnsViewHeightConstant: NSLayoutConstraint!
    
    var buttonTag : Int = 0
    var locationManager = CLLocationManager()
    var userLat : String?
    var userLong : String?
    var nearFieldsData : [NearByFields_Data]?{
        didSet {
            print("that's the data : \(nearFieldsData)")
            nearFieldsSelected()
            tableView?.reloadData()
        }
    }
    
     var confirmedP_G : [NearByFields_Data]?{
        didSet {
              tableView?.reloadData()
        }
    }
    var unconfirmedP_G : [NearByFields_Data]?{
        didSet {
              tableView?.reloadData()
        }
    }
    var playGroudModel : GetPlayGroundsData!
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
        setupLocationM()
        let nib = UINib(nibName: "FieldsCell", bundle: nil)
        
        tableView.register(nib, forCellReuseIdentifier: "cell")
        // Do any additional setup after loading the view.
        let tapped = UITapGestureRecognizer(target: self, action: #selector(self.closekeyBoard(_:)))
        
        self.view.addGestureRecognizer(tapped)
        
     }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.alpha = 0
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tableView.alpha = 1
        animateTableView()
    }
    
    func closekeyBoard(_ tapped : UITapGestureRecognizer) {
        
        view.endEditing(true)
    }
    
    
    @IBAction func typeOfFieldsBtnsAction(_ sender: UIButton) {
        
        guard sender.tag != self.buttonTag else { return }
        if sender.tag == 0 {
            
        }else if sender.tag == 1 {
            
        }
        self.buttonTag = sender.tag
        print("that's button tag : \(self.buttonTag) ")
        switch sender.tag {
        case 0:
             nearFieldsSelected()
        case 1 :
             UIView.animate(withDuration: 0.5, animations: {
                self.selectionBtnsViewHeightConstant.constant = 96
                self.nearByFieldsBtn.backgroundColor = Constants.Colors.gray
                self.bookedFieldsBtn.backgroundColor = Constants.Colors.red
                self.confirmedBtn.backgroundColor = Constants.Colors.gray
                self.unconfirmedBtn.backgroundColor = Constants.Colors.green
                self.view.layoutIfNeeded()
            })
        case 2 :
             self.confirmedBtn.backgroundColor = Constants.Colors.green
            self.unconfirmedBtn.backgroundColor = Constants.Colors.gray
        default:
             self.confirmedBtn.backgroundColor = Constants.Colors.gray
            self.unconfirmedBtn.backgroundColor = Constants.Colors.green
        }
        if  let _ = tableView.cellForRow(at: [0,3]) {
        tableView.scrollToRow(at: [0,0], at: UITableViewScrollPosition.top, animated: true)
        }
        tableView.reloadData()
        animateTableView()
        
    }
    
    func nearFieldsSelected() {
        UIView.animate(withDuration: 0.5, animations: {
            self.selectionBtnsViewHeightConstant.constant = 47
            self.nearByFieldsBtn.backgroundColor = Constants.Colors.red
            self.bookedFieldsBtn.backgroundColor = Constants.Colors.gray
            self.view.layoutIfNeeded()
        })
    }
    // MARK: GetLocation
    
    func setupLocationM() {
        
        locationManager.delegate = self

        if CLLocationManager.authorizationStatus() == .notDetermined {
            self.locationManager.requestWhenInUseAuthorization()
        }
        locationManager.distanceFilter = kCLDistanceFilterNone
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()

//        if (CLLocationManager.locationServicesEnabled())
//        {
//            locationManager.delegate = self
//            locationManager.desiredAccuracy = kCLLocationAccuracyBest
//            if ((UIDevice.current.systemVersion as NSString).floatValue >= 8)
//            {
//                locationManager.requestWhenInUseAuthorization()
//            }
//            
//            locationManager.startUpdatingLocation()
//        }
//        else
//        {
//            #if debug
//                println("Location services are not enabled");
//            #endif           
//        }
    }
    
//    func locationManager(manager: CLLocationManager!, didFailWithError error: NSError!)
//    {
//        locationManager.stopUpdatingLocation()
//        if ((error) != nil)
//        {
//            print(error)
//        }
//    }
//    
//    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!)
//    {
//        let locationArray = locations as NSArray
//        let locationObj = locationArray.lastObject as! CLLocation
//        let coord = locationObj.coordinate
//        print(coord.latitude)
//        print(coord.longitude)
//        
//    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let userLocation:CLLocation = locations[0] as CLLocation // note that locations is same as the one in the function declaration
        
        print("that's the user Location : \(userLocation.coordinate.latitude), \(userLocation.coordinate.longitude)")
        userLat = "\(userLocation.coordinate.latitude)"
            userLong = "\(userLocation.coordinate.longitude)"
        manager.stopUpdatingLocation()
        getNearByFieldsData()
//        let coordinations = CLLocationCoordinate2D(latitude: userLocation.coordinate.latitude,longitude: userLocation.coordinate.longitude)

        
        
    }
    
    
    func getNearByFieldsData() {
        
        guard let lat = userLat, let long = userLong else {
            return
        }
        playGroudModel = GetPlayGroundsData()
        playGroudModel.getNearByFields(lat: lat, long: long) {[weak self ] (data, sms, state) in
            
            if state {
                guard let data = data else { return }
                self?.nearFieldsData = data
            }else {
                
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
