//
//  PointsViewController.swift
//  Elmla3eb
//
//  Created by Macbook Pro on 6/29/17.
//  Copyright © 2017 Killvak. All rights reserved.
//

import UIKit
import AlamofireImage
import CDAlertView

protocol pointsDelegateUpdateProfile : class {
    func updateData()
}
class PointsViewController: UIViewController {

    @IBOutlet weak var points1000: UILabel!
    @IBOutlet weak var points5000: UILabel!
    @IBOutlet weak var points10000: UILabel!

    @IBOutlet weak var loadingActivity: UIActivityIndicatorView!
    @IBOutlet weak var point1: UILabel!
    @IBOutlet weak var point2: UILabel!
    @IBOutlet weak var point3: UILabel!
    @IBOutlet weak var firstRewardView: UIViewX!
    @IBOutlet weak var secondRewardView: UIViewX!
    @IBOutlet weak var finalrewardView: UIViewX!
    
    @IBOutlet weak var totalPointLbl: UILabel!
    @IBOutlet weak var firstRewardImage: UIImageView!
    @IBOutlet weak var secondRewardImage: UIImageView!
    @IBOutlet weak var finalRewardImage: UIImageView!

    @IBOutlet weak var userPointBtn: UIButton!
    
    @IBOutlet weak var firstSlider: UISlider!
    @IBOutlet weak var secondSlider: UISlider!

      let gray = UIColor(colorLiteralRed: 204/255, green: 204/255, blue: 204/255, alpha: 1)     //   #989898
    weak var delegate : pointsDelegateUpdateProfile?
   private  let getPointClass = Profile_Model()
  private   var myRewardPointReached : Int?
    var pointsData : [Points_Data]? {
        didSet{
            guard let data = pointsData , data.count > 2 else { /*fatalError("PointData");*/
                delegate?.updateData()
                self.view?.squareLoading.stop(0)
                self.navigationController?.popViewController(animated: true)
                return }
            firstSlider.maximumValue = Float(data[1].points)
            secondSlider.maximumValue = Float(data[2].points)
            self.points1000.text = "\(data[0].points)"
            self.points5000.text = "\(data[1].points)"
            self.points10000.text = "\(data[2].points)"

//            print("that is the points : \(data[0].points , data[0])")
            guard currentPoints > data[0].points else {
                undo1rdSenaryo()
                myRewardPointReached = nil
                firstSlider?.value = 0
                self.view?.squareLoading.stop(0)
                return
            }
            
            guard currentPoints < data[2].points else {
//                myRewardPointReached = data[2].points
                myRewardPointReached =  data[2].points
                firstSlider?.value = Float(data[1].points)
                secondSlider?.value = Float( data[2].points)
                thirdSenaryo()
                self.view?.squareLoading.stop(0)
                return
            }
            
            if currentPoints < data[1].points , currentPoints >= data[0].points {
                myRewardPointReached = data[0].points
                undo2rdSenaryo()
                firstSenaryo()
                firstSlider.value = Float(currentPoints)
            }else if currentPoints >= data[1].points {
                undo3rdSenaryo()
                secondSenaryo()
                 myRewardPointReached = data[1].points
                firstSlider?.value = Float(data[1].points)
                secondSlider?.value = Float(currentPoints - data[1].points )
            }
                 self.view?.squareLoading.stop(0)
         }
    }
    
    
    
    var currentPoints : Int = 0
    
    var imgUrlDict = [String:String ]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        totalPointLbl?.text = "\(currentPoints)"
        self.edgesForExtendedLayout = []
        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)// CGRectMake(0,0,1,1)
        UIGraphicsBeginImageContextWithOptions(CGSize(width:1,height:1), false, 0)
        UIColor.clear.setFill()
        UIRectFill(rect)
        if let img = UIGraphicsGetImageFromCurrentImageContext(){
        let blankImg: UIImage = img
        UIGraphicsEndImageContext()
        
//        firstSlider.setThumbImage(blankImg, for: .normal)
        secondSlider.setThumbImage(blankImg, for: .normal)
            firstSlider.setThumbImage(blankImg, for: .normal)

        }
        firstSlider.transform = CGAffineTransform(scaleX: 1, y: 2);
        secondSlider.transform = CGAffineTransform(scaleX: 1, y: 2);

        // Do any additional setup after loading the view.

        fetchData()
        
        
    }
    
    func fetchData() {
        self.view.squareLoading.start(0)
        getPointClass.getPointsData { [weak self] (dataArray, sms, state) in
            guard state , let data = dataArray , data.count > 2 else {
//                print("Soomething wentWoring  the data count is : \( dataArray) and state is : \(state)" )
                return }
            DispatchQueue.main.async {
                
            self?.pointsData = data
                
            }
        }
    }
 
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.firstRewardView.layer.cornerRadius =  firstRewardView.bounds.size.width   / 2
        self.firstRewardView.clipsToBounds = true
        
        self.secondRewardView.layer.cornerRadius =  secondRewardView.bounds.size.width   / 2
        self.secondRewardView.clipsToBounds = true
        
        self.finalrewardView.layer.cornerRadius =  finalrewardView.bounds.size.width   / 2
        self.finalrewardView.clipsToBounds = true
    }
    
    @IBAction func usePointsBtnAct(_ sender: UIButton) {
//        print("that is the c urrent points : \(currentPoints) , \(myRewardPointReached)")
        guard let point = myRewardPointReached , let data = pointsData , point >= data[0].points  else {
            ad.showAlert(langDicClass().getLocalizedTitle("Not Enough Points!!"), "")
            return }
        let points =  abs(currentPoints - point)
        self.loadingActivity.startAnimating()
//        print("that's my currentPoints : \(currentPoints)\n myRewardPointReached : \(point)\n new Points : \(points)")
        getPointClass.post_PointsReward(points: points) { [weak self] (points , state, sms) in
            guard state else {
                DispatchQueue.main.async {
                    
                    ad.showAlert("deafult", sms) ;
                    self?.loadingActivity.stopAnimating()
                }
                return }
            DispatchQueue.main.async {
                self?.myRewardPointReached = nil
                let done = " 🎉 " + langDicClass().getLocalizedTitle("Done") + " 🎉 "
                 let alert = CDAlertView(title:done, message:langDicClass().getLocalizedTitle("Wait for our representative Call") , type: .success)
                alert.show()

                if let point = points {
                    self?.totalPointLbl.text = "\(point)"
                    self?.currentPoints = point
                }
                self?.delegate?.updateData()
                self?.loadingActivity.stopAnimating()
                self?.navigationController?.popViewController(animated: true )
//                self?.fetchData()
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

    func firstSenaryo() {
    points1000?.textColor = .black
        point1?.textColor = .black
//        firstRewardImage?.image = #imageLiteral(resourceName: "BlackFootball")
        firstRewardView?.borderColor = .black
        guard let url = URL(string: pointsData![0].img_achieved ) else { return }
        firstRewardImage.af_setImage(
            withURL: url,
            placeholderImage: UIImage(named: "question_mark_filled"),
            filter: nil,
            imageTransition: .crossDissolve(0.2)
        )
    }
    func secondSenaryo() {
        firstSenaryo()
        points5000?.textColor = .black
        point2?.textColor = .black
//        secondRewardImage?.image = #imageLiteral(resourceName: "BlackTshirt")
        secondRewardView?.borderColor = .black
        guard let url = URL(string: pointsData![1].img_achieved ) else { return }
        secondRewardImage.af_setImage(
            withURL: url,
            placeholderImage: UIImage(named: "question_mark_filled"),
            filter: nil,
            imageTransition: .crossDissolve(0.2)
        )
    }
    func thirdSenaryo() {
        secondSenaryo()
        points10000?.textColor = .black
        point3?.textColor = .black
//        finalRewardImage?.image = #imageLiteral(resourceName: "BlackCup")
        finalrewardView?.borderColor = .black
        guard let url = URL(string: pointsData![2].img_achieved ) else { return }
        finalRewardImage.af_setImage(
            withURL: url,
            placeholderImage: UIImage(named: "question_mark_filled"),
            filter: nil,
            imageTransition: .crossDissolve(0.2)
        )
    }
    
    func undo3rdSenaryo() {
        points10000?.textColor = gray
        point3?.textColor = gray
//        finalRewardImage?.image = #imageLiteral(resourceName: "WhiteCup")
        finalrewardView?.borderColor = gray
        guard let url = URL(string: pointsData![2].img_unachieved ) else { return }
        finalRewardImage.af_setImage(
            withURL: url,
            placeholderImage: UIImage(named: "question_mark_filled"),
            filter: nil,
            imageTransition: .crossDissolve(0.2)
        )
    }
    func undo2rdSenaryo() {
        undo3rdSenaryo()
        points5000?.textColor = gray
        point2?.textColor = gray
//        secondRewardImage?.image = #imageLiteral(resourceName: "WhiteTshirt")
        secondRewardView?.borderColor = gray
        guard let url = URL(string: pointsData![1].img_unachieved ) else { return }
        secondRewardImage.af_setImage(
            withURL: url,
            placeholderImage: UIImage(named: "question_mark_filled"),
            filter: nil,
            imageTransition: .crossDissolve(0.2)
        )
    }
    func undo1rdSenaryo() {
        undo2rdSenaryo()
        points1000?.textColor = gray
        point1?.textColor = gray
//        firstRewardImage?.image = #imageLiteral(resourceName: "WhiteFootball")
        firstRewardView?.borderColor = gray
        guard let url = URL(string: pointsData![0].img_unachieved ) else { return }
        firstRewardImage.af_setImage(
            withURL: url,
            placeholderImage: UIImage(named: "question_mark_filled"),
            filter: nil,
            imageTransition: .crossDissolve(0.2)
        )
    }
}
