//
//  LoginVC.swift
//  Elmla3eb
//
//  Created by Macbook Pro on 3/15/17.
//  Copyright © 2017 Killvak. All rights reserved.
//

import UIKit
import CDAlertView

class LoginVC: MirroringViewController {
    
    
    @IBOutlet weak var ballImageView: UIImageView!
    @IBOutlet weak var inkStinkImageView: UIImageView!
    
    @IBOutlet weak var signBtn: UIButton!
    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    @IBOutlet weak var registerBtn: UIButton!
    @IBOutlet weak var fbBtn: UIButton!
    @IBOutlet weak var ballImageCenterX: NSLayoutConstraint!
    @IBOutlet weak var backBtn: UIButton!
    
    var genderCenter : CGPoint!
    var addImageCenter : CGPoint!
    var shieldOnCenter : CGPoint!
    
    
    //TESTS
    
    //
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title =  langDicClass().getLocalizedTitle("Login")
        
    }
    
    
    func setUIEnabled(enabled:Bool) {
        //        self.fbSigninBtnOL.isEnabled = enabled
        //        self.googleSigninBtnOL.isEnabled = enabled
        //        self.signBtnOL.isEnabled = enabled
        //        self.dissMissView.isEnabled = enabled
        
        if enabled {
            emailText.alpha = 1
            passwordText.alpha = 1
            signBtn.alpha = 1
            fbBtn.alpha = 1
            registerBtn.alpha = 1
            backBtn.alpha = 1
            backBtn.isEnabled = true
            signBtn.isEnabled = true
            fbBtn.isEnabled = true
            registerBtn.isEnabled = true
            signBtn.isEnabled = true
            emailText.isEnabled = true
            passwordText.isEnabled = true
        }else {
            emailText.alpha = 0.5
            passwordText.alpha = 0.5
            signBtn.alpha = 0.5
            fbBtn.alpha = 0.5
            registerBtn.alpha = 0.5
            backBtn.alpha = 0.5
            backBtn.isEnabled = false
            signBtn.isEnabled = false
            fbBtn.isEnabled = false
            registerBtn.isEnabled = false
            signBtn.isEnabled = false
            emailText.isEnabled = false
            passwordText.isEnabled = false
            //            signBtnOL.alpha = 0.5
            //            dissMissView.alpha = 0.5
        }
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.ballImageCenterX.constant += self.view.bounds.width
        self.ballImageView.transform = .identity
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        UIView.animate(withDuration: 1.5, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.3, options: [.curveEaseIn], animations: {
            self.ballImageView.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
            self.ballImageCenterX.constant -= self.view.bounds.width
            
            self.view.layoutIfNeeded()
        }){ (true) in
            UIView.animate(withDuration: 1.7, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.3, options: [.curveEaseIn], animations: {
                self.ballImageView.transform = .identity
                
                self.view.layoutIfNeeded()
            })
            
        }
        //@Test_back_End
        ////        TestBackEnd.HOmePage()
        //        TestBackEnd.PLayField_INfo()
        //        TestBackEnd.PlaygNews()
        //        TestBackEnd.playgTimes()
        //        TestBackEnd.playGrounds()
        //        TestBackEnd.playgTeams()
        //        TestBackEnd.User()
        //@End_Test_back_End
        
    }
    
    @IBAction func backBtnAct(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func showPassword(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        sender.setImage(#imageLiteral(resourceName: "hidePass"), for: .normal)
        sender.setImage(#imageLiteral(resourceName: "showPass"), for: .selected)
        
        switch sender.tag {
        case 0 :
            self.passwordText.isSecureTextEntry = !sender.isSelected
        default:
            return
        }
    }
    
    
    @IBAction func signinBtnAct(_ sender: UIButton) {
        let x = signinFunFunctionailty()
        if x != "Done" {
            
            showAlert("", langDicClass().getLocalizedTitle("Error with ") + "\(x)")
            
        }
    }
    
    
    @IBAction func forgotPasswordBtnAct(_ sender: UIButton) {
        
        let vc = ForgotPasswordVC()
        
        self.present(vc, animated: true, completion: nil)
        
    }
    
    func signinFunFunctionailty() ->  String {
        //(name: "eslam", mobile: "0123123122", city: "cairo", area: "51", pgType: 1, email: "eslam@gmail.com", password: "1234§")
        self.setUIEnabled(enabled: false)
        guard   let password = passwordText.text, let mobile = self.emailText.text else { return "Empty_Field" }
        guard  !password.isEmpty,!mobile.isEmpty else { return"All Fields are Required" }
        guard password.doesNOTcontainSpecialCharacters else { return "Password Can't Contain Special Characters" }
        guard mobile.doesNOTcontainSpecialCharacters else { return "Phone Number Can't Contain Special Characters" }
        let user = MUserData()
        
        user.postLoginData(mobileNum: mobile , userPassword: password) { [weak weakSelf = self ] (data) in
            print("that is the login response : \(data)")
            if data.1 {
                if  let x = data.0 {
                    
                    ad.saveUserLogginData(email: x.email, photoUrl: nil, uid:   x.id , name : x.name)
                    
                    weakSelf?.performSegue(withIdentifier: "LoggedInSegue", sender: weakSelf)
                    
                }
                self.setUIEnabled(enabled: true)
            }else if let data = data.3 , let id = data["id"] as? Int  , let name = data["name"] as? String{
                let vc = CheckPhoneValidVC(nibName: "CheckPhoneValidVC", bundle: nil)
                vc.modalTransitionStyle = .crossDissolve
                vc.userId = id
                vc.userName = name
                self.present(vc, animated: true, completion: nil)
                
            }else {
                if data.2 == "User not found" {
                    DispatchQueue.main.async {
                        self.showAlert( langDicClass().getLocalizedTitle("Invalid username or password"), "")
                    }
                }else {
                    DispatchQueue.main.async {
                        self.showAlert( langDicClass().getLocalizedTitle(" Network Time out "), "")
                    }
                }
                
            }
        }
        return "Done"
        
    }
    
    
    func showAlert(_ title : String,_ sms : String) {
        
        let alert = CDAlertView(title: title, message:sms , type: .warning)
        alert.show()
        self.setUIEnabled(enabled: true)
    }
    
    @IBAction func signupBtnAct(_ sender: UIButton) {
        
        guard   let parent = self.presentingViewController ,parent.isKind(of: RegisterationSplashVC.self)else {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "RegisterationSplashVC") as! RegisterationSplashVC
            self.present(vc, animated: true, completion: nil)
            return
        }
        dismiss(animated: true, completion: nil)
        
    }
    
    func degreesToRadians( _ degree : Double) -> CGFloat {
        return  CGFloat(degree * .pi / 180)
    }
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
