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
import CDAlertView


class MenuVC: UIViewController {
    
    @IBOutlet weak var loggingOutView: UIView!
    @IBOutlet weak var loadingLabel: UILabel!
    @IBOutlet weak var loadingActivity: UIActivityIndicatorView!
    @IBOutlet weak var homeBtnCenterX: NSLayoutConstraint!
    @IBOutlet weak var searchBtnCenterX: NSLayoutConstraint!
    @IBOutlet weak var changeLangBtnCenterX: NSLayoutConstraint!
    @IBOutlet weak var backButtonImage: UIImageView!
    @IBOutlet weak var settingsBtnCenterX: NSLayoutConstraint!
    @IBOutlet weak var profileImageHeightLayOut: NSLayoutConstraint!
    @IBOutlet weak var singoutBtnOL: UIButton!
    @IBOutlet weak var playgroundsBtn: UIButton!

    @IBOutlet weak var playerNameLabel: UILabel!{
        didSet {
           
            if let name = UserDefaults.standard.value(forKey: "usreName") as? String{
                playerNameLabel?.text = name
            }else  if let email = UserDefaults.standard.value(forKey: "userEmail") as? String{
                playerNameLabel?.text = email
            }else {
                playerNameLabel?.text = " "
            }
        }
    }
    
    
    @IBOutlet weak var profileImage: UIImageViewX!
    @IBOutlet weak var userTypeLbl: UILabel!{
        didSet {
            guard let userType = UserDefaults.standard.value(forKey: "User_Type") as? String  else {
                userTypeLbl?.text = ""
                return
            }
            if   userType == "pg_owner" {
                userTypeLbl?.text =  langDicClass().getLocalizedTitle("Owner" )
            }else  if userType == "player" {
                userTypeLbl?.text =  langDicClass().getLocalizedTitle("Player") 
            }else {
                userTypeLbl?.text = ""
            }
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
//        print("that's the nib name ; \(String(describing: currentPage))")
        if L102Language.currentAppleLanguage() == "ar" {
             backButtonImage.transform = CGAffineTransform(rotationAngle: CGFloat(M_PI ))
            
        }
        // Do any additional setup after loading the view.let email = UserDefaults.standard.value(forKey: "userEmail") as? String ,
        var name : String = ""
        if let userType = UserDefaults.standard.value(forKey: "User_Type") as? String  , userType == "pg_owner" {
              name = langDicClass().getLocalizedTitle("Playground Management")
            
        }else {
              name = langDicClass().getLocalizedTitle("Nearby Fields & bookings")
        }
        playgroundsBtn.setTitle(name, for: .normal)

        
        let userLogged = ad.isUserLoggedIn()
        if !userLogged   {
         singoutBtnOL.alpha = 0
        }
    }
    
     override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setupAnimation()
        loadImage()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.startAnimation()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.profileImage.layer.cornerRadius =  profileImage.bounds.size.width   / 2
        self.profileImage.clipsToBounds = true
    }
    
    
 
    func loadImage() {
        guard   let imageurl = UserDefaults.standard.value(forKey: "profileImage") as? String else {
//            print("that's the image : nil : \(UserDefaults.standard.value(forKey: "profileImage") as? String) ")
            return }
         guard let url = URL(string: imageurl ) else { return }
        self.profileImage.af_setImage(
            withURL: url,
            placeholderImage: UIImage(named: "nobody_m.original"),
            filter: nil,
            imageTransition: .crossDissolve(0.2)
        )
        
//        print("That's the new image url : \(imageurl)")
    }

    
 private func goTOProfileVC() {
//        print("Image Tapped ")
//         let x = ProfileVC()
//        let navb = UINavigationController(rootViewController: x)
//        self.present(navb, animated: true, completion: nil)
    let userLogged = ad.isUserLoggedIn()
    guard userLogged else {
        let storyb = UIStoryboard(name: "Main", bundle: Bundle.main)
        let vc = storyb.instantiateViewController(withIdentifier: "SplashLoginVC") as! SplashLoginVC
         self.present(vc, animated: true, completion: nil)
        return 
    }
    let storyb = UIStoryboard(name: "Main", bundle: Bundle.main)
    let x = storyb.instantiateViewController(withIdentifier: "ProfileVC") as! ProfileVC
//    x.profileImageDelegate = self
    let navb = UINavigationController(rootViewController: x)
    self.present(navb, animated: true, completion: nil)
    }
    
    
    private func goTOPlayerPG() {
 //OwnerPlaygroundsVC
       let userLogged = ad.isUserLoggedIn()
        guard userLogged else {
            let storyb = UIStoryboard(name: "Main", bundle: Bundle.main)
            let vc = storyb.instantiateViewController(withIdentifier: "SplashLoginVC") as! SplashLoginVC
            self.present(vc, animated: true, completion: nil)
            return
        }
//        print("that's the pg_type : \(UserDefaults.standard.value(forKey: "User_Type") )")
        if let userType = UserDefaults.standard.value(forKey: "User_Type") as? String  , userType == "pg_owner" {
            let storyb = UIStoryboard(name: "Main", bundle: Bundle.main)
            let x = storyb.instantiateViewController(withIdentifier: "OwnerPlaygroundsVC") as! OwnerPlaygroundsVC
            let navb = UINavigationController(rootViewController: x)
            self.present(navb, animated: true, completion: nil)
        }else {
        let storyb = UIStoryboard(name: "Main", bundle: Bundle.main)
        let x = storyb.instantiateViewController(withIdentifier: "PlayFieldsVC") as! PlayFieldsVC
        let navb = UINavigationController(rootViewController: x)
        self.present(navb, animated: true, completion: nil)
        
        }
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func signouBtnAct(_ sender: UIButton) {
        print("that is the facToken : \(FBSDKAccessToken.current())\n \(FBSDKProfile.current()) \n andthat's the id :\(USER_ID)")

        ad.confirmationAlert("Logging out!!", "proceed with the process?") {
            
            self.loggoutAction()

        }
    }
    
    
 
    
    func loggoutAction() {
        let user = MUserData()
        setUIEnabled(false)
        view.isUserInteractionEnabled = false
        
        
        user.postLogout { [weak self ]  (data) in
            if data.1 {
                DispatchQueue.main.async{
                    ad.saveUserLogginData(email: nil, photoUrl: nil , uid : nil, name : nil )
//                    print("that is the facToken : \(FBSDKAccessToken.current())\n \(FBSDKProfile.current()) \n andthat's the id :\(USER_ID)")
                    let manager = FBSDKLoginManager()
                    manager.logOut()
                    FBSDKAccessToken.setCurrent(nil)
                    FBSDKProfile.setCurrent(nil)
                    UserDefaults.standard.setValue(nil, forKey: "User_Type")
                    self?.view.isUserInteractionEnabled = true
                    self?.setUIEnabled(true)
//                    self?.dismiss(animated: true, completion: nil)
                    ad.reload()
                }
            }else {
                guard  !data.0.contains("User not found") else {
                    DispatchQueue.main.async{
                        ad.saveUserLogginData(email: nil, photoUrl: nil , uid : nil, name : nil )
                        //                    print("that is the facToken : \(FBSDKAccessToken.current())\n \(FBSDKProfile.current()) \n andthat's the id :\(USER_ID)")
                        let manager = FBSDKLoginManager()
                        manager.logOut()
                        FBSDKAccessToken.setCurrent(nil)
                        FBSDKProfile.setCurrent(nil)
                        UserDefaults.standard.setValue(nil, forKey: "User_Type")
                        self?.view.isUserInteractionEnabled = true
                        self?.setUIEnabled(true)
                        //                    self?.dismiss(animated: true, completion: nil)
                        ad.reload()
                    }
                    return
                }
                DispatchQueue.main.async{
                    self?.setUIEnabled(true)
                    ad.showAlert("default","")
//                    print("that is the  Token :  \( UserDefaults.standard.value(forKey: "FCMToken") as? String) \n andthat's the id :\(USER_ID)")

                    self?.view.isUserInteractionEnabled = true
                }
            }
        }
    }
    
    func setUIEnabled(_ state : Bool) {
        
        if state {
            self.loadingActivity.stopAnimating()
            self.loggingOutView.alpha = 0
            self.loadingLabel.alpha = 0
        }else {
            self.loadingActivity.startAnimating()
            self.loggingOutView.alpha = 1
            self.loadingLabel.alpha = 1
        }
    }
    
    @IBAction func listOfViewsDestinations(_ sender: UIButton) {
        
        guard sender.tag != currentTag else {
            dismiss(animated: true, completion: nil)
            return
        }
        switch sender.tag {
        case 1 :
//            print("2nd Btn")
            //SearchVC
            let searchVC = SearchVC(nibName: "SearchVC", bundle: nil)
               let navb = UINavigationController(rootViewController: searchVC)
            self.present(navb, animated: true, completion: nil)
        case 2 :
//            print("3rd Btn Settings")
            self.goTOPlayerPG()
//            self.goTOProfileVC()

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
  
//        self.delegate?.changeLang()

//    dismiss(animated: true) { 
        MainPageVC.mainStaticVC?.changeLang()
//        }
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
        case "NearBy" :
            return 2
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
        self.playerNameLabel.alpha = 0
        self.userTypeLbl.alpha = 0
    }
}



//
//extension MenuVC : profileupdatedImageDelegate {
//    
//    func delegateUpdate() {
//        
//        loadImage()
//    }
//}
