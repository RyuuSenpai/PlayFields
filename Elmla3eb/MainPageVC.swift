 //
 //  MainPageVC.swift
 //
 //
 //  Created by Macbook Pro on 3/12/17.
 //
 //
 
 import UIKit
 import AlamofireImage
// import InfiniteCollectionView
 import SwiftyStarRatingView

 //protocol homePagestaticsAndPagerData : class  {
 //    func headerDataRetriver(statics : Statics_Data, pager:[HomePagerData_Data])
 //    func playPauseDidTap()
 //
 //}
 var firstLaunchMainpage = true
 class MainPageVC: UIViewController  , UIGestureRecognizerDelegate  {
    
    static var mainStaticVC : MainPageVC?
    //Outer RatingView
    @IBOutlet weak var ratingActivityIndector: UIActivityIndicatorView!
    @IBOutlet var ratingView: UIView!
    @IBOutlet weak var ratingCollectionView: UICollectionView!

    @IBOutlet weak var noRatingFoundLbl: UILabel!
    //@end View
    
    @IBOutlet weak var collectionView: UICollectionView!
    
     @IBOutlet weak var menuBtn: UIBarButtonItem!
    //    weak var delegate : homePagestaticsAndPagerData?
    var playGroundData : [PlayGroundsData_Data]?
    let getData = GetPlayGroundsData()
    var pagerData : [HomePagerData_Data]?
    
       let imageURL = Constants.API.URLS()
    var ratePg_Data : [RatePg_Data]? {
        didSet {
            if  let data = ratePg_Data , data.count > 0 , firstLaunchMainpage{
                rateData = ratePg_Data
                setupRatingView()
                
            }
        }
    }
    var rateData : [RatePg_Data]?{
        didSet {
            guard let rateData = rateData else { return }
            if rateData.count < 1 {
                self.noRatingFoundLbl?.alpha = 1
                self.ratingCollectionView?.isUserInteractionEnabled = false
                self.ratingCollectionView?.alpha = 0
            }else{ // the problem occur when only 1 or 2 cells left
                self.ratingPageeControl?.numberOfPages = rateData.count
                self.ratingCollectionView?.reloadData()
                self.ratingCollectionView?.layoutIfNeeded()

            }
        }
    }

    let headerView = HPHeaderVC()
    var addedStatics  = 0
    var bookedStatics = 0
    var visitorsStatics = 0
    var backGroundBlackView : UIView!
    var ratingPageeControl : UIPageControl!
    
    var refreshControl:UIRefreshControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
         ViewPlayFeildVC.seletedTimes_ID = []
         collectionView.delegate = self
        collectionView.dataSource = self
        // Do any additional setup after loading the view.
        //        HPHeaderVC.Instance.delegate = self
        //        GetMainPageData.
        if let x = UserDefaults.standard.value(forKey: "userId") {
            print("that's userID : \(x)")
        }else {
         print("user id == nil ")
        }
          self.menuBtn.isEnabled = false
        self.menuBtn.image = UIImage(named: "")
        self.view.squareLoading.start(0.0)
        self.updateUI()
        ratingCollectionView.delegate = self
        ratingCollectionView.dataSource = self
//        let nib = UINib(nibName: "ratingCell", bundle:nil)
//        self.ratingCollectionView.register(nib, forCellWithReuseIdentifier: "ratingCell")
//        ratingCollectionView.register(ratingCell.self, forCellWithReuseIdentifier: "ratingCell")

    
        refreshControl = UIRefreshControl()
        refreshControl.tintColor = .white
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        collectionView.addSubview(refreshControl)
        collectionView.alwaysBounceVertical = true
        ////            self.window?.rootViewController?.dismiss(animated: false, completion: nil)

        MainPageVC.mainStaticVC = self
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        firstLaunchMainpage = false
    }
    
    
    func changeLang() {//
        let transition: UIViewAnimationOptions = [.transitionFlipFromLeft, .showHideTransitionViews]
        if L102Language.currentAppleLanguage() == "en" {
            L102Language.setAppleLAnguageTo(lang: "ar")
            UIView.appearance().semanticContentAttribute = .forceRightToLeft
        } else {
            L102Language.setAppleLAnguageTo(lang: "en")
            //            transition = .transitionFlipFromRight
            UIView.appearance().semanticContentAttribute = .forceLeftToRight
        }
        
        let rootviewcontroller: UIWindow = ((UIApplication.shared.delegate?.window)!)!
        let storyb = UIStoryboard(name: "Main", bundle: Bundle.main)
        rootviewcontroller.rootViewController = storyb.instantiateViewController(withIdentifier: "rootNav")
        let mainwindow = (UIApplication.shared.delegate?.window!)!
        mainwindow.backgroundColor = UIColor(hue: 1, saturation: 1, brightness: 1, alpha: 1)
        UIView.transition(with: mainwindow, duration: 0.55001, options: transition, animations: { () -> Void in
        }) { (finished) -> Void in
            
            
        }

    }
    
   
    func refreshData()
    {
        //DO
        updateUI()
    }
    
    
  
  
    
    
    func setupRatingView() {
        
         backGroundBlackView = UIView(frame: CGRect(x: 0, y: 0, width: Constants.screenSize.width, height: Constants.screenSize.height))
        backGroundBlackView.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        
        self.navigationController?.view.addSubview(backGroundBlackView)
        
//        ratingView.frame = CGRect(x: 0, y: 60, width: Constants.screenSize.width - 50 , height:  Constants.screenSize.width - 50 )
        ratingView.frame = CGRect(x: 0, y: 60, width: 315 , height: 315 )
        ratingView.clipsToBounds = true
        ratingView.center = view.center
        ratingView.alpha = 1
        
        self.navigationController?.view.addSubview(ratingView)
        
        let tapped = UITapGestureRecognizer(target: self, action: #selector(dismissView(sender:)))
        tapped.delegate = self
        backGroundBlackView.addGestureRecognizer(tapped)
        
 
        ratingPageeControl = UIPageControl(frame: CGRect(x: 0, y: 0, width: 50, height: 30))
        ratingPageeControl.numberOfPages = rateData == nil ? 0 : rateData!.count
        ratingPageeControl.currentPage = 0
        ratingPageeControl.tintColor = UIColor.green
        ratingPageeControl.currentPageIndicatorTintColor  = UIColor.black
        ratingPageeControl.pageIndicatorTintColor = UIColor.white
        ratingPageeControl.translatesAutoresizingMaskIntoConstraints = false
        ratingView.addSubview(ratingPageeControl)
        
        //        ratingPageeControl.center = ratingView.center
        ratingPageeControl.centerXAnchor.constraint(equalTo:  ratingPageeControl.superview!.centerXAnchor).isActive = true
        ratingPageeControl.bottomAnchor.constraint(equalTo: ratingPageeControl.superview!.bottomAnchor).isActive = true
        /*
         let centerY =   ratingPageeControl.centerYAnchor.constraint(equalTo: (ratingPageeControl.superview?.centerYAnchor)!)
         let bottom = ratingPageeControl.bottomAnchor.constraint(equalTo: ratingPageeControl.superview!.bottomAnchor)
         */
    }
    
    func dismissView(sender: UITapGestureRecognizer? = nil) {
        print("Tapped")
        UIView.animate(withDuration: 0.8, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: [], animations: {
            self.backGroundBlackView.alpha = 0
            self.ratingView.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
            self.ratingView.alpha = 0
            self.ratingActivityIndector.stopAnimating()
        }) { [weak self ] (true ) in
            self?.ratingView.transform = CGAffineTransform.identity
            self?.ratingView.removeFromSuperview()
            self?.backGroundBlackView.removeFromSuperview()
        }
        
    }
  
    
    
    func updateUI() {
         getData.getPlayFieldsData { [weak   self ] (data) in
            if !data.1 , data.2 == "User is banned"   {
                DispatchQueue.main.async {
                 ad.saveUserLogginData(email: nil, photoUrl: nil, uid: nil, name: nil)
                }
                return
            }
            guard data.1   else {
                DispatchQueue.main.async {
                    self?.stopRefresher()
//                    self?.menuBtn.isEnabled = true
//                    self?.menuBtn.image = UIImage(named: "Menu_Btn")
                    weak var weakself = self
                    ad.userOffline(weakself)

                }
                 return
            }
           
            guard let i = data.0 ,let pg = i.playGrounds , let statics = i.staticsdata , let pagerData = i.pagerData else {
                self?.stopRefresher()
                weak var weakself = self
                ad.userOffline(weakself)
                return    }
            self?.playGroundData = pg
            self?.addedStatics = statics.fieldAdded
            self?.bookedStatics = statics.bookedFields
            self?.visitorsStatics = statics.visitors
            self?.pagerData = pagerData
//            print("that's the user Image path : \(i.image)")
            if i.image != "" {
            ad.saveUserLogginData(email: "default", photoUrl: i.image, uid: -1, name: "default")
            }
            if let rating = i.ratePg_Data {
//                print("that's the data : \(data.0)\n and that's the rating : \(rating[0].pg_name,rating[0].id)")
                self?.ratePg_Data = [RatePg_Data]()
                 self?.ratePg_Data = rating
             }
          
             //            weakSelf?.delegate?.headerDataRetriver(statics: statics, pager: pagerData)
            //            weakSelf?.delegate?.playPauseDidTap()
            //            for x in pg {
            
            
            //            print("that's the ÷visitorsStatics of fields : \( weakSelf?.visitorsStatics)")
            //            print("that's the ÷addedStatics of fields : \( weakSelf?.addedStatics)")
            //
            //            print("that's the ÷bookedStatics of fields : \( weakSelf?.bookedStatics)")
            //            }
            //            weakSelf?.bookedFieldsLbl.text = "\(statics.bookedFields)"
            //            weakSelf?.visitorsLbl.text = "\(statics.visitors)"
            //            weakSelf?.fieldsAddedLbl.text = "\(statics.fieldAdded)"
            //            weakSelf?.collectionView.sub
            DispatchQueue.main.async {
                 self?.stopRefresher()
                self?.menuBtn.image = UIImage(named: "Menu_Btn")
                self?.view.squareLoading.stop(0)
                 self?.collectionView.reloadData()
                let isUserLogged = ad.isUserLoggedIn()
                if !isUserLogged  , firstLaunchMainpage{
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {

                    self?.performSegue(withIdentifier: "NotLogged", sender: self)
                        

                         }
                }
                self?.menuBtn.isEnabled = true
             }

        }
    }
    
    func stopRefresher()
    {
        self.refreshControl.endRefreshing()
        self.view.squareLoading.stop(0.0)
        self.ratingActivityIndector.stopAnimating()
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView{
        
        //        if kind == UICollectionElementKindSectionHeader {
        let headerView: HPHeaderVC = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "Header", for: indexPath) as! HPHeaderVC
        
        headerView.delegate = self
        headerView.bookedStatics = "\(bookedStatics)"
        headerView.addedStatics = "\(addedStatics)"
        headerView.visitorsStatics = "\(visitorsStatics)"
        if let pagerData = self.pagerData {
            headerView.pagerData = pagerData
            //        headerView.mainPage.delegate = HPHeaderVC()
        }
        print("that is the array of pagerData : \(self.pagerData)")
        //        headerView.pagerData = self.pagerData
        return headerView
        
        //        }
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        if ratingCollectionView == collectionView {
         
        return CGSize(width: 320, height: 320)
        }else {
            return CGSize(width: 320, height: 320)
        }
    }
    
    @IBAction func menuBarButtonAct(_ sender: UIBarButtonItem) {
        //        let x = MenuVC()
        //        x.modalTransitionStyle = .partialCurl
        //         self.present(x, animated: true, completion: nil)
        ad.sideMenuTrigger(self,"Home")
        
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "ToPlayField" {
            
            //            if  let nextScene = segue.destination as? PlayFieldsVC{
            //                let index = self.collectionView.indexPathsForSelectedItems
            //                let row = index.row
            //               let x = self.playGroundData[index.row].id
            //            }
            
            
            
            
            
        }
        
    }
    //Rating

    
    
 }
 
 //Rate
 extension MainPageVC  {
    
//    func number(ofItems collectionView: UICollectionView) -> Int {
//        return rateData.count
//    }
    
//    func collectionView(_ collectionView: UICollectionView, dequeueForItemAt dequeueIndexPath: IndexPath, cellForItemAt usableIndexPath: IndexPath) -> UICollectionViewCell {
//       
//    }
    
 
    func rateField(_ sender : SwiftyStarRatingView ) {
        print(print("that's the state \(sender.state)"))
        self.view.isUserInteractionEnabled = false
        self.ratingActivityIndector.startAnimating()
//        print("that's the sender value : \(sender.value) and that's the id:  \(rateData[sender.tag].id) ,name: \(rateData[sender.tag].pg_name)")
        guard let rateData = rateData else { return }
        getData.postPlay_gRateing(pg_id: rateData[sender.tag].id , ratingValue: Int(sender.value)) { [weak self ] (response) in
            
            if response {
                if  let data = self?.rateData , sender.tag <= data.count {
//                    print("removed the :\(self?.rateData[sender.tag].pg_name), rating")
                    self?.rateData!.remove(at: sender.tag)
                    DispatchQueue.main.async {
                        self?.ratingActivityIndector.stopAnimating()
                        self?.view.isUserInteractionEnabled = true
                    }
                }

//                let pg_rate = self.rateData.index(after: sender.tag)
//                if  , pg_rate == rateData[sender.tag] {
//                    
//                }
               
                 /*
                 if let index = selectedDates.index(of: xcz[sender.tag]) {
                 selectedDates.remove(at: index)
                 }
  */
            }else {
                DispatchQueue.main.async {
                        self?.ratingActivityIndector.stopAnimating()
                     self?.view.isUserInteractionEnabled = true
                    
                }            }
            
        }
    }
    func skipRating(_ sender : UIButton) {
        self.dismissView()
    }
    /*
  - (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{  
     for (UICollectionViewCell *cell in [self.mainImageCollection visibleCells]) {   
     NSIndexPath *indexPath = [self.mainImageCollection indexPathForCell:cell];        NSLog(@"%@",indexPath);    }}
  */
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        
//        for cell in ratingCollectionView.visibleCells  as [UICollectionViewCell]    {
//            let indexPath = ratingCollectionView.indexPath(for: cell as UICollectionViewCell)
//            if let index = indexPath?.row {
//                ratingPageeControl.currentPage = index
//            }
//            print(" scoll : \(indexPath?.row)")
//        }
//    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        print(" scoll : \(scrollView)")
        for cell in ratingCollectionView.visibleCells  as [UICollectionViewCell]    {
            let indexPath = ratingCollectionView.indexPath(for: cell as UICollectionViewCell)
            if let index = indexPath?.row {
                ratingPageeControl.currentPage = index
            }
//            print(" scoll : \(indexPath?.row - 1)")
        }

    }
//    func scrollView(_ scrollView: UIScrollView, pageIndex: Int) {
//        print("index : \(pageIndex) , scoll : \(scrollView)")
//        if scrollView == ratingCollectionView {
//         ratingPageeControl.currentPage = pageIndex
////        if rateData.count == 1 {
////            self.ratingCollectionView.scrollsToTop = true
////        }
//    }
//    }
 }
 
 
 
 extension MainPageVC : pagerTappeingControll {
    
    func didSelectImageAt(index: Int) {
        print("that is the item number in main page  : \(index) PlayFieldsVC")
        performSegue(withIdentifier: "ToPlayFieldsVC", sender: self)
        
    }
    
 }
