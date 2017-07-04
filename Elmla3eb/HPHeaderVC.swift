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


class HPHeaderVC: UICollectionReusableView ,FSPagerViewDelegate,FSPagerViewDataSource  {
    
    @IBOutlet weak var pagerController: UIView!
    @IBOutlet weak var pagerView: UIView!
    @IBOutlet weak var fieldsAddedLbl: UILabel!
    @IBOutlet weak var bookedFieldsLbl: UILabel!
    @IBOutlet weak var visitorsLbl: UILabel!
    
    var hasSetPAGERDATA = false
    var addedStatics : String? {
        didSet {
            self.fieldsAddedLbl?.text = addedStatics
        }
    }
    var bookedStatics : String? {
        didSet {
            self.bookedFieldsLbl?.text = bookedStatics
        }
    }
    var visitorsStatics : String? {
        didSet {
            self.visitorsLbl?.text = visitorsStatics
        }
    }
    var pagerCont = FSPageControl()
    // var mainPage = MainPageVC()
    let imageList = [#imageLiteral(resourceName: "court_pic01"),#imageLiteral(resourceName: "main_pic"),UIImage(named:"219")]
    var imagesData  : [String]! {
        didSet {
            if !hasSetPAGERDATA {
                guard imagesData.count > 1 else { return }
            setUpPager()
                hasSetPAGERDATA = true
            }
        }
    }

    var pagerData : [HomePagerData_Data]? {
        didSet {
//            print("That's the value of pagerData : \(pagerData)" )
            guard let data = pagerData else {
//                print("Found nil in pagerData ");
                return
            }
            if !hasSetPAGERDATA {
            var imageUrlDict = [String]()
            for imgData in data {
//                     imageUrlDict[imgData.title] = imgData.image
                imageUrlDict.append(imgData.image)
             }
            self.imagesData = imageUrlDict
            }
        }
    }
    
    weak var delegate : pagerTappeingControll?
    var fieldPagerLbl : UILabel!
    
    
    override func awakeFromNib() {
        //  mainPage.delegate = self
        
        self.bookedFieldsLbl.text = bookedStatics
        self.fieldsAddedLbl.text = addedStatics
        self.visitorsLbl.text = visitorsStatics
        


        // Create a page control
//        let pageControl = FSPageControl(frame: self.pagerController.frame)
//        self.pagerController.addSubview(pageControl)
        
    }
    
    
    public func numberOfItems(in pagerView: FSPagerView) -> Int {
        guard let count = self.pagerData?.count else { return 0 }
        return  count
    }
    
    public func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        let cell = pagerView.dequeueReusableCell(withReuseIdentifier: "cell", at: index)
        guard let data = self.pagerData , index <= data.count else {
//            print("Nil in pagerdata");
            return cell }
        
        if  imagesData[index] != "" {
//            
            cell.imageView?.af_setImage(
                withURL: URL(string: imagesData[index] )!,
                placeholderImage: UIImage(named: "courtplaceholder_3x"),
                filter: nil,
                imageTransition: .crossDissolve(0.2)
            )

            cell.textLabel?.text = data[index].title
        }else {
            cell.imageView?.image = UIImage(named: "courtplaceholder_3x")
            cell.textLabel?.text = ""

        }
        
        return cell
    }
    
    func pagerViewDidScroll(_ pagerView: FSPagerView) {
 
        guard let data = self.pagerData else {
//            print("Nil in pagerdata");
            return   }

        guard self.pagerCont.currentPage != pagerView.currentIndex else {
            return
        }
        if self.pagerCont.currentPage != pagerView.currentIndex{
          
           self.pagerCont.currentPage = pagerView.currentIndex
        
        }
      // Or Use KVO with property "currentIndex"
//        self.fieldPagerLbl.text = self.textList[pagerView.currentIndex]
    }
    
    
    func setUpPager() {
        let pagerViewx = FSPagerView(frame: self.pagerView.frame)
        pagerViewx.dataSource = self
        pagerViewx.delegate = self
        pagerViewx.register(FSPagerViewCell.self, forCellWithReuseIdentifier: "cell")
        //        self.pagerView.addSubview(pagerView)
        pagerViewx.isInfinite = true

        //        pagerViewx.reloadData()
        pagerViewx.automaticSlidingInterval = 4.5
        
        pagerCont = FSPageControl(frame: self.pagerController.frame)
        pagerCont.setStrokeColor(.green, for: .normal)
        pagerCont.setStrokeColor(.green, for: .selected)
        pagerCont.setFillColor(.green, for: .selected)
        pagerCont.numberOfPages = self.imagesData.count
        if L102Language.currentAppleLanguage() == "ar" {
            pagerCont.contentHorizontalAlignment = .left
        }else {
            pagerCont.contentHorizontalAlignment = .right
        }
        pagerCont.contentInsets = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        
//        fieldPagerLbl = UILabel(frame: CGRect(x: 10 , y: 2 , width: pagerCont.frame.width, height: pagerCont.frame.height))
//        //        label.center = CGPoint(x: 8, y: 12)
//        fieldPagerLbl.textAlignment = NSTextAlignment.center
//        fieldPagerLbl.textColor = UIColor.white
//        fieldPagerLbl.font = UIFont.boldSystemFont(ofSize: 16)
//        pagerCont.addSubview(fieldPagerLbl)
        
        pagerViewx.addSubview(pagerCont)
        self.addSubview(pagerViewx)
        
    }
}
