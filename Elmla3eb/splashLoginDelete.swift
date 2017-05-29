//
//  splashLoginDelete.swift
//  Elmla3eb
//
//  Created by Macbook Pro on 4/4/17.
//  Copyright © 2017 Killvak. All rights reserved.
//

/*
 let animationD = 0.5
 
 
 override func viewDidAppear(_ animated: Bool) {
 super.viewDidAppear(animated)
 UIView.animate(withDuration: 0.8, animations: {
 self.ballTopConstrain.constant += 200
 self.ballImage.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
 self.ballImage.transform = CGAffineTransform(scaleX: 1  , y: 1)
 self.view.layoutIfNeeded()
 }){ (true) in
 UIView.animate(withDuration: self.animationD, animations: {
 self.ballImage.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
 self.ballTopConstrain.constant -= 150
 self.view.layoutIfNeeded()
 })
 UIView.animate(withDuration: self.animationD , delay: 0.3, animations: {
 self.ballImage.transform = .identity
 self.view.layoutIfNeeded()
 })
 }
 
 }
 */
/*
 
 
 //spining ball
 //
 //  SplashLoginVC.swift
 //  Elmla3eb
 //
 //  Created by Macbook Pro on 4/3/17.
 //  Copyright © 2017 Killvak. All rights reserved.
 //
 
 import UIKit
 
 class SplashLoginVC: UIViewController {
 
 @IBOutlet weak var ballTopConstrain: NSLayoutConstraint!
 @IBOutlet weak var signinTopSpace: NSLayoutConstraint!
 @IBOutlet weak var signupBtn: UIButtonX!
 @IBOutlet weak var signinBtn: UIButtonX!
 @IBOutlet weak var ballImage: UIImageView!
 
 var originalBallLocation : CGFloat!
 override func viewWillAppear(_ animated: Bool) {
 super.viewWillAppear(animated)
 signinBtn.alpha = 0
 signupBtn.alpha = 0
 originalBallLocation = self.ballTopConstrain.constant
 self.ballTopConstrain.constant += self.view.bounds.height
 self.ballImage.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
 
 }
 override func viewDidLoad() {
 super.viewDidLoad()
 
 // Do any additional setup after loading the view.
 
 signinBtn.addTarget(self, action: #selector(self.animate), for: .touchUpInside  )
 
 }
 
 func animate() {
 
 UIView.animate(withDuration: 1.5, delay: 0.0, usingSpringWithDamping: 0, initialSpringVelocity: 0, options: [.curveEaseOut], animations: {
 self.ballTopConstrain.constant = self.originalBallLocation
 })
 }
 
 override func didReceiveMemoryWarning() {
 super.didReceiveMemoryWarning()
 // Dispose of any resources that can be recreated.
 }
 let animationD = 0.23
 override func viewDidAppear(_ animated: Bool) {
 super.viewDidAppear(animated)
 UIView.animate(withDuration: 0.4, animations: {
 self.ballTopConstrain.constant -= self.view.bounds.height
 self.ballImage.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
 self.view.layoutIfNeeded()
 }){ (true ) in
 //        UIView.animate(withDuration: self.animationD  , animations: {
 //            self.ballTopConstrain.constant += 170
 //            self.view.layoutIfNeeded()
 //        } ) { (true) in
 //            UIView.animate(withDuration: self.animationD, animations: {
 //                self.ballTopConstrain.constant -= 170
 //                self.view.layoutIfNeeded()
 //            } ) { (true) in
 UIView.animate(withDuration: self.animationD + 0.2, animations: {
 self.ballTopConstrain.constant += 150
 self.ballImage.transform = .identity
 
 self.view.layoutIfNeeded()
 } ) { (true) in
 UIView.animate(withDuration: self.animationD + 0.2, animations: {
 self.ballTopConstrain.constant -= 150
 self.view.layoutIfNeeded()
 } ) { (true) in
 UIView.animate(withDuration: self.animationD + 0.1, animations: {
 self.ballTopConstrain.constant += 75
 self.view.layoutIfNeeded()
 } ) { (true) in
 UIView.animate(withDuration: self.animationD , animations: {
 self.ballTopConstrain.constant -= 75
 self.view.layoutIfNeeded()
 } ) { (true) in
 UIView.animate(withDuration: self.animationD, delay: 0.0, usingSpringWithDamping: 0, initialSpringVelocity: 0, options: [.curveEaseOut], animations: {
 self.ballTopConstrain.constant += 37.5
 self.view.layoutIfNeeded()
 } ) { (true) in
 UIView.animate(withDuration: self.animationD, delay: 0.0, usingSpringWithDamping: 0, initialSpringVelocity: 0, options: [.curveEaseOut], animations: {
 self.ballTopConstrain.constant -= 37.5
 self.view.layoutIfNeeded()
 } )
 }
 }
 }
 }
 }
 }
 }//}}
 /*
 // MARK: - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
 // Get the new view controller using segue.destinationViewController.
 // Pass the selected object to the new view controller.
 }
 */
 
 }

 */
