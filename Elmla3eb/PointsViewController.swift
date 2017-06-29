//
//  PointsViewController.swift
//  Elmla3eb
//
//  Created by Macbook Pro on 6/29/17.
//  Copyright © 2017 Killvak. All rights reserved.
//

import UIKit

class PointsViewController: UIViewController {

    @IBOutlet weak var points1000: UILabel!
    @IBOutlet weak var points5000: UILabel!
    @IBOutlet weak var points10000: UILabel!

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
    
    var currentPoints : Int = 0 {
        didSet {
            totalPointLbl.text = "\(currentPoints)"
            guard currentPoints > 1000 else {
                undo1rdSenaryo()
                firstSlider.value = 0
                return
            }
            
            guard currentPoints != 10000 else {
                firstSlider.value = 5000
                secondSlider.value = Float(currentPoints - 5000)
                thirdSenaryo()
                return
            }
            
            if currentPoints < 5000 , currentPoints >= 1000 {
                undo2rdSenaryo()
                firstSenaryo()
                firstSlider.value = Float(currentPoints)
            }else if currentPoints >= 5000 {
                undo3rdSenaryo()
                secondSenaryo()
                firstSlider.value = 5000
                secondSlider.value = Float(currentPoints - 5000 )
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        currentPoints = 10000
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
        currentPoints -= 500
        
        print("that is the c urrent points : \(currentPoints)")
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
    points1000.textColor = .black
        point1.textColor = .black
        firstRewardImage.image = #imageLiteral(resourceName: "BlackFootball")
        firstRewardView.borderColor = .black
    }
    func secondSenaryo() {
        firstSenaryo()
        points5000.textColor = .black
        point2.textColor = .black
        secondRewardImage.image = #imageLiteral(resourceName: "BlackTshirt")
        secondRewardView.borderColor = .black
    }
    func thirdSenaryo() {
        secondSenaryo()
        points10000.textColor = .black
        point3.textColor = .black
        finalRewardImage.image = #imageLiteral(resourceName: "BlackCup")
        finalrewardView.borderColor = .black
    }
    
    func undo3rdSenaryo() {
        points10000.textColor = gray
        point3.textColor = gray
        finalRewardImage.image = #imageLiteral(resourceName: "WhiteCup")
        finalrewardView.borderColor = gray
    }
    func undo2rdSenaryo() {
        undo3rdSenaryo()
        points5000.textColor = gray
        point2.textColor = gray
        secondRewardImage.image = #imageLiteral(resourceName: "WhiteTshirt")
        secondRewardView.borderColor = gray
    }
    func undo1rdSenaryo() {
        undo2rdSenaryo()
        points1000.textColor = gray
        point1.textColor = gray
        firstRewardImage.image = #imageLiteral(resourceName: "WhiteFootball")
        firstRewardView.borderColor = gray
    }
}
