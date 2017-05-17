 //
 //  MainPageVC.swift
 //
 //
 //  Created by Macbook Pro on 3/12/17.
 //
 //
 
 import UIKit
 import AlamofireImage
 import InfiniteCollectionView
 //protocol homePagestaticsAndPagerData : class  {
 //    func headerDataRetriver(statics : Statics_Data, pager:[HomePagerData_Data])
 //    func playPauseDidTap()
 //
 //}
 class MainPageVC: UIViewController  , UIGestureRecognizerDelegate,InfiniteCollectionViewDelegate,InfiniteCollectionViewDataSource {
    
    //Outer RatingView
    @IBOutlet var ratingView: UIView!
    @IBOutlet weak var ratingCollectionView: InfiniteCollectionView!

    @IBOutlet weak var noRatingFoundLbl: UILabel!
    //@end View
    
    @IBOutlet weak var collectionView: UICollectionView!
    
     @IBOutlet weak var menuBtn: UIBarButtonItem!
    //    weak var delegate : homePagestaticsAndPagerData?
    var playGroundData : [PlayGroundsData_Data]?
    let getData = GetPlayGroundsData()
    var pagerData : [HomePagerData_Data]?
    
    let headerView = HPHeaderVC()
    var addedStatics  = 0
    var bookedStatics = 0
    var visitorsStatics = 0
    
    var backGroundBlackView : UIView!
    var ratingPageeControl : UIPageControl!

    var ratingFieldsList = [1,2,3,4,5]{
        didSet {
            if ratingFieldsList == [] {
            self.noRatingFoundLbl?.alpha = 1
                self.ratingCollectionView?.isUserInteractionEnabled = false 
                self.ratingCollectionView.alpha = 0
            }else{
                self.ratingPageeControl?.numberOfPages = ratingFieldsList.count
        }
    }
    
    }
    
    var refreshControl:UIRefreshControl!

    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        ratingCollectionView.infiniteDataSource = self
        ratingCollectionView.infiniteDelegate = self
        
        
    
//        setupRatingView()
        refreshControl = UIRefreshControl()
        refreshControl.tintColor = .white
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        collectionView.addSubview(refreshControl)
        collectionView.alwaysBounceVertical = true
        
    }
    
    func refreshData()
    {
        //DO
        updateUI()
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print("Vowala")
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    
    
    func setupRatingView() {
        
         backGroundBlackView = UIView(frame: CGRect(x: 0, y: 0, width: Constants.screenSize.width, height: Constants.screenSize.height))
        backGroundBlackView.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        
        self.navigationController?.view.addSubview(backGroundBlackView)
        
//        ratingView.frame = CGRect(x: 0, y: 60, width: Constants.screenSize.width - 50 , height:  Constants.screenSize.width - 50 )
        ratingView.frame = CGRect(x: 0, y: 60, width: 315 , height: 315 )
        ratingView.clipsToBounds = true
        ratingView.center = view.center
        
        self.navigationController?.view.addSubview(ratingView)
        
        let tapped = UITapGestureRecognizer(target: self, action: #selector(dismissView(sender:)))
        tapped.delegate = self
        backGroundBlackView.addGestureRecognizer(tapped)
        
        
        ratingPageeControl = UIPageControl(frame: CGRect(x: 0, y: 0, width: 50, height: 30))
        ratingPageeControl.numberOfPages = ratingFieldsList.count
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
            
        }) { [weak self ] (true ) in
            
            self?.ratingView.removeFromSuperview()
            self?.backGroundBlackView.removeFromSuperview()
        }
        
    }
  
    
    
    func updateUI() {
        getData.getPlayFieldsData { [weak   self ](data) in
            guard let i = data ,let pg = i.playGrounds , let statics = i.staticsdata , let pagerData = i.pagerData else {
                self?.stopRefresher()
                weak var weakself = self
                ad.userOffline(weakself)
                return    }
            self?.playGroundData = pg
            self?.addedStatics = statics.fieldAdded
            self?.bookedStatics = statics.bookedFields
            self?.visitorsStatics = statics.visitors
            self?.pagerData = pagerData
            //            weakSelf?.delegate?.headerDataRetriver(statics: statics, pager: pagerData)
            //            weakSelf?.delegate?.playPauseDidTap()
            //            for x in pg {
            
            
            //            print("that's the ÷visitorsStatics of fields : \( weakSelf?.visitorsStatics)")
            //            print("that's the ÷addedStatics of fields : \( weakSelf?.addedStatics)")
            //
            //            print("that's the ÷bookedStatics of fields : \( weakSelf?.bookedStatics)")
            self?.stopRefresher()
            //            }
            //            weakSelf?.bookedFieldsLbl.text = "\(statics.bookedFields)"
            //            weakSelf?.visitorsLbl.text = "\(statics.visitors)"
            //            weakSelf?.fieldsAddedLbl.text = "\(statics.fieldAdded)"
            //            weakSelf?.collectionView.sub
         
            
            self?.menuBtn.isEnabled = true
            self?.menuBtn.image = UIImage(named: "Menu_Btn")
        
            self?.collectionView.reloadData()
        }
    }
    
    func stopRefresher()
    {
        self.refreshControl.endRefreshing()
        self.view.squareLoading.stop(0.0)
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
            print("that's ittttttt")
        
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
    
    func number(ofItems collectionView: UICollectionView) -> Int {
        return ratingFieldsList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, dequeueForItemAt dequeueIndexPath: IndexPath, cellForItemAt usableIndexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ratingCell", for: usableIndexPath) as! ratingCell
        cell.tag = usableIndexPath.row
        cell.skipBtn.tag = cell.tag
        cell.skipBtn.addTarget(self, action: #selector(skipRating(_:)), for: .touchUpInside)
        return cell
    }
    
    func skipRating(_ sender : UIButton) {
        print("skipRating index : \(sender.tag + 1)")
     
        ratingFieldsList.remove(at: sender.tag)
        ratingCollectionView.reloadData()
        print("ratingFieldsList index : \(ratingFieldsList)")

    }
    
    func scrollView(_ scrollView: UIScrollView, pageIndex: Int) {
        print("index : \(pageIndex)")
        ratingPageeControl.currentPage = pageIndex
    }
    
    
    
 }
 
 
 
 
 extension MainPageVC : pagerTappeingControll {
    
    func didSelectImageAt(index: Int) {
        print("that is the item number in main page  : \(index) PlayFieldsVC")
        performSegue(withIdentifier: "ToPlayFieldsVC", sender: self)
        
    }
    
 }
