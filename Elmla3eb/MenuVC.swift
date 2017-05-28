//
//  MenuVC.swift
//  Elmla3eb
//
//  Created by Macbook Pro on 3/22/17.
//  Copyright © 2017 Killvak. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import Alamofire
import AlamofireImage

class MenuVC: UIViewController {
    
    @IBOutlet weak var homeBtnCenterX: NSLayoutConstraint!
    @IBOutlet weak var searchBtnCenterX: NSLayoutConstraint!
    @IBOutlet weak var changeLangBtnCenterX: NSLayoutConstraint!
    @IBOutlet weak var backButtonImage: UIImageView!
    @IBOutlet weak var settingsBtnCenterX: NSLayoutConstraint!
    @IBOutlet weak var playerNameLabel: UILabel!{
        didSet {
            if let name = UserDefaults.standard.value(forKey: "userName") as? String{
                playerNameLabel?.text = name
            }else  if let email = UserDefaults.standard.value(forKey: "userEmail") as? String{
                playerNameLabel?.text = email
            }
        }
    }
    
    
    @IBOutlet weak var profileImage: UIImageViewX!
    @IBOutlet weak var userTypeLbl: UILabel!{
        didSet {
            userTypeLbl?.text = ""
        }
    }
    
    @IBOutlet weak var signoutBottomConstant: NSLayoutConstraint!
    
    var signoutBtnLocation : CGFloat!
    var homeBtnLoc : CGFloat!
    var searchBtnLoc : CGFloat!
    var settingBtnLoc : CGFloat!
    var changeLangLoc : CGFloat!
    private var currentTag = 0
    var currentPage : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
         currentTag = turnCurrentPageNameToTag(currentPage)
        print("that's the nib name ; \(currentPage)")
        if L102Language.currentAppleLanguage() == "ar" {
             backButtonImage.transform = CGAffineTransform(rotationAngle: CGFloat(M_PI ))
            
        }
        // Do any additional setup after loading the view.let email = UserDefaults.standard.value(forKey: "userEmail") as? String ,
         guard   let imageurl = UserDefaults.standard.value(forKey: "profileImage") as? String else { return }
        guard let url = URL(string: imageurl ) else { return }
        self.profileImage.af_setImage(
            withURL: url,
            placeholderImage: UIImage(named: "nobody_m.original"),
            filter: nil,
            imageTransition: .crossDissolve(0.2)
        )
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setupAnimation()
        //        let backButton = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: navigationController, action: nil)
        //        navigationItem.leftBarButtonItem = backButton
        //        self.navigationItem.hidesBackButton = true
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.startAnimation()
     }
    
 private func goTOProfileVC() {
        print("Image Tapped ")
         let x = ProfileVC()
        let navb = UINavigationController(rootViewController: x)
        self.present(navb, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func signouBtnAct(_ sender: UIButton) {
        let user = MUserData()
 
        user.postLogout {   (data) in
            if data.1 {
                DispatchQueue.main.async{
                    ad.saveUserLogginData(email: nil, photoUrl: nil , uid : nil, name : nil )
                    print("that is the facToken : \(FBSDKAccessToken.current())\n \(FBSDKProfile.current())")
                    let manager = FBSDKLoginManager()
                    manager.logOut()
                    FBSDKAccessToken.setCurrent(nil)
                    FBSDKProfile.setCurrent(nil)
                    ad.reloadApp()   
                }
            }else {
                ad.showAlert("default","")
            }
        }
       
        
    }
    
    @IBAction func listOfViewsDestinations(_ sender: UIButton) {
        
        guard sender.tag != currentTag else {
            dismiss(animated: true, completion: nil)
            return
        }
        switch sender.tag {
        case 1 :
            print("2nd Btn")
            //SearchVC
            let searchVC = SearchVC(nibName: "SearchVC", bundle: nil)
               let navb = UINavigationController(rootViewController: searchVC)
            self.present(navb, animated: true, completion: nil)
        case 2 :
            print("3rd Btn Settings")
            self.goTOProfileVC()
        case 3:
            self.goTOProfileVC()
        case -1 :
            changeLanguage()
//            let storyb = UIStoryboard(name: "Main", bundle: Bundle.main)
//            let vc = storyb.instantiateViewController(withIdentifier: "PlayFieldsVC") as! PlayFieldsVC
//            let navb = UINavigationController(rootViewController: vc)
//            self.present(navb, animated: true, completion: nil)
        default :
//            let x = ProfileVC()
//            let navb = UINavigationController(rootViewController: x)
//            self.present(navb, animated: true, completion: nil)

            let storyb = UIStoryboard(name: "Main", bundle: Bundle.main)
            let x = storyb.instantiateViewController(withIdentifier: "MainPageVC")
            let navb = UINavigationController(rootViewController: x)
            self.present(navb, animated: true, completion: nil)

//            dismiss(animated: true, completion: nil)
        }
    }
    
    func changeLanguage() {
        var transition: UIViewAnimationOptions = .transitionFlipFromLeft
        if L102Language.currentAppleLanguage() == "en" {
            L102Language.setAppleLAnguageTo(lang: "ar")
            UIView.appearance().semanticContentAttribute = .forceRightToLeft
        } else {
            L102Language.setAppleLAnguageTo(lang: "en")
            transition = .transitionFlipFromRight
            UIView.appearance().semanticContentAttribute = .forceLeftToRight
        }
        let rootviewcontroller: UIWindow = ((UIApplication.shared.delegate?.window)!)!
        let storyb = UIStoryboard(name: "Main", bundle: Bundle.main)
        rootviewcontroller.rootViewController = storyb.instantiateViewController(withIdentifier: "rootNav")
        let mainwindow = (UIApplication.shared.delegate?.window!)!
        mainwindow.backgroundColor = UIColor(hue: 0.6477, saturation: 0.6314, brightness: 0.6077, alpha: 0.8)
        UIView.transition(with: mainwindow, duration: 0.55001, options: transition, animations: { () -> Void in
        }) { (finished) -> Void in
            
            
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
   private func turnCurrentPageNameToTag(_ name: String?) -> Int{
        guard let name = name else { return 0 }
        switch name {
        case "Profile":
            return 3
        case "Search" :
            return 1
        default:
             return 0
            
        }
    }
    
}



extension MenuVC {
//    func startAnimation() { }
    func startAnimation() {
        UIView.animate(withDuration: 0.8, delay: 0.3, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: .allowUserInteraction, animations: {
            self.profileImage.transform = CGAffineTransform.identity
        }, completion: nil)
        
        UIView.animate(withDuration: 0.6, delay: 0.5, options: [.curveEaseIn], animations: {
            self.playerNameLabel.alpha = 1
            self.userTypeLbl.alpha = 1
        })
        UIView.animate(withDuration: 1.3, delay: 0.6, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: [.curveEaseIn , .allowUserInteraction], animations: {
            self.homeBtnCenterX.constant = self.homeBtnLoc
            self.view.layoutIfNeeded()
        })
        
        UIView.animate(withDuration: 1.1, delay: 0.9, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: [.curveEaseIn , .allowUserInteraction], animations: {
            self.searchBtnCenterX.constant   = self.searchBtnLoc
            self.view.layoutIfNeeded()
        })
        
        UIView.animate(withDuration: 0.9, delay: 1.1, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: [.curveEaseIn , .allowUserInteraction], animations: {
            self.settingsBtnCenterX.constant  = self.settingBtnLoc
            self.view.layoutIfNeeded()
        })
        
        UIView.animate(withDuration: 0.7, delay: 1.2, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: [.curveEaseIn , .allowUserInteraction], animations: {
            self.changeLangBtnCenterX.constant = self.changeLangLoc
            self.view.layoutIfNeeded()
        })
        
        UIView.animate(withDuration: 0.5, delay: 1.3, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: [.curveEaseIn , .allowUserInteraction], animations: {
            self.signoutBottomConstant.constant = self.signoutBtnLocation
            self.view.layoutIfNeeded()
        }){ (true ) in
            self.navigationItem.setHidesBackButton(false, animated: true )
        }
    }
    
    func setupAnimation() {
        self.profileImage.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
        self.homeBtnLoc = self.homeBtnCenterX.constant
        self.searchBtnLoc = self.searchBtnCenterX.constant
        self.changeLangLoc = self.changeLangBtnCenterX.constant
        self.settingBtnLoc = self.settingsBtnCenterX.constant
        self.homeBtnCenterX.constant -= self.view.bounds.width
        self.searchBtnCenterX.constant += self.view.bounds.width
        self.changeLangBtnCenterX.constant += self.view.bounds.width
        self.settingsBtnCenterX.constant -= self.view.bounds.width
        self.signoutBtnLocation = self.signoutBottomConstant.constant
        self.signoutBottomConstant.constant -= self.view.bounds.height
    }
}

