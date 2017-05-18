//
//  ProfileVC.swift
//  Elmla3eb
//
//  Created by Macbook Pro on 4/30/17.
//  Copyright © 2017 Killvak. All rights reserved.
//

import UIKit

class ProfileVC: ToSideMenuClass {

    @IBOutlet weak var favPoints: UILabel!
    @IBOutlet weak var playerPosition: UILabel!
    @IBOutlet weak var teamName: UILabel!
    @IBOutlet weak var pointslbl: UILabel!
 
    @IBOutlet weak var phoneNumTxt: UITextFieldX!
    @IBOutlet weak var birthDateTxt: UITextFieldX!
    
    @IBOutlet weak var snapCTxt: UITextFieldX!
    @IBOutlet weak var userName: UILabel!{
        didSet {
            if let name = UserDefaults.standard.value(forKey: "userName") as? String{
            userName?.text = name
            }else  if let email = UserDefaults.standard.value(forKey: "userEmail") as? String{
                userName?.text = email
            }
    }
    }
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
    override func viewDidLoad() {
        super.viewDidLoad()
        disableTxts = true
        title =  langDicClass().getLocalizedTitle("Profile")
        self.pointslbl.text = "0" + langDicClass().getLocalizedTitle(" Points ")
        emptyFields()
        
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
    
    @IBAction func editButtonAct(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        
        if sender.isSelected {
            disableTxts = false
            sender.setImage(UIImage(named:"Delete_5d5e61_32"), for: .normal)
        }else {
            disableTxts = true
            sender.setImage(UIImage(named:"Edit User Male_5d5e61_32"), for: .normal)

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
