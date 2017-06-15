//
//  ExtLogin2.swift
//  HyperApp
//
//  Created by Killvak on 06/01/2017.
//  Copyright © 2017 Killvak. All rights reserved.
//

import Foundation
import FBSDKLoginKit


extension LoginVC  :   FBSDKLoginButtonDelegate  {
    
    
    
    //MARK: - Facebook deledate Protocoal
    
    @IBAction func fbLoginBtnAct(_ sender: AnyObject) {
        FBSDKLoginManager().logIn(withReadPermissions: ["email","public_profile"], from: self) { (result, err ) in
            if err != nil {
                print("Custom FB Login failed : \(err)")
                self.setUIEnabled(enabled: true)
                return
            }
            //            print(result?.token.tokenString)
            self.setUIEnabled(enabled: false)
            self.showFbEmailAddress()
        }
    }
    
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        print("Did log out of facebook")
    }
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        self.setUIEnabled(enabled: false )
        if error != nil {
            print(error)
            self.setUIEnabled(enabled: true)
            return
        }
        
        print("Successfully logged in with facebook...")
        
        showFbEmailAddress()
    }
   
    func showFbEmailAddress(){
        self.setUIEnabled(enabled: false)
        fbActivityInd.startAnimating()
        FBSDKGraphRequest(graphPath: "/me", parameters: ["fields":"id, name, email,first_name,last_name,picture"]).start { [ weak self ] (connection, result, err) in
            
            if err != nil {
                DispatchQueue.main.async {
                self?.fbActivityInd.stopAnimating()
                self?.setUIEnabled(enabled: true)
                print("failed to start graph request :  \(err)")
                }
            }else {
                
                let resultD = result as? NSDictionary
                if let result = resultD {
                    print("that's the result : \(result)")
                    guard let id = result["id"] as? String , let fName = result["first_name"] as? String  else {
                        DispatchQueue.main.async {
                            self?.showAlert(langDicClass().getLocalizedTitle("Something Went Wrong"), langDicClass().getLocalizedTitle("try again!!"))
                            self?.fbActivityInd.stopAnimating()
                            self?.setUIEnabled(enabled: true )
                        }
                        return
                    }
                    print(id)
                    //                    self.afterLogginUserName.text = fName.capitalized
                    let url = "http://graph.facebook.com/\(id)/picture?type=large"
//                    let imageURL = URL(string: url )
//                    let imageString : String =  "\(imageURL!)"
                    self?.fbId = id
                    self?.fbImage = url
                    if  let email  = result["email"] as? String {
                    self?.fbEmail = email
                    }
                    print("that is facebook data \(id) \(fName) \(self?.fbEmail) ")
                    DispatchQueue.main.async {
                        self?.setupFbLogin("", "", id)
                        self?.fbActivityInd.stopAnimating()
                    }
                    //                    self.afterLogginView.fadeIn(duration: 1.5, delay: 0, completion: { (finished: Bool) in
                   
                    //Gon Commit
//                    ad.saveUserLogginData(email: email, photoUrl: imageString , uid : 0,name: fName)
//                    ad.reloadApp()
//                    self.performSegue(withIdentifier: "LoggedInSegue", sender: self)

                    //                    })
                }
            }
        }
    }
    
    //@End FB Delegate
    
    @IBAction func cancelFbMobileVerif(_ sender: UIButtonX? = nil ) {
        dismissView()
        ad.saveUserLogginData(email: nil, photoUrl: nil , uid : nil, name : nil )
        fbLogOut()
        setUIEnabled(enabled: true)
        fbActivityInd.stopAnimating()
    }
    
    
    func fbLogOut() {
        print("that is the facToken : \(FBSDKAccessToken.current()) )")
        let manager = FBSDKLoginManager()
        manager.logOut()
        if FBSDKAccessToken.current() != nil {

            FBSDKAccessToken.setCurrent(nil)
            FBSDKProfile.setCurrent(nil)
        }
    }
    
    
    
    @IBAction func sendFbData(_ sender: UIButtonX) {
        
        if let phone =  fbPhoneTxt.text, phone.validPhoneNumber , let image = fbImage , let id = fbId {
            fbMobile = phone
            setupFbLogin(phone, image, id)
        }else {
            showAlert(langDicClass().getLocalizedTitle("Something Went Wrong"), langDicClass().getLocalizedTitle("Phone number isn't in a Correct Format"))
        }
        
    }
    
    
    func setupFbLogin(_ mobile : String,_ image:String,_ id : String) {
        let user = MUserData()
        fbActivityInd.startAnimating()
//        if fbMobile == nil , let email = fbEmail , email.validPhoneNumber {
//         fbMobile = email
//        }
//        guard let mobile = fbMobile ,let image = fbImage , let id = fbId else {
//            self.setupfbMobileNumView()
//            return
//        }

        user.postFaceBLogin(mobile: mobile, image: image, fbID:id , completed: { [weak weakSelf = self ] (data, codeVerification, sms ) in
            print("that's the sms : \(sms)")
            guard !sms.contains("resend with valid") else {
                DispatchQueue.main.async {
                    weakSelf?.setupfbMobileNumView()
                }
                return
            }
            guard  let data = data , let id = data["id"] as? Int  , let name = data["name"] as? String else {
                weakSelf?.fbActivityInd.stopAnimating()
                weakSelf?.showAlert(langDicClass().getLocalizedTitle("Something Went Wrong"), langDicClass().getLocalizedTitle("try again!!"))
                return
            }
            
            guard !codeVerification else {
                ad.saveUserLogginData(email: nil, photoUrl: nil, uid: id, name : name)
                UserDefaults.standard.setValue("player", forKey: "User_Type")
                ad.reloadApp()

//                weakSelf?.performSegue(withIdentifier: "LoggedInSegue", sender:weakSelf)
                return
            }
        
                let vc = CheckPhoneValidVC(nibName: "CheckPhoneValidVC", bundle: nil)
                vc.modalTransitionStyle = .crossDissolve
                vc.userId = id
                vc.userName = name
            vc.codeVerfication = true 
                weakSelf?.present(vc, animated: true, completion: nil)
          
        })
    }
    
}
