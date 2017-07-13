//
//  ViewPlayFeildVC.swift
//  Elmla3eb
//
//  Created by Macbook Pro on 3/26/17.
//  Copyright © 2017 Killvak. All rights reserved.
//

import UIKit
import CDAlertView
import Alamofire
import AlamofireImage

import MapKit
class PlaygroundDBData {
    var  name = ""
    var address = ""
   var booksTimes = ""
    var price = ""
    var originalPrice = 0
    var numOfFields = ""
    var type = ""
    var ball = false
    var light = false
}

protocol ViewPlayFeildVCDelegate_updateUnconfirmedList : class {
    func fetchPlay_gData()
}
class ViewPlayFeildVC: UIViewController , UITableViewDelegate,UITableViewDataSource  {
    
    @IBOutlet weak var bookNowDoneBtn: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var noNewsLbl: UILabel!
    @IBOutlet weak var view1FirstLbl: UILabel!
    @IBOutlet weak var view1SecLbl: UILabel!
    @IBOutlet weak var newsTableView: UITableView!
    @IBOutlet weak var view2FirstLbl: UILabel!
    @IBOutlet weak var view2SecLbl: UILabel!
    @IBOutlet weak var view3FirstLbl: UILabel!
    @IBOutlet weak var view3SecLbl: UILabel!
    @IBOutlet weak var view4FirstLbl: UILabel!
    @IBOutlet weak var view4SecLbl: UILabel!
    @IBOutlet weak var detailsBtn: UIButton!
    @IBOutlet weak var detailsBtnLine: UIView!
    @IBOutlet weak var infoBtn: UIButton!
    @IBOutlet weak var infoBtnLine: UIView!
    @IBOutlet weak var datesBtn: UIButton!
    @IBOutlet weak var datesBtnLine: UIView!
    @IBOutlet weak var newsBtn: UIButton!
    @IBOutlet weak var newsBtnLine: UIView!
    @IBOutlet weak var newsView: UIView!
    @IBOutlet weak var labelsDataView: UIView!
    @IBOutlet weak var bookNowView: UIView!
    @IBOutlet weak var footballAvailabilityImage: UIImageView!
    @IBOutlet weak var fieldLightingAvailabilityImage: UIImageView!
    @IBOutlet weak var pagerNilDataPlaceHolder: UIImageView!
    
    @IBOutlet weak var bookNowBtnBottomConstant: NSLayoutConstraint!
    @IBOutlet weak var pagerView: UIView!
    
    @IBOutlet weak var pageControl: UIView!
    
    @IBOutlet weak var hoursStackView: UIStackView!
    @IBOutlet weak var newStackView: UIStackView!
    @IBOutlet weak var mainControllerStackView: UIStackView!
    
    // Owner Change Data Storage
    lazy var  ownerDataDict = [String : String]()
    //
    var bookNowDays = [String]()
    //Owner Vars
    var price : Int?
    var isOwnerEditing = false
    var bookNowCellTrigger = false
    var isOwner  =  false  {
        didSet {
            if isOwner {
                bookNowDoneBtn?.isEnabled = false
                bookNowDoneBtn?.alpha = 0
            }
        }
    }
    
    weak var delegate : ViewPlayFeildVCDelegate_updateUnconfirmedList?
    var haveBall : Bool = false
    var haveLighting :Bool = false
    //@end owner var
    var bookNowTimes = [Pg_Times_Data]()
    var imagesStringList : [String]! {
        didSet{
            setUpPager()
        }
    }
    
    var pg_title = " "{
        didSet {
            title = pg_title
        }
    }
    var globalClass : GLOBAL!
    var pagerCont = FSPageControl()
    
    var semiDBData = PlaygroundDBData()
    let textList = ["1","2","3","4"]
    var pg_id : Int?
    var times_msg : String?
    static var seletedTimes_ID = [Int]()
    var newsList : [String]?{
        didSet {
            guard let data = newsList , data.count > 0 else{
//                print("Empty News Data")
                self.newsTableView?.alpha = 0
                self.noNewsLbl.alpha = 1
                return
            }
            self.newsTableView?.alpha = 1
            self.noNewsLbl.alpha = 0
        }
    }
    weak var delegatee : pagerTappeingControll?
    
    let pfInfo = GetpgInfosWebServ()
    var indexIs : Int?
    var playFieldInfo : PlayGroundsInfoSubData?
    fileprivate var theView : UIView!
    fileprivate var theCurBtn : UIButton!
    fileprivate var CurrBtnLine : UIView!
    var originalBottomConstant : CGFloat?
    
    var pgInfo : Pg_Info_Data?
    var pgDetails : Pg_Details_Data?
    let pf_Info = GetpgInfosWebServ()
    
    var lat : Double?
    var long : Double?
    
    lazy var bookNowTableChildView  : BookNowTablesVC = {
        let storyb = UIStoryboard(name: "Main", bundle: Bundle.main)
        let vc = storyb.instantiateViewController(withIdentifier: "BookNowTablesVC") as! BookNowTablesVC
        vc.pg_ID = self.pg_id
        vc.times_msg = self.times_msg
        vc.dayAvailable = self.bookNowDays
        vc.times = self.bookNowTimes
        vc.isOwner = self.isOwner
        self.setupChildView(vc)
        return vc
    }()
    //Owner Vars
    
    //
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        print("that is the pg_id : \(pg_id)")
        navigationController?.navigationBar.topItem?.title = ""
        pagerNilDataPlaceHolder.alpha = 1

        self.view.squareLoading.start(0.0)
        newsTableView.delegate = self
        newsTableView.dataSource = self
        // Do any additional setup after loading the view.
        newsTableView.estimatedRowHeight = 35
        newsTableView.rowHeight = UITableViewAutomaticDimension
        theView = labelsDataView
        theCurBtn = detailsBtn
        CurrBtnLine = detailsBtnLine
        self.originalBottomConstant = self.bookNowBtnBottomConstant.constant
        
        
        //        self.setLabelsTitle()
        
        self.theView = self.labelsDataView
        self.theView.accessibilityIdentifier = "labelsDataView"
        self.theCurBtn = detailsBtn
        self.CurrBtnLine = detailsBtnLine
        self.setPlaygDetails()
        
        activityIndicator.layer.cornerRadius = 1
        
        
        if let userType = UserDefaults.standard.value(forKey: "User_Type") as? String  , userType == "pg_owner" {
            isOwner = true
            
        }else {
            isOwner = false
        }
        
        if isOwnerEditing {
            bookNowDoneBtn.isEnabled = true
            bookNowDoneBtn.alpha = 1
            self.bookNowDoneBtn.setTitle(langDicClass().getLocalizedTitle("Save"), for: .normal)
            mainControllerStackView?.removeArrangedSubview(hoursStackView)
            hoursStackView?.removeFromSuperview()
            mainControllerStackView?.removeArrangedSubview(newStackView)
            newStackView?.removeFromSuperview()
        } else {
            self.bookNowDoneBtn.setTitle(langDicClass().getLocalizedTitle("Book Field Now"), for: .normal)
        }
        
        
 

    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        ViewPlayFeildVC.seletedTimes_ID = []
        if L102Language.currentAppleLanguage() == "ar" {
            self.view1SecLbl.textAlignment = .left
            self.view2SecLbl.textAlignment = .left
            self.view3SecLbl.textAlignment = .left
            self.view4SecLbl.textAlignment = .left
            
        }

    //    self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil)

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        guard let id = self.pg_id else {
//            print("error with pg_id == nil : \(self.pg_id)");
            ad.userOffline(self); return }
        pf_Info.getPgInfosByID(id: id) { [weak weakSelf = self ](dataOBject) in
            
            //            print("that is arabic sentince : \(data)")
            guard let data = dataOBject else {
//                print("GetPgInfosByID equal NIL ç≈Ωß")
                ad.userOffline(self)
                return
            }
            weakSelf?.pgDetails = data.details
            weakSelf?.pgInfo = data.info
            weakSelf?.times_msg = data.info?.times_msg
            if let detailss = data.details , let infoo = data.info {
            weakSelf?.semiDBData.name =  detailss.pgName
            weakSelf?.semiDBData.address =  detailss.address
            weakSelf?.semiDBData.booksTimes =  "\(detailss.pgBookingTimes)"
            weakSelf?.semiDBData.price =  detailss.price
                weakSelf?.semiDBData.originalPrice = detailss.originalPrice
            weakSelf?.semiDBData.numOfFields =  "\(infoo.pgNumbersOfFeilds)"
            weakSelf?.semiDBData.type =  infoo.groundType
                weakSelf?.semiDBData.ball =  infoo.footballAvailable
                weakSelf?.semiDBData.light =  infoo.lightAvailable
              
                weakSelf?.lat = detailss.lat
                weakSelf?.long = detailss.lang

            }
//            print("that is  weakSelf? \n .times_msg : \(weakSelf?.times_msg )")
            
            //News
            if let newsData = data.news {
                weakSelf?.newsList = [String]()
                for news in newsData {
                    weakSelf?.newsList?.append(news.title)
//                    print("news.title : \(news.title)")
                    
                }
                DispatchQueue.main.async {
                    weakSelf?.newsTableView.reloadData()
                }
            }
            //@end News
            
            //MARK:  @Pager
            if let imgData = data.images ,imgData.count > 0 {
                var imageS = [String]()
//                print("that's the returned data : \(imgData)")
                for imageString in imgData  {
                    imageS.append(imageString.image)
                    
                }
                DispatchQueue.main.async {
                    weakSelf?.imagesStringList = imageS
                    weakSelf?.pagerNilDataPlaceHolder.alpha = 0
                }
            }else {
                DispatchQueue.main.async {
                    weakSelf?.pagerNilDataPlaceHolder.alpha = 1
                }
            }
            //@end Pager
            
            weakSelf?.setPlaygDetails()
            
            weakSelf?.view.squareLoading.stop(0.0)
            weakSelf?.setUpMapNavData()
//            print("that is times : \(data.times)")
            guard let times = data.times else { return }
            //            weakSelf?.bookNowDays = [String]()
            //            weakSelf?.bookNowTimes = [Pg_Times_Data]()
            for x in times {
                weakSelf?.bookNowDays.append(x.date)
//                print("that is am_class \(x.am_class)")
//                print("that is pm_class \(x.pm_class)")
//                print("that is day \(x.date)")
//                
            }
//            print("that is all day \(weakSelf?.bookNowDays)")
            weakSelf?.bookNowTimes = times
            
            //            self.playFieldInfo = data
            //            print("that is the data : \(self.playFieldInfo?.pg_id) , \(self.playFieldInfo?.light_available) , \(self.playFieldInfo?.ground_type)")
             DispatchQueue.main.async {
            if let x = weakSelf?.bookNowCellTrigger , x {
                weakSelf?.activityIndicator.startAnimating()
                weakSelf?.view.isUserInteractionEnabled = false
                weakSelf?.vanisher()
                
                weakSelf?.theView = weakSelf?.bookNowView
                //            self.theView.accessibilityIdentifier = "bookNowView"
                weakSelf?.bookNowTableChildView.view.isHidden =  false
                weakSelf?.theCurBtn = weakSelf?.datesBtn
                weakSelf?.CurrBtnLine = weakSelf?.datesBtnLine
                weakSelf?.animateDefaultView()
                weakSelf?.activityIndicator.stopAnimating()
                weakSelf?.view.isUserInteractionEnabled = true
            }
            }
        }
        

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        ViewPlayFeildVC.seletedTimes_ID = []
    }////
    deinit {
        ViewPlayFeildVC.seletedTimes_ID = []
    }
    
    
    
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let count = newsList?.count else { return 0 }
        return count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "newsCell", for: indexPath) as! ViewPlayFNewsCell
        guard let data = newsList else { return cell }
        cell.newsLbl.text = data[indexPath.row]
        return cell
    }
    
    @IBAction func controllBtnsAct(_ sender: UIButton) {
        if isOwnerEditing , sender.tag == 2 || sender.tag == 3 {
            return
        }
        
        self.vanisher()
        switch sender.tag {
        case 0: //Details
//            print(sender.tag)
            self.theView = self.labelsDataView
            self.theView.accessibilityIdentifier = "labelsDataView"
            self.theCurBtn = detailsBtn
            self.CurrBtnLine = detailsBtnLine
            self.setPlaygDetails()
            //            if isOwner {
            //                self.view3SecLbl.isEnabled = false
            //                self.view4SecLbl.isEnabled = true
        //            }
        case 1: //AboutField
//            print(sender.tag)
            self.theView = self.labelsDataView
            self.theView.accessibilityIdentifier = "labelsDataView2"
            self.theCurBtn = infoBtn
            self.CurrBtnLine = infoBtnLine
            self.setPlaygDetails()
            //            if isOwner {
            //                self.view1SecLbl.isEnabled = false
            //                self.view3SecLbl.isEnabled = false
            //                self.view4SecLbl.isEnabled = false
        //            }
        case 2:  //Hours
//            print(sender.tag)
            self.theView = self.bookNowView
            //            self.theView.accessibilityIdentifier = "bookNowView"
            self.bookNowTableChildView.view.isHidden =  false
            self.theCurBtn = datesBtn
            self.CurrBtnLine = datesBtnLine
        default:  // Latest News
//            print(sender.tag)
            self.theView = self.newsView
            self.theView.accessibilityIdentifier = "newsView"
            self.theCurBtn = newsBtn
            self.CurrBtnLine = newsBtnLine
        }
        animateDefaultView()
        
    }
    
    @IBAction func bookNowBtnAct(_ sender: UIButton? = nil    ) {
       
        guard !isOwnerEditing else {
            
//            print(("tbhat's the changed value : price : \(price ?? 0) , hasball \(haveBall ? 1 : 0)  haslight \(haveLighting ? 1 : 0):"))
            self.activityIndicator.startAnimating()
            let editPG = GetPlayGroundsData()
            guard let pgId = pg_id, let name = ownerDataDict["name"], let address = ownerDataDict["address"]/*, let price = price*/, let type = ownerDataDict["type"] else {
                self.activityIndicator.stopAnimating()
                ad.showAlert("default","")
                return
            }
            editPG.putEdit_Playground(pg_id: pgId, pg_name: name, address: address, price: semiDBData.originalPrice, ground_type: type, light_available: haveLighting ? "1" : "0" , football_available: haveBall ? "1" : "0", completed: { [weak self] (state,sms) in
                guard state else { ad.showAlert("X", sms); return }
                let alert = CDAlertView(title: langDicClass().getLocalizedTitle("Done"), message: langDicClass().getLocalizedTitle(""), type: .success)
                
                DispatchQueue.main.async {
                    self?.activityIndicator.stopAnimating()
                    alert.show()
                }
                
            })
            
            return
        }
        //BookNow // Player
        let userStates = ad.isUserLoggedIn()
        guard userStates else {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
            self.present(vc, animated: true, completion: nil)
            return
        }
        if theCurBtn != datesBtn {
            vanisher()
            self.theView = self.bookNowView
            //            self.theView.accessibilityIdentifier = "bookNowView"
            self.bookNowTableChildView.view.isHidden =  false
            self.theCurBtn = datesBtn
            self.CurrBtnLine = datesBtnLine
            animateDefaultView()
        }else {
            if ViewPlayFeildVC.seletedTimes_ID.count > 0 {
                view.isUserInteractionEnabled = false
                activityIndicator.startAnimating()
                sender?.isEnabled = false
                sender?.alpha = 0.5
//                print("that's the selected dataes ID : \(ViewPlayFeildVC.seletedTimes_ID)")
                guard let pgID = pg_id else {
//                    print("pg_id is Equal to NIL \(pg_id)")
                    return }
                pf_Info.postBookDate(pg_Id : pgID , reservationArray: ViewPlayFeildVC.seletedTimes_ID, completed: { [weak self ](isIt) in
                    
                    if isIt {
                        let alert = CDAlertView(title: langDicClass().getLocalizedTitle("Done"), message: langDicClass().getLocalizedTitle("You have Booked This Field waiting for approval"), type: .success)
                        
                        DispatchQueue.main.async {
                            self?.callUnconfirmedDelegation()
                            alert.isUserInteractionEnabled = false
                            self?.activityIndicator.stopAnimating()
                            alert.show()

                                                    }
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                            alert.hide(animations: nil, isPopupAnimated: true )
                            self?.navigationController?.popViewController(animated: true )
                            
                        }
                    }else {
                        let alert = CDAlertView(title: langDicClass().getLocalizedTitle("Something Went Wrong"), message: langDicClass().getLocalizedTitle("try again!!"), type: .error)
                        
                        DispatchQueue.main.async {
                            alert.show()
                            self?.activityIndicator.stopAnimating()
                            self?.view.isUserInteractionEnabled = true
                            sender?.isEnabled = true
                            sender?.alpha = 1
                            self?.navigationController?.popViewController(animated: true )
                        }
                    }
                    
                })
            }else { //no data in array
//                print("day arary :\(bookNowDays) \(bookNowDays.count)")
                var sms  = "You didn't pick Booking Date"
                if bookNowDays.count < 1 {
                    sms = "There's no Dates to pick"
                }
                let alert = CDAlertView(title: langDicClass().getLocalizedTitle("Something Went Wrong"), message: langDicClass().getLocalizedTitle(sms), type: .error)
                alert.show()
                
            }
            
        }
        
        
        
    }
    
    func callUnconfirmedDelegation() {
        let n = self.navigationController?.viewControllers.count
        if let navCount = n ,let _ = self.navigationController?.viewControllers[navCount-2] as? PlayFieldsVC {
            print("PlayField view i s the prev one ")
            delegate?.fetchPlay_gData()
        }
    }
    
    func setPlaygDetails() {
        
       
        haveBall =  semiDBData.ball
        haveLighting = semiDBData.light
        price = semiDBData.originalPrice
        ownerDataDict["name"] = semiDBData.name
        ownerDataDict["address"] = semiDBData.address
        ownerDataDict["type"] = semiDBData.type
        if title == nil || title == "" || title == " " { title = semiDBData.name }
        
        setLabelsTitle(fieldName: semiDBData.name, address: semiDBData.address, booksTimes: semiDBData.booksTimes, price: semiDBData.price, numberOfFields: semiDBData.numOfFields, fieldType: semiDBData.type, hasBall: haveBall, hasLight: haveLighting)
    }
    
    func vanisher()  {
        
        //        self.newsView.alpha = 0
        //        self.bookNowView.alpha = 0
        //        self.labelsDataView.alpha = 0
        
        UIView.animate(withDuration: 0.3, animations: {
            self.theView.alpha = 0
            self.theCurBtn.setTitleColor(Constants.Colors.lightGray, for: .normal)
            self.CurrBtnLine.backgroundColor = Constants.Colors.lightGray
            guard !self.isOwnerEditing else { return }
            //            if self.theCurBtn == self.newsBtn    {
            //                self.bookNowBtnBottomConstant.constant = self.originalBottomConstant!
            //                //                self.bookNowDoneBtn.alpha = 0
            self.bookNowBtnBottomConstant.constant = self.originalBottomConstant!
            
        })
        //         }) { (true) in
        //            if self.isOwner  , !self.isOwnerEditing{
        //                if self.theCurBtn == self.datesBtn    {
        //                    guard let const = self.originalBottomConstant else { return }
        //                    self.bookNowBtnBottomConstant.constant = const
        //                }
        //            }
        //        }
    }
    
    func animateDefaultView() {
        
        //        print("that is the view : \(self.theView.accessibilityIdentifier)")
        UIView.animate(withDuration: 0.3 , animations: {
            self.theView.alpha = 1
            
            self.theCurBtn.setTitleColor(Constants.Colors.green, for: .normal)
            self.CurrBtnLine.backgroundColor = Constants.Colors.green
            guard !self.isOwnerEditing else { return }
            if self.theCurBtn == self.newsBtn {
                self.bookNowBtnBottomConstant.constant -=  self.bookNowDoneBtn.bounds.height
            }
            if self.isOwner {
                if self.theCurBtn == self.datesBtn    {
                    self.bookNowBtnBottomConstant.constant -=  self.bookNowDoneBtn.bounds.height + 3
                    self.view.layoutIfNeeded()
                }
            }
            self.view.layoutIfNeeded()

        })
//        { (true) in
////            if self.isOwner  , !self.isOwnerEditing{
////                if self.theCurBtn == self.datesBtn    {
////                    self.bookNowBtnBottomConstant.constant +=  self.bookNowDoneBtn.bounds.height * 2
////                }}
////
//            UIView.animate(withDuration: 0.2 , animations: {
//                if self.isOwner  , !self.isOwnerEditing{
//                    if self.theCurBtn == self.datesBtn    {
//                        self.bookNowBtnBottomConstant.constant -=  self.bookNowDoneBtn.bounds.height
//                        self.view.layoutIfNeeded()
//                    }
//                }
//            })
//        }
    }
    
    func  animateView(view : UIView!) {
        UIView.animate(withDuration: 0.5, animations: {
            view.alpha = 1
        })
    }
    
    
    func getPlayGroundDirections() {
        //Defining destination
        guard let latitude = lat ,latitude != 0.0  , let longitude = long , longitude != 0.0 else {
            ad.showAlert("X" , langDicClass().getLocalizedTitle("This Field Doesn't Support This Feature"))
            return
        }
        
        let regionDistance:CLLocationDistance = 1000;
        let coordinates = CLLocationCoordinate2DMake(latitude, longitude)
        let regionSpan = MKCoordinateRegionMakeWithDistance(coordinates, regionDistance, regionDistance)
        
        let options = [MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: regionSpan.center), MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: regionSpan.span)]
        
        var placemark : MKPlacemark?
        if #available(iOS 10.0, *) {
            placemark = MKPlacemark(coordinate: coordinates)
        } else {
            // Fallback on earlier versions
            placemark = MKPlacemark(coordinate: coordinates, addressDictionary: nil)
        }
        guard let pm = placemark else { return }
        let mapItem = MKMapItem(placemark: pm)
        if let txt = title , !txt.isEmpty {
            mapItem.name = txt
        }
        mapItem.openInMaps(launchOptions: options)
    }
    
    
    func setLabelsTitle(fieldName:String,address:String,booksTimes:String,price:String,numberOfFields:String,fieldType:String,hasBall:Bool,hasLight:Bool) {
        
        if self.theCurBtn == detailsBtn {
            self.footballAvailabilityImage.alpha = 0 ; self.fieldLightingAvailabilityImage.alpha = 0
            self.view1FirstLbl.text =  langDicClass().getLocalizedTitle("Field Name:")
            self.view1SecLbl.text = fieldName
            
            self.view2FirstLbl.text =  langDicClass().getLocalizedTitle("address:")
            self.view2SecLbl.text = address
            
            self.view3FirstLbl.text =  langDicClass().getLocalizedTitle("books Times: ")
            self.view3SecLbl.text = booksTimes
            
            self.view4FirstLbl.text =  langDicClass().getLocalizedTitle("Price for hour: ")
            self.view4SecLbl.text = price
        }else  {
            
            self.view1FirstLbl.text =  langDicClass().getLocalizedTitle("Num of Fields: ")
            self.view1SecLbl.text = numberOfFields
            
            self.view2FirstLbl.text =  langDicClass().getLocalizedTitle("Field Type: ")
            self.view2SecLbl.text = fieldType
            
            self.view3FirstLbl.text =  langDicClass().getLocalizedTitle("Ball: ")
            self.view3SecLbl.text = ""
            
            
            self.view4FirstLbl.text =  langDicClass().getLocalizedTitle("field Lighting: ")
            self.view4SecLbl.text = ""
            
            
            if hasBall {
                self.fieldLightingAvailabilityImage.image = UIImage(named: "true_icon")
            }else {
                self.footballAvailabilityImage.image = UIImage(named: "faulse_icon")
            }
            if hasLight {
                self.fieldLightingAvailabilityImage.image = UIImage(named: "true_icon")
            }else {
                self.footballAvailabilityImage.image = UIImage(named: "faulse_icon")
            }
            
            self.fieldLightingAvailabilityImage.alpha = 1
            self.footballAvailabilityImage.alpha = 1
        }
        
    }
    
    
    func setupChildView(_ vc : UIViewController) {
        self.addChildViewController(vc)
        vc.view.frame = CGRect(x: 0, y: 0, width: self.bookNowView.frame.size.width, height: self.bookNowView.frame.size.height )
        self.bookNowView.addSubview(vc.view)
        vc.didMove(toParentViewController: vc)
    }
    
    
    func setUpMapNavData() {
               navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named:"NavToMap"), style: .plain, target: self, action: #selector(getPlayGroundDirections))
    }

    
    
}

//Owner
extension ViewPlayFeildVC {
    
    
    //MARK: Owner set new data
    @IBAction func ownerChangeValue(_ sender: UIButton) {
        guard isOwnerEditing else { return }
        
        switch sender.tag {
            
        case 0 :
            if theCurBtn == detailsBtn {
                presentAlert(langDicClass().getLocalizedTitle("Enter Field Name"), "", langDicClass().getLocalizedTitle("Field Name"), view1SecLbl)
            }
        case 1 :
            if theCurBtn == detailsBtn {//Details * FieldName, address Books Times , price
                presentAlert(langDicClass().getLocalizedTitle("Enter Address"), "", langDicClass().getLocalizedTitle("Address"), view2SecLbl)
            }else {//AboutField - Number of Fields X, Fields Type √
                presentAlert(langDicClass().getLocalizedTitle("Enter Field Type"), "", langDicClass().getLocalizedTitle("Field Type"), view2SecLbl)
            }
        case 2 :
            if theCurBtn == detailsBtn {//AboutField - Number of Fields X, Fields Type √
                //                presentAlert("Enter Address", "", "Address", view2SecLbl)
            }else {
                if !haveBall {
                    self.footballAvailabilityImage.image = UIImage(named: "true_icon")
                    semiDBData.ball = true
                }else {
                    self.footballAvailabilityImage.image = UIImage(named: "faulse_icon")
                    semiDBData.ball = false
                }
                haveBall = !haveBall
            }
        default :
            if theCurBtn == detailsBtn {
                presentAlert(langDicClass().getLocalizedTitle("Enter Price for Hour"), "", langDicClass().getLocalizedTitle("Price"), view4SecLbl)
            }else {
                
                if !haveLighting {
                    self.fieldLightingAvailabilityImage.image = UIImage(named: "true_icon")
                    semiDBData.light = true
                }else {
                    self.fieldLightingAvailabilityImage.image = UIImage(named: "faulse_icon")
                    semiDBData.light = false
                }
                haveLighting = !haveLighting
            }
        }
    }
    
    
    func presentAlert(_ title : String,_ sms : String,_ placeHolder : String,_ label : UILabel) {//"Please input your email:"
        let alertController = UIAlertController(title: title, message: sms, preferredStyle: .alert)
        
        let confirmAction = UIAlertAction(title: langDicClass().getLocalizedTitle("Confirm"), style: .default) { [weak self] (_) in
            if let field = alertController.textFields?[0] , let txt = field.text ,!txt.isEmpty {
                // store your data
                //                    UserDefaults.standard.synchronize()
                guard  !txt.hasSuffix(" ") else {
                    ad.showAlert("X", langDicClass().getLocalizedTitle("Text Shouldn't Contain White Spaces"))

                    return }

         
                
                if placeHolder == langDicClass().getLocalizedTitle("Price") {
                    guard txt.ispriceValue else { ad.showAlert("X", langDicClass().getLocalizedTitle("price has to be only written in numbers"))
                        return  }
                    label.text = txt + " \(langDicClass().getLocalizedTitle(" SAR"))"
                    self?.price = Int(txt)
                    self?.semiDBData.price = txt + " \(langDicClass().getLocalizedTitle(" SAR"))"
                    self?.semiDBData.originalPrice = self?.price ?? 0
                }else{
                    label.text = txt
                }
                if placeHolder == langDicClass().getLocalizedTitle("Address") {
                    self?.ownerDataDict["address"] = txt
                    self?.semiDBData.address = txt
                }else  if placeHolder == langDicClass().getLocalizedTitle("Field Type") {
                    self?.ownerDataDict["type"] = txt
                    self?.semiDBData.type = txt
                }else if placeHolder == langDicClass().getLocalizedTitle("Field Name") {
                    self?.ownerDataDict["name"] = txt
                    self?.semiDBData.name = txt
                }
            } else {
                // user did not fill field
            }
        }
        
        let cancelAction = UIAlertAction(title: langDicClass().getLocalizedTitle("Cancel"), style: .cancel) { (_) in }
        
        alertController.addTextField { [weak self] (textField) in
            textField.placeholder = placeHolder
            if label == self?.view4SecLbl {
                textField.keyboardType = .numberPad
            }
        }
        
        
        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
}











extension ViewPlayFeildVC : FSPagerViewDelegate , FSPagerViewDataSource{
    
    public func numberOfItems(in pagerView: FSPagerView) -> Int {
        return imagesStringList.count
    }
    
    public func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        let cell = pagerView.dequeueReusableCell(withReuseIdentifier: "cell", at: index)
        //        cell.imageView?.image = imagesList[index]
        //        cell.imageView?.contentMode = .scaleAspectFill
        
        cell.imageView?.af_setImage(
            withURL: URL(string: imagesStringList[index] )!,
            placeholderImage: UIImage(named: "courtplaceholder_3x"),
            filter: nil,
            imageTransition: .crossDissolve(0.2)
        )
        return cell
    }
    
    
    func pagerView(_ pagerView: FSPagerView, didSelectItemAt index: Int) {
        pagerView.deselectItem(at: index, animated: true)
//        print("that is the item number in Header : \(pagerView.currentIndex) ")
        self.delegatee?.didSelectImageAt(index: pagerView.currentIndex)
    }
    
    // MARK:- FSPagerViewDelegate
    func pagerViewDidScroll(_ pagerView: FSPagerView) {
        guard self.pagerCont.currentPage != pagerView.currentIndex else {
            return
        }
        self.pagerCont.currentPage = pagerView.currentIndex // Or Use KVO with property "currentIndex"
        //        self.fieldPagerLbl.text = self.textList[pagerView.currentIndex]
    }
    
    func setUpPager() {
        
        let pagerViewx = FSPagerView(frame: self.pagerView.frame)
        pagerViewx.dataSource = self
        pagerViewx.delegate = self
        pagerViewx.register(FSPagerViewCell.self, forCellWithReuseIdentifier: "cell")
        //        self.pagerView.addSubview(pagerView)
        pagerViewx.isInfinite = true
        pagerViewx.automaticSlidingInterval = 4.5
        
        pagerCont = FSPageControl(frame: self.pageControl.frame)
        pagerCont.setStrokeColor(.green, for: .normal)
        pagerCont.setStrokeColor(.green, for: .selected)
        pagerCont.setFillColor(.green, for: .selected)
        pagerCont.numberOfPages = imagesStringList.count
        pagerCont.contentHorizontalAlignment = .center
        pagerCont.contentInsets = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        
        pagerViewx.addSubview(pagerCont)
        view.addSubview(pagerViewx)
    }
    
    
  
    
}


//extension ViewPlayFeildVC : UITextFieldDelegate {
//
//
//    func setupTextFieldDelegate() {
//
//        self.view1SecLbl.delegate = self
//         self.view2SecLbl.delegate = self
//         self.view3SecLbl.delegate = self
//         self.view4SecLbl.delegate = self
//    }

//    func textFieldDidEndEditing(_ textField: UITextField) {
//        
//    
//        
//    }
//    func textFieldDidEndEditing(_ textField: UITextField) {
//        switch textField {
//        case view1SecLbl://FieldName //Number of fields
//            print("that's the view1SecLbl text : \(textField.text)")
//        case view2SecLbl://Address // FieldType
//            print("that's the view2SecLbl text : \(textField.text)")
//        case view3SecLbl://BooksTimes // Ball
//            print("that's the view3SecLbl text : \(textField.text)")
//
//        default: //Price // Lighting
//            print("that's the view4SecLbl text : \(textField.text)")
//            if let  text = textField.text ,!text.isEmpty  {
//                textField.text = text + " SAR"
//            } else {
//                textField.text = "0" + " SAR"
//            }
//        }
//    }
//
//    func textFieldDidBeginEditing(_ textField: UITextField) {
//        
//        if textField == view4SecLbl { //Price
//            textField.text = ""
//        }
//    }
//}
