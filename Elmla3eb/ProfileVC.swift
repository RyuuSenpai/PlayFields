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

    @IBOutlet weak var cityTxt: UITextField!
    
    @IBOutlet weak var positionTxt: UITextField!
    
    @IBOutlet weak var editProfileBtn: UIButton!
    @IBOutlet weak var profileImage: UIImageViewX!
    @IBOutlet weak var favPoints: UILabel!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var pointslbl: UILabel!

    @IBOutlet weak var playerPosition: UILabel!
    
    @IBOutlet weak var teamName: UILabel!
    
    @IBOutlet weak var userName: UILabel!
    
    @IBOutlet weak var cityLbl: UILabel!

    @IBOutlet weak var phoneNumTxt: UITextFieldX!
    @IBOutlet weak var birthDateTxt: UITextFieldX!
    
    @IBOutlet weak var snapCTxt: UITextFieldX!
//        {
//        didSet {
//            if let name = UserDefaults.standard.value(forKey: "userName") as? String{
//            userName?.text = name
//            }else  if let email = UserDefaults.standard.value(forKey: "userEmail") as? String{
//                userName?.text = email
//            }
//    }
//    }
    var positions =  [String]()
    
    
    fileprivate var citiesPickerV: UIPickerView!
    fileprivate var positionPickerV: UIPickerView!
    let user = Profile_Model()
    var cities = [String]()

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
        print("that's positions : \(positions)")
        if  L102Language.currentAppleLanguage() != "ar"   {
            positions =  ["Goalkeeper","Defence","Striker","Midfield"]
        }else {
          positions =  ["حارس مرمي","مدافع","مهاجم","وسط"]
        }
            setupPickerV()
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
                    self?.positionTxt.text = data.positionName
                    self?.cityTxt.text = data.city
                    if  let count = self?.cities.count , count < 1 {
                        
                        let global = GLOBAL()
                        let langIs = L102Language.currentAppleLanguage()
                        global.readJson(langIs: langIs, completed: { [weak self] (data) in
                            
                            self?.cities = data
                         })
                        
                    }
                    
                    self?.view.squareLoading.stop(0)
                }
            }else {
                self?.view.squareLoading.stop(0)
                self?.showAlert("Network Error", "failed to get Data")
            }
        }

    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true) //This will hide the keyboard
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
        
        user.postProfileData(name: userName.text, mobile: phoneNumTxt.text, city: cityLbl.text, team: teamName.text, birthD: nil, lon: nil, lat: nil, image: nil,snap_chat:snapCTxt.text,position:positionTxt.text) { [weak self](state, sms) in
            
            if state {
                DispatchQueue.main.async {
                    
                let alert = CDAlertView(title: langDicClass().getLocalizedTitle("Done"), message:"" , type: .success)
                alert.show()
                self?.disableTxts = true
                self?.editProfileBtn.setImage(UIImage(named:"Edit User Male_5d5e61_32"), for: .normal)
                self?.doneButton.alpha = 0
                self?.doneButton.isEnabled = false
                }
            }else {
                DispatchQueue.main.async {

                self?.showAlert(langDicClass().getLocalizedTitle("Failed Uploading Changes"), langDicClass().getLocalizedTitle("try again!!"))
                }
            }
        }
     }
    
    func presentAlert(_ title : String,_ sms : String,_ placeHolder : String,_ label : UILabel) {//"Please input your email:"
        let alertController = UIAlertController(title: title, message: sms, preferredStyle: .alert)
        
        let confirmAction = UIAlertAction(title: langDicClass().getLocalizedTitle("Confirm"), style: .default) { (_) in
            if let field = alertController.textFields?[0] , let txt = field.text ,!txt.isEmpty{
                // store your data
                //                    UserDefaults.standard.synchronize()
                label.text = txt
            } else {
                // user did not fill field
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in }
        
        alertController.addTextField { (textField) in
            textField.placeholder = placeHolder
        }
        
        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */


    @IBAction func LabelTapAction(_ sender: UIButton) {
        guard   !disableTxts else { return }
        self.view.endEditing(true) //This will hide the keyboard
        switch sender.tag {
        case 1 :
           print("city")
            cityTxt.becomeFirstResponder()
        case 2:
            presentAlert("Team", "Team Name", "Team Name", teamName)
        case 3 :
            print("Position")
            positionTxt.becomeFirstResponder()
        default :
            presentAlert("name", "enter your nickname", "nickname", userName)
        }
    }
}




extension ProfileVC :  UIPickerViewDelegate, UIPickerViewDataSource,UITextFieldDelegate {
    
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
                guard pickerView == positionPickerV else {
                    return cities.count
                }
        return positions.count
    }
    //    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
    //        return cities[row]
    //    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
                guard pickerView == citiesPickerV else {
                    positionTxt.text = positions[row]
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
                    label.text = positions[row]
                    return label
                }
        label.text = cities[row]
        return label
    }
    
    
    
    func setupPickerV() {
        cityTxt.delegate = self
        positionTxt.delegate = self
        citiesPickerV = UIPickerView()
        citiesPickerV.dataSource = self
        citiesPickerV.delegate = self
        cityTxt.inputView = citiesPickerV
        birthDateTxt.delegate = self
                positionPickerV = UIPickerView()
                positionPickerV.dataSource = self
                positionPickerV.delegate = self
                positionTxt.inputView = positionPickerV
    }
    
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if  textField == cityTxt ,  textField.text == "" {
            textField.text = cities[0]
            
        } else  if  textField == positionTxt ,  textField.text == "" {
                    textField.text = positions[0]
                }
        
        if   textField == birthDateTxt ,  textField.text == "" {
            let formatter = DateFormatter()
            formatter.dateFormat = "dd/MM/yyyy"
            let date  = formatter.string(from: NSDate() as Date)
            textField.text = date
            
        }
        cityLbl.text = cityTxt.text
        playerPosition.text = positionTxt.text
    }
    
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == birthDateTxt  {
    
            
            let datePicker = UIDatePicker()
//            datePicker.minimumDate = Date()
            
            let secondsInMonth: TimeInterval = 360 * 24 * 60 * 60
            datePicker.maximumDate = Date(timeInterval: secondsInMonth, since: Date())
            
            datePicker.datePickerMode = UIDatePickerMode.date
            textField.inputView = datePicker
            datePicker.addTarget(self, action: #selector(self.timePickerChanged(_:)), for: .valueChanged)
        }
    }
    
    func timePickerChanged(_ sender: UIDatePicker) {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
             birthDateTxt.text = formatter.string(from: sender.date)
 }

}

