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


//protocol profileupdatedImageDelegate : class {
//    func delegateUpdate()
//}
class ProfileVC: ToSideMenuClass{
    
    @IBOutlet weak var cityTxt: UITextField!
    //ForgotPassword
    @IBOutlet weak var showNewPassBtn: UIButton!
    @IBOutlet weak var showOldPassBtn: UIButton!
    @IBOutlet weak var loadingChangePass: UIActivityIndicatorView!
    
    @IBOutlet weak var confirmPassChange: UIButtonX!
    @IBOutlet weak var cancelPassChange: UIButtonX!
    @IBOutlet weak var forgotPassView: UIViewX!
    @IBOutlet weak var oldPassTxt: UITextFieldX!
    @IBOutlet weak var newPassTxt: UITextFieldX!
    @IBOutlet weak var changePassword: UIButton!
    
    //
    @IBOutlet weak var positionTxt: UITextField!
    
    @IBOutlet weak var profileImageBtn: UIButton!
    @IBOutlet weak var editProfileBtn: UIButton!
    @IBOutlet weak var profileImage: UIImageViewX!
    @IBOutlet weak var favPoints: UILabel!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var uploadingPhotoLbl: UILabel!
    
    @IBOutlet weak var playerPosition: UILabel!
    
    @IBOutlet weak var teamName: UILabel!
    
    @IBOutlet weak var userName: UILabel!
    
    @IBOutlet weak var cityLbl: UILabel!
    @IBOutlet weak var loadingActivity: UIActivityIndicatorView!
    
    @IBOutlet weak var phoneNumTxt: UITextFieldX!
    @IBOutlet weak var birthDateTxt: UITextFieldX!
    
    @IBOutlet weak var playerStackBar: UIStackView!
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
    
//    weak var profileImageDelegate : profileupdatedImageDelegate?
    
    var profileData : PostLoginVars?
    var intPoints = 0
    var positions =  [String]()
    var isFbUser = false
    var imageUrl = "" {
        didSet {
            //            print("thatis the image url : \(imageUrl)")
            guard let url = URL(string: imageUrl ) else { return }
            profileImage.af_setImage(
                withURL: url,
                placeholderImage: profileImage.image,
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
    var cityDic = [String:Int]()
    var imageResponse = ""
    var disableTxts = false  {
        didSet {
            if disableTxts {
                phoneNumTxt?.isEnabled = false
                birthDateTxt?.isEnabled = false
                snapCTxt?.isEnabled = false
                profileImageBtn?.isEnabled = false
                changePassword?.isEnabled = false
            }else {
                phoneNumTxt?.isEnabled = false
                birthDateTxt?.isEnabled = true
                snapCTxt?.isEnabled = true
                profileImageBtn?.isEnabled = true
                changePassword?.isEnabled = true
            }
        }
    }
    var isOwner = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.squareLoading.start(0)
        disableTxts = true
        title =  langDicClass().getLocalizedTitle("Profile")
        emptyFields()
        //        print("that's positions : \(positions)")
        if  L102Language.currentAppleLanguage() != "ar"   {
            positions =  ["Goalkeeper","Defence","Striker","Midfield"]
        }else {
            positions =  ["حارس مرمي","مدافع","مهاجم","وسط"]
        }
        
        if let userType = UserDefaults.standard.value(forKey: "User_Type") as? String  , userType == "pg_owner" { // Hide Bar
            playerStackBar.alpha =  0
            isOwner = true
        }else {//Show Bar
            playerStackBar.alpha =  1
        }
        
        setupPickerV()
        
        fetchdata()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
  
    
    func setupViewData(_ _data : PostLoginVars?) {
        guard let data = _data else { return }
        self.userName.text = data.name
        self.snapCTxt.text = data.snapChat
        self.birthDateTxt.text = data.birth_date
        self.teamName.text = data.team
        self.playerPosition.text = data.positionName
        self.favPoints.text =  data.points
        self.intPoints = data.intPoints
        self.cityLbl.text = data.city
        self.phoneNumTxt.text = data.mobile
        self.positionTxt.text = data.positionName
        self.cityTxt.text = data.city
        self.isFbUser = data.isFbUser
        self.imageResponse = data.image_Response
        //                    print("that's the fb : \(data.isFbUser) , \(self?.isFbUser)")
        //                    self?.imageUrl = data.image
        if   let imageurl = UserDefaults.standard.value(forKey: "profileImage") as? String  {
            self.imageUrl = imageurl
        }

    }
    func fetchdata() {
        user.getProfileData { [weak self] (data, sms, state) in
            
            
            if state , let data = data  {
                DispatchQueue.main.async {
                    self?.profileData = data
                    self?.setupViewData(data)
                     /*
 Eslam L: 9
                     Ahmed Android : 7
                     ahmned : 16
 */
                    
                    let searchModel = Search_Model()
                    searchModel.getCitiesList { [weak self] (_data, sms, state) in
                        guard let data = _data else {
                            self?.cities = []
                            self?.view.squareLoading.stop(0.0)
                            return
                        }
                        if  L102Language.currentAppleLanguage() == "ar"{
                            for city in data {
                                 self?.cities.append(city.name_ar)
                                self?.cityDic[city.name_ar] = city.id
                               
                            }
                        }else {
                            for city in data {
                                 self?.cities.append(city.name_en)
                                 self?.cityDic[city.name_en] = city.id
                            }
                        }
                        
                        DispatchQueue.main.async {
                            self?.view.squareLoading.stop(0)
                        }}                        
                    }

                    
                    
                    
                   
            }else {
                DispatchQueue.main.async {
                self?.view.squareLoading.stop(0)
                self?.showAlert(langDicClass().getLocalizedTitle(" Network Time out "), langDicClass().getLocalizedTitle("Please Check Your Net Connection and try again!!"))
                
                    self?.dismiss(animated: true, completion: nil)  
                }
            }
        }
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true) //This will hide the keyboard
    }
    
    override func toSidemenuVC() {
        super.toSidemenuVC()
        ad.sideMenuTrigger(self,"Profile")
        self.editUserDataBtnAct()
        setupViewData(profileData)
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
            if  !isFbUser{
                changePassword.alpha = 1
                changePassword.isEnabled = true
            }
           
        }else {
        editUserDataBtnAct()
                 setupViewData(profileData)
         }
    }
    
    func editUserDataBtnAct() {
        disableTxts = true
        editProfileBtn?.isSelected = false
        editProfileBtn?.setImage(UIImage(named:"Edit User Male_5d5e61_32"), for: .normal)
        self.doneButton?.alpha = 0
        self.doneButton?.isEnabled = false
        changePassword?.alpha = 0
        changePassword?.isEnabled = false
    }
    
    @IBAction func doneBtnAct(_ sender: UIButton) {
        var cityId : Int?
        if  let citytxt = cityTxt.text ,  let cityid = cityDic[citytxt]  {
            cityId = cityid
        }
        setUIEnabled(enabled: false )
        //        print("that's the  url : \(imageUrl)\n Base64 : \(base64String)\n changedImage: \(changedImage) ")
        user.postProfileData(name: userName.text, mobile: nil, city: cityId, team: teamName.text, birthD: birthDateTxt.text, lon: nil, lat: nil, image: changedImage ? base64String : imageResponse ,snap_chat:snapCTxt.text,position:positionTxt.text) { [weak self](data,state, sms) in
            
            if state {
                DispatchQueue.main.async {
                    
                    let alert = CDAlertView(title: langDicClass().getLocalizedTitle("Done"), message:"" , type: .success)
                    alert.show()

                    self?.editProfileBtn.setImage(UIImage(named:"Edit User Male_5d5e61_32"), for: .normal)
                    self?.editProfileBtn.isSelected = false
                    self?.setUIEnabled(enabled: true)
                    self?.doneButton.alpha = 0
                    self?.doneButton.isEnabled = false
                    self?.changePassword.alpha = 0
                    self?.changePassword.isEnabled = false
                    self?.changePassword?.isEnabled = false
                    self?.disableTxts = true
                    self?.changedImage = false
                    UserDefaults.standard.setValue(self?.userName.text, forKey: "usreName")
                    self?.profileData = data
//                    let changedImageBool = self?.changedImage
//                    if changedImageBool != nil , x {
//                        self?.profileImageDelegate?.delegateUpdate()
//                    }
                }
            }else {
                DispatchQueue.main.async {
                    
                    self?.showAlert(langDicClass().getLocalizedTitle("Failed Uploading Changes"), langDicClass().getLocalizedTitle("try again!!"))
                    self?.setUIEnabled(enabled: true )
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
        guard   !disableTxts  else { return }
        self.view.endEditing(true) //This will hide the keyboard
        switch sender.tag {
        case 1 : // City
            //            print("city")
            cityTxt.becomeFirstResponder()
        case 2: // Team
            guard !isOwner else { return }
            presentAlert(langDicClass().getLocalizedTitle("Pick Team"), langDicClass().getLocalizedTitle("Team Name"), langDicClass().getLocalizedTitle("Team Name"), teamName)
        case 3 : // Position
            //            print("Position")
               guard !isOwner else { return }
            positionTxt.becomeFirstResponder()
      
        default :
            presentAlert("name", "enter your nickname", "nickname", userName)
        }
    }
    
    @IBAction func pointsBtnAct(_ sender: UIButton) {
        guard !isOwner else { return }
//        print("Pointssssss")
        let vc = PointsViewController(nibName : "PointsViewController" , bundle : nil )
        vc.currentPoints = intPoints
        vc.delegate = self
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
        
    func setUIEnabled(enabled:Bool) {
        //        self.fbSigninBtnOL.isEnabled = enabled
        //        self.googleSigninBtnOL.isEnabled = enabled
        //        self.signBtnOL.isEnabled = enabled
        //        self.dissMissView.isEnabled = enabled
        if enabled {
            loadingActivity.stopAnimating()
            self.uploadingPhotoLbl.alpha = 0
            profileImageBtn.isEnabled = true
            doneButton.isEnabled = true
            doneButton.alpha = 1
            editProfileBtn.alpha = 1
            editProfileBtn.isEnabled = true
            if !isFbUser{
                changePassword.alpha = 1
                changePassword.isEnabled = true
            }
            
        }else {
            loadingActivity.startAnimating()
            if changedImage {
                self.uploadingPhotoLbl.alpha = 1
            }
            profileImageBtn.isEnabled = false
            doneButton.isEnabled = false
            doneButton.alpha = 0.5
            editProfileBtn.alpha = 0.5
            editProfileBtn.isEnabled = false
            
            if !isFbUser{
                changePassword.alpha = 0.5
                changePassword.isEnabled = false
            }
        }
        
    }
    
    //MARK: forgot Password
    
    @IBAction func changePasswordTrigger(_ sender: UIButton) {
        setupChangePasswordView()
        UIView.animate(withDuration: 0.3) {
            self.forgotPassView.alpha = 1
            self.forgotPassView.transform = .identity
        }
    }
    
    @IBAction func confirmPasswordChange(_ sender: UIButton) {
        disableChangePassView(true)
        guard let new = newPassTxt.text , !new.isEmpty  , let old = oldPassTxt.text , !old.isEmpty else {
            showAlert(langDicClass().getLocalizedTitle("All Fields are Required"),"")
            disableChangePassView(false)
            
            return
        }
        guard let oldPass = oldPassTxt.text , oldPass.isValidPassword else {
            showAlert(langDicClass().getLocalizedTitle("Old Password Must has to be > 8 and < 20"),"")
            disableChangePassView(false)
            return
        }
        guard let newPass = newPassTxt.text , newPass.isValidPassword else {
            showAlert(langDicClass().getLocalizedTitle("New Password Must has to be > 8 and < 20"),"")
            disableChangePassView(false)
            return
        }
        
        
        user.postChangeUserPassword(userID: USER_ID, oldPassword: oldPass, newPassword: newPass) {[weak self] (state, sms) in
            
            if state {
                DispatchQueue.main.async {
                    
                    let alert = CDAlertView(title: langDicClass().getLocalizedTitle("Done"), message:"" , type: .success)
                    alert.show()
                    
                    self?.dismissView()
                    self?.disableChangePassView(false)
                }
            }else {
                DispatchQueue.main.async {
                    
                    self?.showAlert("", langDicClass().getLocalizedTitle("Error with ") + "\(sms)")
                    self?.disableChangePassView(false)
                }
            }
        }
    }
    @IBAction func cancelPasswordChange(_ sender: UIButton) {
        dismissView()
    }
    @IBAction func showPassword(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        sender.setImage(#imageLiteral(resourceName: "hidePass"), for: .normal)
        sender.setImage(#imageLiteral(resourceName: "showPass"), for: .selected)
        
        switch sender.tag {
        case 0 :
            self.oldPassTxt.isSecureTextEntry = !sender.isSelected
        default:
            self.newPassTxt.isSecureTextEntry = !sender.isSelected
            
            return
        }
    }
    
    var backGroundBlackView : UIView!
    
    func setupChangePasswordView() {
        
        backGroundBlackView = UIView(frame: CGRect(x: 0, y: 0, width: Constants.screenSize.width, height: Constants.screenSize.height))
        backGroundBlackView.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        
        self.navigationController?.view.addSubview(backGroundBlackView)
        
        //        let customVC = ChangePassViewX.instanceFromNib()
        //        ratingView.frame = CGRect(x: 0, y: 60, width: Constants.screenSize.width - 50 , height:  Constants.screenSize.width - 50 )
        //        forgotPassView =
        
        forgotPassView.frame = CGRect(x: 0, y: 60, width: 290 , height: 290 )
        forgotPassView.clipsToBounds = true
        forgotPassView.center = view.center
        forgotPassView.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        
        self.navigationController?.view.addSubview(forgotPassView)
        
    }
    
    
    func dismissView() {
        self.oldPassTxt.text = ""
        self.newPassTxt.text = ""
        showNewPassBtn.isSelected = false
        showOldPassBtn.isSelected = false
        self.oldPassTxt.isSecureTextEntry = true
        self.newPassTxt.isSecureTextEntry = true
        showNewPassBtn.setImage(#imageLiteral(resourceName: "hidePass"), for: .normal)
        showOldPassBtn.setImage(#imageLiteral(resourceName: "hidePass"), for: .normal)
        UIView.animate(withDuration: 0.8, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: [], animations: {
            self.backGroundBlackView.alpha = 0
            self.forgotPassView.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
            self.forgotPassView.alpha = 0
        }) { [weak self ] (true ) in
            self?.forgotPassView.transform = CGAffineTransform.identity
            self?.forgotPassView.removeFromSuperview()
            self?.backGroundBlackView.removeFromSuperview()
        }
        
    }
    
    func disableChangePassView(_ state : Bool) {
        if state {
            loadingChangePass.startAnimating()
            confirmPassChange.isEnabled = false
            confirmPassChange.alpha = 0.5
            cancelPassChange.isEnabled = false
            cancelPassChange.alpha = 0.5
            oldPassTxt.isEnabled = false
            oldPassTxt.alpha = 0.5
            newPassTxt.isEnabled = false
            newPassTxt.alpha = 0.5
            changePassword.isEnabled = false
            changePassword.alpha = 0.5
        }else {
            loadingChangePass.stopAnimating()
            confirmPassChange.isEnabled = true
            confirmPassChange.alpha = 1
            cancelPassChange.isEnabled = true
            cancelPassChange.alpha = 1
            oldPassTxt.isEnabled = true
            oldPassTxt.alpha = 1
            newPassTxt.isEnabled = true
            newPassTxt.alpha = 1
            changePassword.isEnabled = true
            changePassword.alpha = 1
        }
    }
}



//MARK: PickerView
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
            let date_ = Calendar.current.date(byAdding: .year, value: -10, to: Date())
            formatter.dateFormat =   "yyyy-MM-dd"
            guard let date = date_ else { return }
            let dateS  = formatter.string(from: date )
            textField.text = dateS
            
        }
        cityLbl.text = cityTxt.text
        playerPosition.text = positionTxt.text
    }
    
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == birthDateTxt  {
            
            
            let datePicker = UIDatePicker()
            datePicker.maximumDate = Calendar.current.date(byAdding: .year, value: -10, to: Date())
            datePicker.minimumDate = Calendar.current.date(byAdding: .year, value: -90, to: Date())
            
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
    
                                                         
    
}



extension ProfileVC {
    
    func getTextfield(view: UIView) -> [UITextField] {
        var results = [UITextField]()
        for subview in view.subviews as [UIView] {
            if let textField = subview as? UITextField {
                results += [textField]
            } else {
                results += getTextfield(view: subview)
            }
        }
        return results
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let allTextFields = getTextfield(view: self.view)
        for textField in allTextFields
        {
            textField.font = UIFont.boldSystemFont(ofSize: 14)
            var widthOfText: CGFloat = textField.text!.size(attributes: [NSFontAttributeName: textField.font!]).width
            var widthOfFrame: CGFloat = textField.frame.size.width
            while (widthOfFrame - 15) < widthOfText { // try here to find the value that fits your needs
                let fontSize: CGFloat = textField.font!.pointSize
                textField.font = textField.font?.withSize(CGFloat(fontSize - 0.5))
                widthOfText = (textField.text?.size(attributes: [NSFontAttributeName: textField.font!]).width)!
                widthOfFrame = textField.frame.size.width
            }
        }
    }
}


extension ProfileVC : UIImagePickerControllerDelegate , UINavigationControllerDelegate {
    
    // MARK: - UIImagePickerControllerDelegate Methods
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            profileImage.contentMode = .scaleAspectFill
            let myThumb  = pickedImage.resizeImageWith(newSize: CGSize(width: 200, height: 200))
            profileImage.image = myThumb
            
            base64String = convertImageToBase64(myThumb)
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
        //        print(("Canceleeeeddd"))
        dismiss(animated: true, completion: nil)
    }
    //    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
    //        dismiss(animated: true, completion: nil)
    //    }
    
    @IBAction func loadImageButtonTapped(sender: UIButton) {
        
        let alert = UIAlertController(title: langDicClass().getLocalizedTitle("Pick Your Profile Image"), message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: langDicClass().getLocalizedTitle("Photo Gallery"), style: .default) { [weak self ] action in
            self?.pickProfileImage(.photoLibrary)
        })
        
        alert.addAction(UIAlertAction(title: langDicClass().getLocalizedTitle("Camera"), style: .default) { [weak self ] action in
            // perhaps use action.title here
            self?.pickProfileImage(.camera)
        })
        alert.addAction(UIAlertAction(title: langDicClass().getLocalizedTitle("Delete Image"), style: .destructive) { [weak self ] action in
            // perhaps use action.title here
            self?.base64String = "     "
            self?.changedImage = true
            UserDefaults.standard.setValue(nil, forKey: "profileImage")
            self?.profileImage.image =  UIImage(named: "nobody_m.original")
        })
        alert.addAction(UIAlertAction(title: langDicClass().getLocalizedTitle("Cancel"), style: .cancel) { action in
            // perhaps use action.title here
        })
        self.present(alert, animated: true)
    }
    
    func pickProfileImage(_ type : UIImagePickerControllerSourceType ) {
        if type == .camera {
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) {
                let imagePicker = UIImagePickerController()
                imagePicker.delegate = self

                imagePicker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .camera)!
                imagePicker.sourceType = .camera
                imagePicker.allowsEditing = false
                self.present(imagePicker, animated: true, completion: nil)
            }

        }else {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            
            imagePicker.allowsEditing = false
            imagePicker.sourceType = type
            
            self.present(imagePicker, animated: true, completion: nil)
        }
        
    }
}

extension ProfileVC : pointsDelegateUpdateProfile {
    
    func updateData() {
        
//        print("Fetched Points Delegate ")
        self.fetchdata()
    }
}
