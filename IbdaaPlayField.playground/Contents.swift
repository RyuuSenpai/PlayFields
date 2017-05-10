//: Playground - noun: a place where people can play

import UIKit

var str:String?


str ?? "hi"
print(str)

let s = 1

print(11231)
let xc = s == 1 ? true : false
print(xc)
////
////  SeeReviews.swift
////  HyperApp
////
////  Created by Killvak on 17/11/2016.
////  Copyright © 2016 Killvak. All rights reserved.
////
//
//import UIKit
//
//class SeeReviews: UIViewController , UITableViewDelegate , UITableViewDataSource {
//    
//    @IBOutlet weak var tableView: UITableView!
//    
//    var testData = ["Very good product , but it all depends Very good product , but it all depends ", "Very good product , but it all depends" , "Very good product , but it all depends Very good product , but it all depends Very good product , but it all dependsbut it all depends Very good product , but it all dependsbut it all depends Very good product , but it all dependsbut it all depends Very good product , but it all dependsbut it all depends Very good product , but it all depends " ,"Very good product , but it all depends","Very good product , but it all depends","Very good product , but it all depends"]
//    var indexIs : Int?
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        tableView.delegate = self
//        tableView.dataSource = self
//        // Do any additional setup after loading the view.
//        tableView.estimatedRowHeight = 228
//        tableView.rowHeight = UITableViewAutomaticDimension
//    }
//    
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//        // Dispose of any resources that can be recreated.
//    }
//    
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return 1
//    }
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return testData.count
//    }
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        
//        let cell = tableView.dequeueReusableCell(withIdentifier: "reviewCell", for: indexPath) as! SeeMoreReviewsCell
//        cell.configCell(data: testData[indexPath.row])
//        return cell
//    }
//    

    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
//    
//}

/*
 
 //
 //  HPHeaderVC.swift
 //  Elmla3eb
 //
 //  Created by Macbook Pro on 3/13/17.
 //  Copyright © 2017 Killvak. All rights reserved.
 //
 
 import UIKit
 import AlamofireImage
 import Alamofire
 protocol  pagerTappeingControll : class  {
 
 func didSelectImageAt(index: Int);
 }
 
 
 class HPHeaderVC: UICollectionReusableView ,FSPagerViewDelegate , FSPagerViewDataSource {
 
 @IBOutlet weak var fieldsAddedLbl: UILabel!
 @IBOutlet weak var bookedFieldsLbl: UILabel!
 @IBOutlet weak var visitorsLbl: UILabel!
 
 private  let source = Constants.API.URLS()
 var addedStatics : String? {
 didSet {
 self.fieldsAddedLbl.text = addedStatics
 }
 }
 var bookedStatics : String? {
 didSet {
 self.bookedFieldsLbl.text = bookedStatics
 }
 }
 var visitorsStatics : String? {
 didSet {
 self.visitorsLbl.text = visitorsStatics
 }
 }
 
 //    var imageString : [String]?
 var imageList = [#imageLiteral(resourceName: "court_pic01"),#imageLiteral(resourceName: "main_pic"),#imageLiteral(resourceName: "court_pic01"),#imageLiteral(resourceName: "main_pic")]
 var imageList : [UIImage]?
 var textList = ["1","2","3","4"]
 var pagerData : [HomePagerData_Data]? {
 didSet {
 print("updated Value ")
 guard let data = pagerData else { print("Found nil in pager data header"); return  }
 
 self.downloadImage(data) { (titles, images) in
 self.imageList = [UIImage]()
 self.imageList = images
 print("that is the count of list images : \(self.imageList?.count) and that is the array : \(self.imageList)")
 //                self.imageString = [String]()
 //            for x in data {
 //                self.imageString?.append(self.source.IMAGES_URL + x.image)
 //                print("that is object imageString : \(x.image)")
 //            }
 //            print("that is count of the array of images : \(self.imageString?.count)")
 if let count = self.imageList?.count {
 self.pageControl.numberOfPages = count
 self.pageControl.contentHorizontalAlignment = .right
 self.pageControl.contentInsets = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
 }
 self.pagerView.reloadData()
 //                self.imageString = images
 //                self.textList = titles
 }
 }
 }
 
 //    func downloadImage(_ data : [HomePagerData_Data] , completed : @escaping ([String],[Image])->() ) {
 //        var images = [Image]()
 //        var titles = [String]()
 //        for x in data {
 //            if x.image != "" {
 //                Alamofire.request(source.IMAGES_URL + x.image ).responseImage { response in
 //                    debugPrint(response)
 //
 ////                    print(response.request)
 ////                    print(response.response)
 ////                    debugPrint(response.result)
 //
 //                    if let image = response.result.value {
 //                        print("image downloaded: \(image)")
 //                        images.append(image)
 //                        titles.append(x.title)
 //                    }
 //                }//Alamnofire
 //            }
 //            completed(titles,images)
 //        }//End of For
 //
 //
 //
 //    }
 // var mainPage = MainPageVC()
 
 weak var delegate : pagerTappeingControll?
 //    var fieldPagerLbl : UILabel!
 @IBOutlet weak var pagerView: FSPagerView! {
 didSet {
 self.pagerView.register(FSPagerViewCell.self, forCellWithReuseIdentifier: "cell")
 }
 }
 
 @IBOutlet weak var pageControl: FSPageControl! {
 didSet {
 guard let count = imageList?.count else { return }
 self.pageControl.numberOfPages = count
 self.pageControl.contentHorizontalAlignment = .right
 self.pageControl.contentInsets = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
 }
 }
 
 
 
 override func awakeFromNib() {
 //  mainPage.delegate = self
 pagerView.delegate = self
 pagerView.dataSource = self
 pagerView.isInfinite = true
 pagerView.automaticSlidingInterval = 4.5
 self.bookedFieldsLbl.text = bookedStatics
 self.fieldsAddedLbl.text = addedStatics
 self.visitorsLbl.text = visitorsStatics
 //        pagerView.transformer = FSPagerViewTransformer(type: .zoomOut)
 //        pagerView.transformer = FSPagerViewTransformer(type: .linear)
 //                pagerView.transformer = FSPagerViewTransformer(type: .ferrisWheel)
 //                pagerView.transformer = FSPagerViewTransformer(type: .coverFlow)
 //        pagerView.transformer = FSPagerViewTransformer(type: .cubic)
 //        pagerView.transformer = FSPagerViewTransformer(type: .depth)
 pagerView.interitemSpacing = 10
 self.pageControl.setStrokeColor(.green, for: .normal)
 self.pageControl.setStrokeColor(.green, for: .selected)
 self.pageControl.setFillColor(.green, for: .selected)
 // Do any additional setup after loading the view.
 
 //test
 //        fieldPagerLbl = UILabel(frame: CGRect(x: 10 , y: 2 , width: self.pageControl.frame.width, height: self.pageControl.frame.height))
 //        //        label.center = CGPoint(x: 8, y: 12)
 //        fieldPagerLbl.textAlignment = NSTextAlignment.center
 //        fieldPagerLbl.text = "I'am a test label"
 //        fieldPagerLbl.textColor = UIColor.white
 //        fieldPagerLbl.font = UIFont.boldSystemFont(ofSize: 16)
 //        self.pageControl.addSubview(fieldPagerLbl)
 }
 
 public func numberOfItems(in pagerView: FSPagerView) -> Int {
 guard let count = imageList  else { return 1 }
 print("that is the count of list images : \(count) and that is the array : \(imageList)")
 return count.count
 }
 
 public func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
 let cell = pagerView.dequeueReusableCell(withReuseIdentifier: "cell", at: index)
 //        cell.imageView?.image = imageList[index]
 //        cell.imageView?.contentMode = .scaleAspectFill
 //        cell.courtImage.image = UIImage(named: "courtplaceholder_3x")
 //             cell.cell.imageView?.image = UIImage(named: "court_pic")
 guard let imageArrayOf = imageList else { return cell }
 //        if imageString.count >= 0 {
 cell.imageView?.image = imageArrayOf[index]
 //        print("YOOYOYOYOYOYOY that is the image : \(imageArrayOf[0])")
 //            cell.imageView?.af_setImage(
 //                withURL: URL(string:imageArrayOf[0])!,
 //                placeholderImage: UIImage(named: "court_pic"),
 //                filter: nil,
 //                imageTransition: .crossDissolve(0.2)
 //            )
 //        }
 
 
 return cell
 }
 
 
 func pagerView(_ pagerView: FSPagerView, didSelectItemAt index: Int) {
 pagerView.deselectItem(at: index, animated: true)
 print("that is the item number in Header : \(pagerView.currentIndex) ")
 self.delegate?.didSelectImageAt(index: pagerView.currentIndex)
 }
 
 // MARK:- FSPagerViewDelegate
 
 func pagerViewDidScroll(_ pagerView: FSPagerView) {
 guard self.pageControl.currentPage != pagerView.currentIndex else {
 return
 }
 self.pageControl.currentPage = pagerView.currentIndex // Or Use KVO with property "currentIndex"
 //        self.fieldPagerLbl.text = self.textList[pagerView.currentIndex]
 }
 
 func headerDataRetriver(statics : Statics_Data, pager:[HomePagerData_Data]) {
 
 print("Done with protocol")
 print("data : \(statics) ,   pager count :  \(pager.count)")
 }
 func playPauseDidTap() {
 print("play/pause tapped!!")
 }
 }

 */
