//
//  PlayFieldsVC.swift
//  Elmla3eb
//
//  Created by Macbook Pro on 3/23/17.
//  Copyright © 2017 Killvak. All rights reserved.
//

import UIKit
import CoreLocation

class PlayFieldsVC: ToSideMenuClass, CLLocationManagerDelegate {
    
    @IBOutlet weak var searchBarText: UISearchBar!
    @IBOutlet weak var confirmedBtn: UIButton!
    @IBOutlet weak var bookedFieldsBtn: UIButton!
    @IBOutlet weak var unconfirmedBtn: UIButton!
    @IBOutlet weak var nearByFieldsBtn: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var selectionBtnsViewHeightConstant: NSLayoutConstraint!
    @IBOutlet weak var emptyDataLabel: UILabel!
    @IBOutlet weak var activityIndector: UIActivityIndicatorView!
    
    var servicesCount = 0 {
        didSet {
            if servicesCount >= 2 {
                self.view.squareLoading.stop(0)
            }
        }
    }
    var buttonTag : Int = 0
    var locationManager = CLLocationManager()
    var userLat : String?
    var userLong : String?
    var nearFieldsData : [NearByFields_Data]?{
        didSet {
//            print("that's the data : \(nearFieldsData)")
            nearFieldsSelected()
            tableView?.reloadData()
        }
    }
    
    lazy  var deletereservation = ReservationModel()
    var reservationsArray = ConfirmedOrNotData()
    
    var confirmedP_G : [ConfirmedFields_Data]?{
        didSet {
            tableView?.reloadData()
        }
    }
    var unconfirmedP_G : [NotConfirmedFields_Data]?{
        didSet {
            tableView?.reloadData()
        }
    }
    var playGroudModel : GetPlayGroundsData!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.squareLoading.start(0)

        navigationItem.leftBarButtonItem?.isEnabled = false
        //        self.menuBtn.isEnabled = false
        navigationItem.leftBarButtonItem?.image = UIImage(named: "")
        
        tableView.delegate = self
        tableView.dataSource = self
        setupLocationM()
        
        let nib = UINib(nibName: "FieldsCell", bundle: nil)
        
        tableView.register(nib, forCellReuseIdentifier: "cell")
        // Do any additional setup after loading the view.
        //        let tapped = UITapGestureRecognizer(target: self, action: #selector(self.closekeyBoard(_:)))
        //
        //        self.view.addGestureRecognizer(tapped)
        
        reservationAPI()
        
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
    
    
    func reservationAPI() {
        reservationsArray.getPGReservationStatus { [weak self]  (data, sms, state) in
            
//            print("that's the data \(data)")
            guard state else { self?.servicesCount += 1;return }
            self?.confirmedP_G = data?.confirmed
            self?.unconfirmedP_G = data?.not_confirmed
            DispatchQueue.main.async {
                self?.navigationItem.leftBarButtonItem?.isEnabled = true
                self?.navigationItem.leftBarButtonItem?.image = UIImage(named: "Menu_Btn")
                self?.servicesCount += 1
                
            }
        }
    }
    
    override func toSidemenuVC() {
        super.toSidemenuVC()
        ad.sideMenuTrigger(self,"NearBy")
    }
    //    func closekeyBoard(_ tapped : UITapGestureRecognizer) {
    //
    //        view.endEditing(true)
    //    }
    
    
    @IBAction func typeOfFieldsBtnsAction(_ sender: UIButton) {
        
        guard sender.tag != self.buttonTag else { return }
        if sender.tag == 0 {
            
        }else if sender.tag == 1 {
            
        }
        self.buttonTag = sender.tag
//        print("that's button tag : \(self.buttonTag) ")
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
        //        animateTableView()
        
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
        
        if CLLocationManager.locationServicesEnabled() {
            switch(CLLocationManager.authorizationStatus()) {
            case  .notDetermined :
                print("Not  .notDetermined")
                   self.locationManager.requestWhenInUseAuthorization()
            case .restricted, .denied:
//                print("No access")
                servicesCount += 1
            case .authorizedAlways, .authorizedWhenInUse:
                print("Access")
            }
        } else {
//            print("Location services are not enabled")
        }
        
        
//        if CLLocationManager.authorizationStatus() == .notDetermined {
//         
//        }else {
//            servicesCount += 1
////            print("2- Location services are not enabled")
//            
//        }
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
        
        //        print("that's the user Location : \(userLocation.coordinate.latitude), \(userLocation.coordinate.longitude)")
        userLat = "\(userLocation.coordinate.latitude)"
        userLong = "\(userLocation.coordinate.longitude)"
        manager.stopUpdatingLocation()
        getNearByFieldsData()
        //        let coordinations = CLLocationCoordinate2D(latitude: userLocation.coordinate.latitude,longitude: userLocation.coordinate.longitude)
        
        
        
    }
    
    
    func getNearByFieldsData() {
        
        guard let lat = userLat, let long = userLong else {
            self.servicesCount += 1
            return
        }
        playGroudModel = GetPlayGroundsData()
        playGroudModel.getNearByFields(lat: lat, long: long) {[weak self ] (data, sms, state) in
            
            if state {
                guard let data = data else { DispatchQueue.main.async {
                    self?.servicesCount += 1
                    }; return }
                self?.nearFieldsData = data
                self?.servicesCount += 1
            }else {
                self?.servicesCount += 1
            }
        }
        
    }
 
 
    
}

extension PlayFieldsVC : ViewPlayFeildVCDelegate_updateUnconfirmedList {
    
    func fetchPlay_gData() {
         reservationAPI()
    }
    
}
