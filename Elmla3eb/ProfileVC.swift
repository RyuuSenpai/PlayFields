//
//  ProfileVC.swift
//  Elmla3eb
//
//  Created by Macbook Pro on 4/30/17.
//  Copyright © 2017 Killvak. All rights reserved.
//

import UIKit
import CDAlertView

class ProfileVC: ToSideMenuClass {

    @IBOutlet weak var profileImage: UIImageViewX!
    @IBOutlet weak var favPoints: UILabel!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var playerPosition: UILabel!
    @IBOutlet weak var teamName: UILabel!
    @IBOutlet weak var pointslbl: UILabel!
 
    @IBOutlet weak var phoneNumTxt: UITextFieldX!
    @IBOutlet weak var birthDateTxt: UITextFieldX!
    
    @IBOutlet weak var snapCTxt: UITextFieldX!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var cityLbl: UILabel!
//        {
//        didSet {
//            if let name = UserDefaults.standard.value(forKey: "userName") as? String{
//            userName?.text = name
//            }else  if let email = UserDefaults.standard.value(forKey: "userEmail") as? String{
//                userName?.text = email
//            }
//    }
//    }
    let user = Profile_Model()

    var disableTxts = false  {
        didSet {
            if disableTxts {
                phoneNumTxt.isEnabled = false
                birthDateTxt.isEnabled = false
                snapCTxt.isEnabled = false
            }else {
           phoneNumTxt.isEnabled = true
            birthDateTxt.isEnabled = true
            snapCTxt.isEnabled = true
            }
        }
    }
    
    var profileData : PostLoginVars?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.squareLoading.start(0)
        disableTxts = true
        title =  langDicClass().getLocalizedTitle("Profile")
        self.pointslbl.text = "0" + langDicClass().getLocalizedTitle(" Points ")
        emptyFields()
        
        
        user.getProfileData { [weak self] (data, sms, state) in
            
           
            if state , let data = data  {
                DispatchQueue.main.async {
            self?.userName.text = data.name
                self?.snapCTxt.text = data.snapChat
                self?.birthDateTxt.text = data.birth_date
                self?.pointslbl.text = "\(data.points)"
                self?.teamName.text = data.team
                self?.playerPosition.text = data.positionName
                self?.favPoints.text =  "\(data.points)"
                self?.cityLbl.text = data.city
                self?.phoneNumTxt.text = data.mobile
                    self?.view.squareLoading.stop(0)
                }
            }else {
                self?.view.squareLoading.stop(0)
                self?.showAlert("Network Error", "failed to get Data")
            }
        }
    }
    
    override func toSidemenuVC() {
        super.toSidemenuVC()
        ad.sideMenuTrigger(self,"Profile")
        //        x.modalTransitionStyle = .partialCurl

    }

    func emptyFields() {
        if  let _ =  phoneNumTxt.text?.isEmpty  {
            phoneNumTxt.placeholder = "Empty"
        }
        if  let _ =  snapCTxt.text?.isEmpty   {
            snapCTxt.placeholder = "Empty"
        }
        if  let _ =  birthDateTxt.text?.isEmpty   {
            birthDateTxt.placeholder = "Empty"
        }
    }
    
    func showAlert(_ title : String,_ sms : String) {
        
        let alert = CDAlertView(title: title, message:sms , type: .warning)
        alert.show()
//        self.setUIEnabled(enabled: true)
    }
    
    @IBAction func editButtonAct(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        
        if sender.isSelected {
            disableTxts = false
            sender.setImage(UIImage(named:"Delete_5d5e61_32"), for: .normal)
            
            self.doneButton.alpha = 1
            self.doneButton.isEnabled = true
        }else {
            disableTxts = true
            sender.setImage(UIImage(named:"Edit User Male_5d5e61_32"), for: .normal)
            self.doneButton.alpha = 0
            self.doneButton.isEnabled = false
        }
    }

    @IBAction func doneBtnAct(_ sender: UIButton) {
        
        user.postProfileData(name: userName.text, mobile: phoneNumTxt.text, city: cityLbl.text, team: teamName.text, birthD: birthDateTxt.text, lon: nil, lat: nil, image: nil) { (state, sms) in
            
            
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
