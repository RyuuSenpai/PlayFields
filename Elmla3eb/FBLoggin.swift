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
        FBSDKGraphRequest(graphPath: "/me", parameters: ["fields":"id, name, email,first_name,last_name,picture"]).start { (connection, result, err) in
            
            if err != nil {
                self.setUIEnabled(enabled: true)
                print("failed to start graph request :  \(err)")
                
            }else {
                
                let resultD = result as? NSDictionary
                if let result = resultD {
                    
                    guard let id = result["id"] as? String , let fName = result["first_name"] as? String ,let email  = result["email"] as? String  else {
                        self.setUIEnabled(enabled: false )
                        return
                    }
                    print(id)
                    //                    self.afterLogginUserName.text = fName.capitalized
                    let imageURL = URL(string: "http://graph.facebook.com/\(id)/picture?type=large")
                    let imageString : String =  "\(imageURL!)"
                    print("that is facebook data \(id) \(fName) \(email) \(imageString)")
                    //                    self.afterLogginView.fadeIn(duration: 1.5, delay: 0, completion: { (finished: Bool) in
                    
                    ad.saveUserLogginData(email: email, photoUrl: imageString , uid : 0,name: fName)
//                    ad.reloadApp()
                    self.performSegue(withIdentifier: "LoggedInSegue", sender: self)

                    //                    })
                }
            }
        }
    }
    
    //@End FB Delegate
    
    
    
    
}
