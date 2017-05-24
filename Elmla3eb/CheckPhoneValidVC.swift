//
//  CheckPhoneValidVC.swift
//  Elmla3eb
//
//  Created by Macbook Pro on 5/16/17.
//  Copyright © 2017 Killvak. All rights reserved.
//

import UIKit
import CDAlertView

class CheckPhoneValidVC: UIViewController {
    
    @IBOutlet weak var validationLbl: UILabel!
    @IBOutlet weak var topLbl: UILabel!
    @IBOutlet weak var confirmationCodeTxt: UITextField!
    
    @IBOutlet weak var passwordText: UITextField!
    @IBOutlet weak var passwordCenterX: NSLayoutConstraint!
    
    @IBOutlet weak var activeOL: UIButton!
    @IBOutlet weak var resendBtnOL: UIButton!
    
    @IBOutlet weak var verficationStack: UIStackView!
    @IBOutlet weak var sendPhoneNumBtn: UIButtonX!
    
    @IBOutlet weak var passwordStack: UIStackView!
    
    @IBOutlet weak var activityIndector: UIActivityIndicatorView!
    
    
    var userId : Int?
    var userName : String?
    var codeVerfication :Bool? {
        didSet {
            guard let state = codeVerfication else { return    }
            if state {
                topLbl?.text = langDicClass().getLocalizedTitle("Please, Enter activation code that was sent to you by sms to activate your account.")
                
                validationLbl?.text = langDicClass().getLocalizedTitle("  Verfication Code :")
                confirmationCodeTxt?.placeholder = langDicClass().getLocalizedTitle("Code")
                
                verficationStack?.alpha = 1
                sendPhoneNumBtn?.alpha = 0
                passwordStack?.alpha = 0
                activeOL?.titleLabel?.text = langDicClass().getLocalizedTitle("Activate")
//                timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(update), userInfo: nil, repeats: true)
                
            }else {
                topLbl?.text = langDicClass().getLocalizedTitle("Please, Enter The Phone Number To Complete the Process")
                
                validationLbl?.text = langDicClass().getLocalizedTitle("  Phone Number :")
                confirmationCodeTxt?.placeholder = langDicClass().getLocalizedTitle("Phone Number")
                
                verficationStack?.alpha = 0
                sendPhoneNumBtn?.alpha = 1
                passwordStack?.alpha = 0
                sendPhoneNumBtn?.titleLabel?.text = langDicClass().getLocalizedTitle("Wow")
            }
        }
    }
    
    
    let userModel = MUserData()
    var count = 60
    var timer = Timer()
    var isTimerRunning = false
    let user = MUserData()
    var passwordAppeared = false {
        didSet {
            if passwordAppeared {
            verficationStack?.alpha = 1
            sendPhoneNumBtn?.alpha = 0
//                passwordStack.alpha = 1
            activeOL?.titleLabel?.text = langDicClass().getLocalizedTitle("Login")
                timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(update), userInfo: nil, repeats: true)

            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        // Do any additional setup after loading the view.
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        passwordCenterX.constant += self.view.bounds.width
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
    }
    
    func setupView() {
        guard let state = codeVerfication else { return    }
        if state {
            topLbl?.text = langDicClass().getLocalizedTitle("Please, Enter activation code that was sent to you by sms to activate your account.")
            
            validationLbl.text = langDicClass().getLocalizedTitle("  Verfication Code :")
            confirmationCodeTxt.placeholder = langDicClass().getLocalizedTitle("Code")
            
            verficationStack.alpha = 1
            sendPhoneNumBtn.alpha = 0
            passwordStack.alpha = 0
            activeOL.titleLabel?.text = langDicClass().getLocalizedTitle("Activate")
            timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(update), userInfo: nil, repeats: true)
            
        }else {
            topLbl.text = langDicClass().getLocalizedTitle("Please, Enter The Phone Number To Complete the Process")
            
            validationLbl.text = langDicClass().getLocalizedTitle("  Phone Number :")
            confirmationCodeTxt.placeholder = langDicClass().getLocalizedTitle("Phone Number")
            
            verficationStack.alpha = 0
            sendPhoneNumBtn.alpha = 1
            passwordStack.alpha = 0
            sendPhoneNumBtn.titleLabel?.text = langDicClass().getLocalizedTitle("Wow")
        }
        
    }
    
    @IBAction func btnAct(_ sender: UIButton) {
      
        if !passwordAppeared  {
            if sender.tag == 0  {
                //active
                sendConfirmatioCode()
            }else {//resend
                guard let id = userId else { print("User id == nil "); return }
                setUIEnabled(enabled: false )
                user.postResendVerificationCode(user_id: id ,completed: {[weak weakSelf = self] (sms, state) in
                    
                    if state {
                        weakSelf?.count = 60
                        weakSelf?.timer = Timer.scheduledTimer(timeInterval: 1.0, target: weakSelf, selector: #selector(weakSelf?.update), userInfo: nil, repeats: true)
                    }else {
                        ad.showAlert("All Fields are Required", "" )
                    }
                    weakSelf?.setUIEnabled(enabled: true )
                    
                })
            }
        }else {
            if sender.tag == 0 {
            guard let mobile = confirmationCodeTxt.text ,mobile.validPhoneNumber,let password = passwordText.text , password.isValidPassword else {
                ad.showAlert( langDicClass().getLocalizedTitle("All Fields are Required"), "")
                return }
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
                    vc.codeVerfication = true
                    self.present(vc, animated: true, completion: nil)
//                    weakSelf?.passwordAppeared = false
//                    weakSelf?.codeVerfication = true
                    self.setUIEnabled(enabled: true)

                }else {
                    if data.2 == "User not found" {
                        DispatchQueue.main.async {
                            ad.showAlert( langDicClass().getLocalizedTitle("Invalid username or password"), "")
                        }
                    }else {
                        DispatchQueue.main.async {
                            ad.showAlert( langDicClass().getLocalizedTitle(" Network Time out "), "")
                        }
                    }
                    
                }
            }
//            passwordText
            }else {
                guard let mobile = confirmationCodeTxt.text ,mobile.validPhoneNumber else {
                    ad.showAlert( langDicClass().getLocalizedTitle("Invalid username or password"), "")
                    return }
                setUIEnabled(enabled: false )
                user.postForgotPassword(mobile: mobile) {[ weak weakSelf = self ] (sms, state) in
                    
                    if state {
                        weakSelf?.count = 60
                        weakSelf?.timer = Timer.scheduledTimer(timeInterval: 1.0, target: weakSelf, selector: #selector(weakSelf?.update), userInfo: nil, repeats: true)
                    }else {
                        ad.showAlert("", langDicClass().getLocalizedTitle("Error with ") + "\(sms)")
                    }
                    weakSelf?.setUIEnabled(enabled: true)
                    
                }
            }
    }
    }
    
    @IBAction func sendPhoneNumBtnAct(_ sender: UIButtonX) {
        //        codeVerfication =  true\
        guard let mobile = confirmationCodeTxt.text ,mobile.validPhoneNumber else {
            ad.showAlert( langDicClass().getLocalizedTitle("Invalid Mobile Number "), "")
            return }
        setUIEnabled(enabled: false )
        user.postForgotPassword(mobile: mobile) {[ weak weakSelf = self ] (sms, state) in
            
            if state {
                
                DispatchQueue.main.async {
                    weakSelf?.passwordAppeared = true
                    UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: [.curveEaseIn], animations: {
                        weakSelf?.passwordStack.alpha = 1
                        weakSelf?.view.layoutIfNeeded()
                    })
                }
            }else {
                ad.showAlert("", langDicClass().getLocalizedTitle("Error with ") + "\(sms)")
            }
            weakSelf?.setUIEnabled(enabled: true)

        }
      
    }
    
    func setupPassword() {
//        passwordCenterX.constant -= view.bounds.width

    }
    
    
    func sendConfirmatioCode() {
        setUIEnabled(enabled: false )
        guard   let code = confirmationCodeTxt.text  , !code.isEmpty else {
            let alert = CDAlertView(title: langDicClass().getLocalizedTitle(""), message: langDicClass().getLocalizedTitle("Code Field is Empty")  , type: .warning)
            alert.show()
            setUIEnabled(enabled: true)
            return
        }
        if let id = userId , let name = userName    {
            userModel.getPhoneConfirmation(user_id: id , code :code, completed: { [weak weakSelf = self ] (state, sms) in
                
                print("that's the state :\(state), and that's sms : \(sms)")
                if state {
                    ad.saveUserLogginData(email: nil, photoUrl: nil, uid: id,name:name)
                    ad.reloadApp()
                    
                    
                }else {
                    let alert = CDAlertView(title: langDicClass().getLocalizedTitle(""), message: langDicClass().getLocalizedTitle("Error with ") + "\(sms)" , type: .warning)
                    alert.show()
                    weakSelf?.setUIEnabled(enabled: true)
                }
            })
        }
    }
    @IBAction func resetAppBtnAct(_ sender: UIButton) {

        
        ad.reloadApp()
    }
    
    
    
    
    func  setUIEnabled(enabled:Bool) {
        
        if enabled {
            activityIndector.stopAnimating()
            activeOL.alpha = 1
            confirmationCodeTxt.alpha = 1
            resendBtnOL.alpha = 1
            
            activeOL.isEnabled = true
            confirmationCodeTxt.isEnabled = true
            resendBtnOL.isEnabled = true
            
        }else {
            activityIndector.startAnimating()
            activeOL.alpha = 0.5
            confirmationCodeTxt.alpha = 0.5
            resendBtnOL.alpha = 0.5
            
            activeOL.isEnabled = false
            confirmationCodeTxt.isEnabled = false
            resendBtnOL.isEnabled = false
            
            //            signBtnOL.alpha = 0.5
            //            dissMissView.alpha = 0.5
        }
        
    }
    
    
    func update() {
        if(count > 0) {
            resendBtnOL.isEnabled=false
            resendBtnOL .setTitle("Resend in " + String(count), for: UIControlState.normal)
            count -= 1
            resendBtnOL.backgroundColor=UIColor.lightGray
        }
        else{
            timer.invalidate()
            resendBtnOL.isEnabled=true
            resendBtnOL .setTitle("Resend" , for: UIControlState.normal)
            //            resendBtnOL.backgroundColor=UIColor(red: 79/255.0, green: 6/255.0, blue: 80/255.0, alpha: 1)
            resendBtnOL.backgroundColor = .clear
            
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
    
}

//extension TimeInterval {
//    func format() -> String {
//        let formatter = DateComponentsFormatter()
//        formatter.allowedUnits = [.day, .hour, .minute, .second]
//        formatter.unitsStyle = .abbreviated
//        formatter.maximumUnitCount = 1
//        
//        return formatter.string(from: self)!
//}
//}
