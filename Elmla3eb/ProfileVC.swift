//
//  ProfileVC.swift
//  Elmla3eb
//
//  Created by Macbook Pro on 4/30/17.
//  Copyright © 2017 Killvak. All rights reserved.
//

import UIKit
import CDAlertView
import Alamofire
import AlamofireImage

class ProfileVC: ToSideMenuClass,UIImagePickerControllerDelegate , UINavigationControllerDelegate{

    @IBOutlet weak var cityTxt: UITextField!
    
    @IBOutlet weak var positionTxt: UITextField!
    
    @IBOutlet weak var profileImageBtn: UIButton!
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
 
    var imageUrl = "" {
        didSet {
            print("thatis the image url : \(imageUrl)")
            guard let url = URL(string: imageUrl ) else { return }
            profileImage.af_setImage(
                withURL: url,
                placeholderImage: UIImage(named: "nobody_m.original"),
                filter: nil,
                imageTransition: .crossDissolve(0.2)
            )
        }
    }
var changedImage = false
    var base64String = ""
    fileprivate var citiesPickerV: UIPickerView!
    fileprivate var positionPickerV: UIPickerView!
    let user = Profile_Model()
    var cities = [String]()

    var disableTxts = false  {
        didSet {
            if disableTxts {
                phoneNumTxt?.isEnabled = false
                birthDateTxt?.isEnabled = false
                snapCTxt?.isEnabled = false
                profileImageBtn?.isEnabled = false
            }else {
           phoneNumTxt?.isEnabled = false
            birthDateTxt?.isEnabled = true
            snapCTxt?.isEnabled = true
                profileImageBtn?.isEnabled = true
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
//                    self?.imageUrl = data.image
                    if   let imageurl = UserDefaults.standard.value(forKey: "profileImage") as? String  {
                    self?.imageUrl = imageurl
                    }
                    
                    
                    
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
//        setUIEnabled(enabled: false )
//        user.postProfileData(name: userName.text, mobile: nil, city: cityLbl.text, team: teamName.text, birthD: birthDateTxt.text, lon: nil, lat: nil, image: changedImage ? base64String : imageUrl ,snap_chat:snapCTxt.text,position:positionTxt.text) { [weak self](state, sms) in
//            
//            if state {
//                DispatchQueue.main.async {
//                   
//                let alert = CDAlertView(title: langDicClass().getLocalizedTitle("Done"), message:"" , type: .success)
//                alert.show()
//                self?.disableTxts = true
//                self?.editProfileBtn.setImage(UIImage(named:"Edit User Male_5d5e61_32"), for: .normal)
//                self?.doneButton.alpha = 0
//                self?.doneButton.isEnabled = false
//                    self?.setUIEnabled(enabled: true)
//                }
//            }else {
//                DispatchQueue.main.async {
//
//                self?.showAlert(langDicClass().getLocalizedTitle("Failed Uploading Changes"), langDicClass().getLocalizedTitle("try again!!"))
//                        self?.setUIEnabled(enabled: true )
//                }
//            }
//        }
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
        
        let cancelAction = UIAlertAction(title: langDicClass().getLocalizedTitle("Cancel"), style: .cancel) { (_) in }
        
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
    
    
    
    
    // MARK: - UIImagePickerControllerDelegate Methods
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        print("DONEnenenewnewnewnnew")
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            profileImage.contentMode = .scaleAspectFill
            profileImage.image = pickedImage
            base64String = convertImageToBase64(pickedImage)
            
            
            //            let imageData:NSData = UIImagePNGRepresentation(pickedImage)! as NSData
            
            
            //OR next possibility
            
            //Use image's path to create NSData
            //            let url:NSURL = NSURL(string : "urlHere")!
            //Now use image to create into NSData format
            //            let imageData:NSData = NSData.init(contentsOfURL: url)!
            
            //            print("pickedImage 64 : \(convertImageToBase64(pickedImage))")
            
        }
        dismiss(animated: true, completion: nil)
    }
    
    func convertImageToBase64(_ image: UIImage) -> String {
        
        guard let  imageData = UIImagePNGRepresentation(image) else { return "" }
        //        let base64String = imageData.base64EncodedStringWithOptions(.allZeros)
        let base64String = imageData.base64EncodedString()
        
        changedImage = true
        return base64String
        
    }// end convertImageToBase64
    
    
 
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print(("Canceleeeeddd"))
        dismiss(animated: true, completion: nil)
    }
    //    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
    //        dismiss(animated: true, completion: nil)
    //    }
    
    func setUIEnabled(enabled:Bool) {
        //        self.fbSigninBtnOL.isEnabled = enabled
        //        self.googleSigninBtnOL.isEnabled = enabled
        //        self.signBtnOL.isEnabled = enabled
        //        self.dissMissView.isEnabled = enabled
        if enabled {
//            fbActivityInd.stopAnimating()
            disableTxts = false
            profileImageBtn.isEnabled = true
            doneButton.isEnabled = true
            doneButton.alpha = 1
//            emailText.alpha = 1
//            passwordText.alpha = 1
//            signBtn.alpha = 1
//            fbBtn.alpha = 1
//            registerBtn.alpha = 1
//            backBtn.alpha = 1
//            backBtn.isEnabled = true
//            signBtn.isEnabled = true
//            fbBtn.isEnabled = true
//            registerBtn.isEnabled = true
//            signBtn.isEnabled = true
//            emailText.isEnabled = true
//            passwordText.isEnabled = true
        }else {
            disableTxts = true
            profileImageBtn.isEnabled = false
            doneButton.isEnabled = false
            doneButton.alpha = 0.5
//            fbActivityInd.startAnimating()
//            emailText.alpha = 0.5
//            passwordText.alpha = 0.5
//            signBtn.alpha = 0.5
//            fbBtn.alpha = 0.5
//            registerBtn.alpha = 0.5
//            backBtn.alpha = 0.5
//            backBtn.isEnabled = false
//            signBtn.isEnabled = false
//            fbBtn.isEnabled = false
//            registerBtn.isEnabled = false
//            signBtn.isEnabled = false
//            emailText.isEnabled = false
//            passwordText.isEnabled = false
            //            signBtnOL.alpha = 0.5
            //            dissMissView.alpha = 0.5
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
            formatter.dateFormat =   "yyyy-MM-dd"
            let date  = formatter.string(from: NSDate() as Date)
            textField.text = date
            
        }
        cityLbl.text = cityTxt.text
        playerPosition.text = positionTxt.text
    }
    
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == birthDateTxt  {
    
            
            let datePicker = UIDatePicker()
            datePicker.maximumDate = Calendar.current.date(byAdding: .year, value: -10, to: Date())
            
//            let secondsInMonth: TimeInterval = 360 * 24 * 60 * 60
//            datePicker.maximumDate = Date(timeInterval: secondsInMonth, since: Date())
            
            datePicker.datePickerMode = UIDatePickerMode.date
            textField.inputView = datePicker
            datePicker.addTarget(self, action: #selector(self.timePickerChanged(_:)), for: .valueChanged)
        }
    }
    
    func timePickerChanged(_ sender: UIDatePicker) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
             birthDateTxt.text = formatter.string(from: sender.date)
 }
    
    
    @IBAction func loadImageButtonTapped(sender: UIButton) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self

        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        
        present(imagePicker, animated: true, completion: nil)
    }


 
}

