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
    
    @IBOutlet weak var signupBtn: UIButton!
    @IBOutlet weak var ballImageXConstraint: NSLayoutConstraint!
    @IBOutlet weak var signinBtn: UIButton!
    @IBOutlet weak var ballImage: UIImageView!
    @IBOutlet weak var ballImageVIEW: UIView!
    @IBOutlet weak var activityIndector: UIActivityIndicatorView!
    @IBOutlet weak var skipLoginBtn: UIButton!

       var startingAnimation : (){
        self.ballImageVIEW?.isUserInteractionEnabled = false
    }
    var DoneWithAnimation : () {
        self.ballImageVIEW?.isUserInteractionEnabled = true
    }
    var originalBallLocation : CGFloat!
    let animationD = 0.35

    override func viewDidLoad() {
        super.viewDidLoad()
        setUIEnabled(false )
        // Do any additional setup after loading the view.
        DispatchQueue.main.asyncAfter(deadline: .now() + 2)  {            // Code
            self.signinBtn.addTarget(self, action: #selector(self.animateToOriginal), for: .touchUpInside  )
            self.ballImageVIEW.isUserInteractionEnabled = false
            self.setUIEnabled(true )
        }
        
        
        
    }
    
    
    
    func  setUIEnabled(_ enabled:Bool) {
        
        if enabled {
            activityIndector.stopAnimating()
            signupBtn.alpha = 1
            signinBtn.alpha = 1
             
            signupBtn.isEnabled = true
            signinBtn.isEnabled = true
            
            skipLoginBtn.alpha = 1
            skipLoginBtn.isEnabled = true 
        }else {
            activityIndector.startAnimating()
            signupBtn.alpha = 0.5
            signinBtn.alpha = 0.5
            
            signupBtn.isEnabled = false
            signinBtn.isEnabled = false
            skipLoginBtn.alpha = 0.5
            skipLoginBtn.isEnabled = false
            //            signBtnOL.alpha = 0.5
            //            dissMissView.alpha = 0.5
        }
        
    }
    

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        originalBallLocation = self.ballTopConstrain.constant
        //        self.ballTopConstrain.constant -= 50
        //        self.ballImage.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
        //        self.ballImage.transform = CGAffineTransform(scaleX: 0.1  , y: 0.1)
        
       setupSplashLoginAnimation()
        
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture(gesture:)))
        swipeRight.direction = UISwipeGestureRecognizerDirection.right
        self.ballImageVIEW.addGestureRecognizer(swipeRight)
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture(gesture:)))
        swipeLeft.direction = UISwipeGestureRecognizerDirection.left
        self.ballImageVIEW.addGestureRecognizer(swipeLeft)
        
        let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture(gesture:)))
        swipeUp.direction = UISwipeGestureRecognizerDirection.up
        self.ballImageVIEW.addGestureRecognizer(swipeUp)
        
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipeDown.direction = UISwipeGestureRecognizerDirection.down
        self.ballImageVIEW.addGestureRecognizer(swipeDown)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(randomAnimation))
        self.ballImageVIEW.addGestureRecognizer(tap)
        
    }
 
    func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            startingAnimation
            switch swipeGesture.direction {
            case UISwipeGestureRecognizerDirection.right:
                print("Swiped right")
                //                self.animat1()
                self.animateToRight()
            case UISwipeGestureRecognizerDirection.down:
                print("Swiped down")
                self.animateDown()
            case UISwipeGestureRecognizerDirection.left:
                print("Swiped left")
                self.animateLeft()
            case UISwipeGestureRecognizerDirection.up:
                print("Swiped up")
                self.animateUp()
            default:
                self.animateLeft()
                break
            }

        }
    }

    
  
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        startingAnimation
        self.upAnimation()
        
        //@Test_back_End
        ////        TestBackEnd.HOmePage()
//                TestBackEnd.PLayField_INfo()
        //        TestBackEnd.PlaygNews()
        //        TestBackEnd.playgTimes()
        //        TestBackEnd.playGrounds()
        //        TestBackEnd.playgTeams()
        //        TestBackEnd.User()
        //@End_Test_back_End
    }
    
    func setupSplashLoginAnimation() {
        self.ballTopConstrain.constant += self.view.bounds.height
        self.ballImage.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
        self.ballImage.transform = CGAffineTransform(scaleX: 0.1  , y: 0.1)
    }
    
    func animateToOriginal() {
        
        UIView.animate(withDuration: 1.5, delay: 0.0, usingSpringWithDamping: 0, initialSpringVelocity: 0, options: [.curveEaseInOut], animations: {
            self.ballTopConstrain.constant = self.originalBallLocation
        })
    }

    func upAnimation() {
        UIView.animate(withDuration: 0.5, animations: {
            self.ballTopConstrain.constant -= self.view.bounds.height
            self.ballImage.transform = .identity
            self.view.layoutIfNeeded()
        }){ [ unowned self ] (true) in
            //            UIView.animate(withDuration: self.animationD, animations: {
            //            self.ballTopConstrain.constant -= 100
            //            self.view.layoutIfNeeded()
            //            })
            ////            UIView.animate(withDuration: self.animationD , delay: 0.3, animations: {
            ////                self.ballImage.transform = .identity
            ////                self.view.layoutIfNeeded()
            ////            })
            //            { (true) in
            
            UIView.animate(withDuration: self.animationD    , animations: {
                self.ballTopConstrain.constant += 150
                self.ballImage.transform = CGAffineTransform(rotationAngle: CGFloat.pi )
                
                self.view.layoutIfNeeded()
            } )
            UIView.animate(withDuration: self.animationD , delay: self.animationD / 2  , animations: {
                self.ballImage.transform = .identity
                
                
                self.view.layoutIfNeeded()
            } )
            
            
            
            UIView.animate(withDuration: self.animationD    , delay: self.animationD  , animations: {
                self.ballTopConstrain.constant -= 150
                //                    self.ballImage.transform = .identity
                
                self.view.layoutIfNeeded()
            } )
            
            UIView.animate(withDuration: self.animationD   , delay: self.animationD * 2, animations: {
                self.ballTopConstrain.constant += 75
                self.ballImage.transform = CGAffineTransform(rotationAngle: CGFloat.pi )
                //                self.ballImage.transform = .identity
                
                self.view.layoutIfNeeded()
            } )
            UIView.animate(withDuration: self.animationD   , delay: self.animationD * 3 , animations: {
                self.ballTopConstrain.constant -= 75
                //                                    self.ballImage.transform = .identity
                
                self.view.layoutIfNeeded()
            } )
            UIView.animate(withDuration: self.animationD  , delay: self.animationD * 4, usingSpringWithDamping: 0, initialSpringVelocity: 0, options: [], animations: {
                self.ballTopConstrain.constant += 37.5
                //                                        self.ballImage.transform = CGAffineTransform(rotationAngle: CGFloat.pi )
                //                self.ballImage.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
                //                self.ballImage.transform = .identity
                
                self.view.layoutIfNeeded()
            } )
            UIView.animate(withDuration: self.animationD   , delay: self.animationD * 5, animations: {
                self.ballTopConstrain.constant -= 37.5
                //                                                            self.ballImage.transform = .identity
                //                self.ballImage.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
                self.ballImage.transform = .identity
                
                self.view.layoutIfNeeded()
            } ){ (true) in self.DoneWithAnimation }
            //                {(true) in
            //                UIView.animate(withDuration: 1.5, delay: self.animationD * 7 , usingSpringWithDamping: 0.5, initialSpringVelocity: 0.3, options: [], animations: {
            //
            //                    self.view.layoutIfNeeded()
            //                })
            //            }
            
            
            
            
        }
        
    }
    
    func animateToRight() {
        UIView.animate(withDuration: 1.5, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.3, options: [.curveEaseIn], animations: {
            self.ballImage.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
            self.ballImageXConstraint.constant += self.view.bounds.width
            
            self.view.layoutIfNeeded()
        }){ [ unowned self ] (true) in
            self.ballImageXConstraint.constant -= self.view.bounds.width * 2
            self.view.layoutIfNeeded()
            
            UIView.animate(withDuration: 1.1, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.3, options: [.curveEaseIn], animations: {
                self.ballImage.transform = .identity
                self.ballImageXConstraint.constant += self.view.bounds.width
                
                self.view.layoutIfNeeded()
            }){ (true) in
                
                UIView.animate(withDuration: 1, animations: {
                    
                    self.ballImage.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
                    
                    self.view.layoutIfNeeded()
                })
                UIView.animate(withDuration: 1.7, delay: 0.5  , usingSpringWithDamping: 0.5, initialSpringVelocity: 0.3, options: [.curveEaseIn], animations: {
                    self.ballImage.transform = .identity
                    
                    self.view.layoutIfNeeded()
                }){ (true) in self.DoneWithAnimation }
                
            }
        }
    }
    
    func randomAnimation() {
    startingAnimation
        let diceRoll = Int(arc4random_uniform(5) )
        switch diceRoll {
        case 0 : animateUp()
        case 1 : animateDown()
        case 2 : animateToRight()
        case 3 : animateLeft()
        default:
            animate4()
        }
        DoneWithAnimation
    }
    
    func animateUp() {
        self.ballTopConstrain.constant -= 50
        self.ballImage.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
        self.ballImage.transform = CGAffineTransform(scaleX: 0.1  , y: 0.1)
        
         //        let animationD = 0.5
        
        UIView.animate(withDuration: 0.8, animations: {
            self.ballTopConstrain.constant += 150
            self.ballImage.transform = CGAffineTransform(rotationAngle: CGFloat.pi * -1 )
            self.ballImage.transform = CGAffineTransform(scaleX: 1  , y: 1)
            self.view.layoutIfNeeded()
        }){ [unowned self](true) in
            UIView.animate(withDuration: self.animationD, animations: {
                self.ballTopConstrain.constant -= 100
                self.view.layoutIfNeeded()
            })
                //            UIView.animate(withDuration: self.animationD , delay: 0.3, animations: {
                //                self.ballImage.transform = .identity
                //                self.view.layoutIfNeeded()
                //            })
            { (true) in
                
                
                
                UIView.animate(withDuration: self.animationD + 0.1, animations: {
                    self.ballTopConstrain.constant += 75
                    self.view.layoutIfNeeded()
                } ) { (true) in
                    UIView.animate(withDuration: self.animationD , animations: {
                        self.ballTopConstrain.constant -= 75
                        self.view.layoutIfNeeded()
                    } ) { (true) in
                        UIView.animate(withDuration: self.animationD - 0.05, delay: 0.0, usingSpringWithDamping: 0, initialSpringVelocity: 0, options: [.curveEaseOut], animations: {
                            self.ballTopConstrain.constant += 37.5
                            self.view.layoutIfNeeded()
                        } ) { (true) in
                            UIView.animate(withDuration: self.animationD - 0.05, delay: 0.0, usingSpringWithDamping: 0, initialSpringVelocity: 0, options: [.curveEaseOut], animations: {
                                self.ballTopConstrain.constant -= 37.5
                                self.view.layoutIfNeeded()
                            } ){ (true) in self.DoneWithAnimation }
                        }
                    }}
                
                
            }
        }
        
        
    }
    
    func animateDown() {
        
         self.ballTopConstrain.constant += self.view.bounds.height
        self.ballImage.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
        self.ballImage.transform = CGAffineTransform(scaleX: 0.1  , y: 0.1)
        
        UIView.animate(withDuration: 0.8, animations: {
            //             self.ballTopConstrain.constant += 200
            self.ballImage.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
            self.ballImage.transform = CGAffineTransform(scaleX: 1  , y: 1)
            self.view.layoutIfNeeded()
        }){ [unowned self ] (true) in
            UIView.animate(withDuration: self.animationD, animations: {
                self.ballImage.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
                self.ballTopConstrain.constant -= self.view.bounds.height
                self.view.layoutIfNeeded()
            })
            UIView.animate(withDuration: self.animationD , delay: 0.3, animations: {
                self.ballImage.transform = .identity
                self.view.layoutIfNeeded()
            }){ (true) in self.DoneWithAnimation }
        }
        
    }
    
    func animateLeft() {

        self.ballTopConstrain.constant -= 50
        self.ballImage.transform = CGAffineTransform(scaleX: 0.1  , y: 0.1)
        
        
        UIView.animate(withDuration: 0.9, animations: {
            self.ballTopConstrain.constant += 50
            self.ballImage.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
            self.ballImage.transform = CGAffineTransform(scaleX: 1  , y: 1)
            self.view.layoutIfNeeded()
        }){ [unowned self] (true) in
            self.ballImage.transform = .identity ;
            self.view.layoutIfNeeded()
            self.DoneWithAnimation
        }
        
    }
    
    func animate4() {
        self.ballTopConstrain.constant -= 50
        self.ballImage.transform = CGAffineTransform(scaleX: 0.1  , y: 0.1)
        
        let animationD = self.animationD - 0.15
        
        
        UIView.animate(withDuration: 0.5, animations: {
            self.ballTopConstrain.constant += 200
            self.ballImage.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
            self.ballImage.transform = CGAffineTransform(scaleX: 1  , y: 1)
            self.view.layoutIfNeeded()
        }){ [unowned self] (true) in
            UIView.animate(withDuration: self.animationD, animations: {
                self.ballImage.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
                self.ballTopConstrain.constant -= 150
                self.view.layoutIfNeeded()
            })
            UIView.animate(withDuration: self.animationD , delay: 0.3, animations: {
                self.ballImage.transform = .identity
                self.view.layoutIfNeeded()
            }){ (true) in self.DoneWithAnimation }
        }
        
        
    }
}
