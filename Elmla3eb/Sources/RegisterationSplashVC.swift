//
//  RRegisterationSplashVC.swift
//  Elmla3eb
//
//  Created by Macbook Pro on 3/14/17.
//  Copyright © 2017 Killvak. All rights reserved.
//

import UIKit
import CDAlertView


 class RegisterationSplashVC: MirroringViewController,UITextFieldDelegate {

    @IBOutlet weak var registerationView: UIView!
    @IBOutlet weak var playerView: UIView!
    @IBOutlet weak var ownerView: UIView!
    @IBOutlet weak var playerViewImageBk: UIImageView!
    @IBOutlet weak var ownerViewImageBk: UIImageView!
//    @IBOutlet weak var registerationtopSpaceToOwnerView: NSLayoutConstraint!
    @IBOutlet weak var playerViewBtn: UIButton!
    @IBOutlet weak var ownerViewBtn: UIButton!
    @IBOutlet weak var signupBtn: UIButton!
    @IBOutlet weak var backBtn: UIButton!

    @IBOutlet weak var playerViewTopSpaceToView: NSLayoutConstraint!
    @IBOutlet weak var registerationViewBottomSpaceToView: NSLayoutConstraint!
    @IBOutlet weak var playerViewHeightConstant: NSLayoutConstraint!
    @IBOutlet weak var ownerTopSpaceToPlayerView: NSLayoutConstraint!
    @IBOutlet weak var userNameText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    @IBOutlet weak var phoneNumText: UITextField!
    @IBOutlet weak var cityTxt: UITextField!
    @IBOutlet weak var districtTxt: UITextField!
    
    var playerViewOriginalHeight : CGFloat!
    var registerViewOriginalTopSpace : CGFloat!
    var checkBoxIndexArray = [Int]()
    var playFieldType = 0
    var disableButtons : () {
        self.playerViewBtn.isEnabled = false
        self.ownerViewBtn.isEnabled = false
    }
    var enableButtons : () {
        self.playerViewBtn.isEnabled = true
        self.ownerViewBtn.isEnabled = true
    }
    var cities = [String]()
    let districts = ["1","2","3","4"]
    fileprivate var citiesPickerV: UIPickerView!
    fileprivate var districtsPickerV: UIPickerView!

    private var dissmissedLogin = false
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       setupPickerV()

        let tapped = UITapGestureRecognizer(target: self, action: #selector(self.closekeyBoard(_:)))
        
        self.view.addGestureRecognizer(tapped)
        title =  langDicClass().getLocalizedTitle("Registration")

     }
    
    
    func closekeyBoard(_ tapped : UITapGestureRecognizer) {
        
        view.endEditing(true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if !dissmissedLogin {
        self.playerViewOriginalHeight = self.playerViewHeightConstant.constant
        self.registerViewOriginalTopSpace = self.registerationViewBottomSpaceToView.constant
        self.registerationViewBottomSpaceToView.constant = self.view.bounds.height * -1
        if cities.count < 1 {
        self.view.squareLoading.start(0)
            
            let global = GLOBAL()
            let langIs = L102Language.currentAppleLanguage()
            global.readJson(langIs: langIs, completed: { [weak self] (data) in
                
                self?.cities = data
                self?.view.squareLoading.stop(0)
            })
            
        }
        
        
        dissmissedLogin = true
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidAppear(animated)
 
      }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
 
//        self.ownerViewImageBk.image = #imageLiteral(resourceName: "BackGround")
        print("that' the self.presentingViewController : \(self.presentingViewController)")
        print("that' the self.presentingViewController nibName  : \(self.presentingViewController?.nibName)")
        print("that' the self.presentingViewController title  : \(self.presentingViewController?.title)")
       
     

    }
 
    

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
      
        
    }

    
    @IBAction func signInBtnAct(_ sender: UIButton) {
    
        guard   let parent = self.presentingViewController ,parent.isKind(of: LoginVC.self)else {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
            self.present(vc, animated: true, completion: nil)
            return
        }
        dismiss(animated: true, completion: nil)
     }
    
    @IBAction func ownerBtnAct(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
          self.disableButtons
          if sender.isSelected {
            UIView.animate(withDuration: 1.5, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.0, options: [.curveEaseIn , .allowUserInteraction], animations: {
                self.playerViewHeightConstant.constant -= ( self.view.bounds.height * 0.13 )
                self.playerViewTopSpaceToView.constant =  ((self.playerView.bounds.height * -1) + ( self.view.bounds.height * 0.13 ))
                self.playerView.alpha = 0
                self.ownerViewImageBk.alpha = 0
                self.registerationViewBottomSpaceToView.constant = self.registerViewOriginalTopSpace
                self.playFieldType = 1
                self.view.layoutIfNeeded()
            })
        }else {
            view.endEditing(true)
            self.playerView.alpha = 1
            UIView.animate(withDuration: 1.5, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.0, options: [.curveEaseIn, .allowUserInteraction], animations: {
                self.playerViewHeightConstant.constant = self.playerViewOriginalHeight
                self.playerViewTopSpaceToView.constant =  0
                self.registerationViewBottomSpaceToView.constant  = self.view.bounds.height * -1
                self.playerView.alpha = 1
                self.ownerViewImageBk.alpha = 1
                self.view.layoutIfNeeded()
            })
        }
        let when = DispatchTime.now() + 0.5 // change 2 to desired number of seconds
        DispatchQueue.main.asyncAfter(deadline: when) {
            // Your code with delay
    self.enableButtons
        }
        
     }
    
    @IBAction func playerBtnAct(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        self.disableButtons
        
         if sender.isSelected {
         self.ownerView.alpha = 0
            UIView.animate(withDuration: 1.5, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.0, options: [.curveEaseIn , .allowUserInteraction], animations: {
               self.playerViewHeightConstant.constant -= ( self.view.bounds.height * 0.13 )
                self.registerationViewBottomSpaceToView.constant = self.registerViewOriginalTopSpace
                self.playerViewImageBk.alpha = 0
                self.view.layoutIfNeeded()
                self.playFieldType = 0
            })
         }else {
            view.endEditing(true)
            self.ownerView.alpha = 1
            UIView.animate(withDuration: 1.5, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.0, options: [.curveEaseIn, .allowUserInteraction], animations: {
                self.playerViewHeightConstant.constant = self.playerViewOriginalHeight
                self.registerationViewBottomSpaceToView.constant  = self.view.bounds.height * -1
                self.playerViewImageBk.alpha = 1
                self.view.layoutIfNeeded()
            })
        }
        let when = DispatchTime.now() + 0.5 // change 2 to desired number of seconds
        DispatchQueue.main.asyncAfter(deadline: when) {
            // Your code with delay
          self.enableButtons
        }
        }
    
    @IBAction func backBtnAct(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }


    

    
    
    

    
    @IBAction func creatAccountBtnAct(_ sender: UIButton) {
        self.setUIEnabled(enabled: false)
        let x = signupFunFunctionailty()
        if x != "Done" {
            let alert = CDAlertView(title: "", message: langDicClass().getLocalizedTitle("Error with ") + "\(x)", type: .warning)
//            let doneAction = CDAlertViewAction(title: "Sure!")
//            alert.add(action: doneAction)
//            let nevermindAction = CDAlertViewAction(title: "Nevermind")
//            alert.add(action: nevermindAction)
            alert.show()
            self.setUIEnabled(enabled: true)
        }else {
  
        }
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
    
    
    func signupFunFunctionailty() ->  String {
        //(name: "eslam", mobile: "0123123122", city: "cairo", area: "51", pgType: 1, email: "eslam@gmail.com", password: "1234§")
//         guard let id = userNameText.text  else { return"Email Field can't be Empty" }
//        guard  !passwordText.text .isEmpty,!mobile.isEmpty,!mobile.isEmpty,!mobile.isEmpty,!mobile.isEmpty,!mobile.isEmpty else { return"ld can't be Empty" }
        guard  let userName = userNameText.text,!userName.isEmpty  else { return"User name Field can't be Empty" }
        guard  let password = passwordText.text, !password.isEmpty else { return"password Field can't be Empty" }
        guard   let mobile = self.phoneNumText.text,!password.isEmpty  else { return "Mobile Field can't be Empty" }
        guard  let city = cityTxt.text, !city.isEmpty  else { return"City Field can't be Empty" }
//        guard  let district = districtTxt.text, !district.isEmpty  else { return"District Field can't be Empty" }
        guard mobile.validPhoneNumber else {
            return "Phone Number isn't in the right Format"
        }

//        guard id.doesNOTcontainSpecialCharacters else { return "UserName Contain Special Chars"  }
        guard password.isValidPassword else { return "Password has to be more than 8 Characters" }
//        guard mobile.doesNOTcontainSpecialCharacters else { return "PhoneNumber Contain Special Chars" }

        let user = MUserData()
        
        user.postRegisterUser(name: "", mobile: mobile, city: "   ", area: "  ", pgType: self.playFieldType, email: "", password: password) { [weak weakSelf = self ] (data) in
            print("that is the registeration response : \(data)")
            if data.1 , let x = data.0  {
                
                    let id = x.id
                ad.saveUserLogginData(email: nil, photoUrl: nil, uid: id,name:userName)
                
                weakSelf?.performSegue(withIdentifier: "SignedupSegue", sender: weakSelf)
                self.setUIEnabled(enabled: true)
            }else {
                if data.2 == "user already exists" {
                    let alert = CDAlertView(title: langDicClass().getLocalizedTitle("Phone Number Already Exists"), message: "", type: .error)
                    DispatchQueue.main.async {
                        alert.show()
                        self.setUIEnabled(enabled: true)
                        
                    }
                }
                
            }
            
        }
        return "Done"
    
}

    func setUIEnabled(enabled:Bool) {
        //        self.fbSigninBtnOL.isEnabled = enabled
        //        self.googleSigninBtnOL.isEnabled = enabled
        //        self.signBtnOL.isEnabled = enabled
        //        self.dissMissView.isEnabled = enabled
        
        if enabled {
             passwordText.alpha = 1
            passwordText.isEnabled = true
            userNameText.alpha = 1
            userNameText.isEnabled = true
            phoneNumText.alpha = 1
            phoneNumText.isEnabled = true
            signupBtn.alpha = 1
            signupBtn.isEnabled = true
            ownerViewBtn.alpha = 1
            ownerViewBtn.isEnabled = true
            playerViewBtn.alpha = 1
            playerViewBtn.isEnabled = true
            backBtn.alpha = 1
            backBtn.isEnabled = true
        }else {
             passwordText.alpha = 0.5
            passwordText.isEnabled = false
            userNameText.alpha = 0.5
            userNameText.isEnabled = false
            phoneNumText.alpha = 0.5
            phoneNumText.isEnabled = false
            signupBtn.alpha = 0.5
            signupBtn.isEnabled = false
            ownerViewBtn.alpha = 0.5
            ownerViewBtn.isEnabled = false
            playerViewBtn.alpha = 0.5
            playerViewBtn.isEnabled = false
            backBtn.alpha = 0.5
            backBtn.isEnabled = false
        }
        
    }
    
    
    

}









extension RegisterationSplashVC :  UIPickerViewDelegate, UIPickerViewDataSource {
    
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        guard pickerView == citiesPickerV else {
            return districts.count
        }
        return cities.count
    }
    //    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
    //        return cities[row]
    //    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        guard pickerView == citiesPickerV else {
            districtTxt.text = districts[row]
            self.view.endEditing(true)
            return
        }
        cityTxt.text = cities[row]
        self.view.endEditing(true)
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        
        let label = UILabel()
        label.font = UIFont(name: "Times New Roman", size: 22.0)
        label.tag = 20
        label.textAlignment = .center
        
        guard pickerView == citiesPickerV else {
            label.text = districts[row]
            return label
        }
        label.text = cities[row]
        return label
    }
    
    func setupPickerV() {
        cityTxt.delegate = self
        districtTxt.delegate = self
        citiesPickerV = UIPickerView()
        citiesPickerV.dataSource = self
        citiesPickerV.delegate = self
        cityTxt.inputView = citiesPickerV
        
        districtsPickerV = UIPickerView()
        districtsPickerV.dataSource = self
        districtsPickerV.delegate = self
        districtTxt.inputView = districtsPickerV
    }
    
    
    func textFieldDidEndEditing(_ textField: UITextField) {
    if  textField == cityTxt ,  textField.text == "" {
            textField.text = cities[0]
            
        }else  if  textField == districtTxt ,  textField.text == "" {
            textField.text = districts[0]
            
        }
    }
    
    
    

}












