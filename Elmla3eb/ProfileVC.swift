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
    //ForgotPassword
    @IBOutlet weak var loadingChangePass: UIActivityIndicatorView!
    
    @IBOutlet weak var confirmPassChange: UIButtonX!
    @IBOutlet weak var cancelPassChange: UIButtonX!
    @IBOutlet weak var forgotPassView: UIViewX!
    @IBOutlet weak var oldPassTxt: UITextField!
    @IBOutlet weak var newPassTxt: UITextField!
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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.squareLoading.start(0)
        disableTxts = true
        title =  langDicClass().getLocalizedTitle("Profile")
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
            changePassword.alpha = 1
            changePassword.isEnabled = true
            
        }else {
            disableTxts = true
            sender.setImage(UIImage(named:"Edit User Male_5d5e61_32"), for: .normal)
            self.doneButton.alpha = 0
            self.doneButton.isEnabled = false
            changePassword.alpha = 0
            changePassword.isEnabled = false
        }
    }
    
    @IBAction func doneBtnAct(_ sender: UIButton) {
        setUIEnabled(enabled: false )
        user.postProfileData(name: userName.text, mobile: nil, city: cityLbl.text, team: teamName.text, birthD: birthDateTxt.text, lon: nil, lat: nil, image: changedImage ? base64String : imageUrl ,snap_chat:snapCTxt.text,position:positionTxt.text) { [weak self](state, sms) in
            
            if state {
                DispatchQueue.main.async {
                    
                    let alert = CDAlertView(title: langDicClass().getLocalizedTitle("Done"), message:"" , type: .success)
                    alert.show()
                    self?.disableTxts = true
                    self?.editProfileBtn.setImage(UIImage(named:"Edit User Male_5d5e61_32"), for: .normal)
                    self?.editProfileBtn.isSelected = false
                    self?.setUIEnabled(enabled: true)
                    self?.doneButton.alpha = 0
                    self?.doneButton.isEnabled = false
                    self?.changePassword.alpha = 0
                    self?.changePassword.isEnabled = false
                    self?.changePassword?.isEnabled = false

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
            let myThumb  = pickedImage.resizeImageWith(newSize: CGSize(width: 200, height: 200))
            profileImage.image = myThumb
            
            base64String = convertImageToBase64(myThumb)
            // //           base64String = pickedImage.base64EncodedString
            //            print("that's base 64 : \(base64String)")
            
            //            let imageData:NSData = UIImagePNGRepresentation(pickedImage)! as NSData
            
            //            let selectedImage = info[UIImagePickerControllerOriginalImage] as!  UIImage
            
            
            
            
            //                         if  let img = UIImageJPEGRepresentation((myThumb 	),1) {
            //
            //                let selectedImageData: NSData = NSData(data: img)
            //
            //                let selectedImageSize:Int = selectedImageData.length
            //                print("myThumb3 Size:  KB : \( selectedImageSize / 1024)")
            //                //OR next possibility
            //            }
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
            loadingActivity.stopAnimating()
            self.uploadingPhotoLbl.alpha = 0
            disableTxts = false
            profileImageBtn.isEnabled = true
            doneButton.isEnabled = true
            doneButton.alpha = 1
            editProfileBtn.alpha = 1
            editProfileBtn.isEnabled = true
            changePassword.alpha = 1
            changePassword.isEnabled = true
            
        }else {
            disableTxts = true
            loadingActivity.startAnimating()
            if changedImage {
                self.uploadingPhotoLbl.alpha = 1
            }
            profileImageBtn.isEnabled = false
            doneButton.isEnabled = false
            doneButton.alpha = 0.5
            editProfileBtn.alpha = 0.5
            editProfileBtn.isEnabled = false
            
            changePassword.alpha = 0.5
            changePassword.isEnabled = false
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
        guard let newPass = newPassTxt.text , newPass.isValidPassword else {
            showAlert(langDicClass().getLocalizedTitle("Old Password Field is Valid"),"")
            disableChangePassView(false)
            return
        }
        guard let oldPass = oldPassTxt.text , oldPass.isValidPassword else {
            showAlert(langDicClass().getLocalizedTitle("New Password Field is Valid"),"")
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
    
    
    @IBAction func loadImageButtonTapped(sender: UIButton) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        
        present(imagePicker, animated: true, completion: nil)
    }
    
    
    
}




extension UIImage {
    var base64EncodedString: String? {
        if let data = UIImagePNGRepresentation(self) {
            //            let dataStr = data.base64EncodedString(options: [])
            
            return data.base64EncodedString(options: [.lineLength64Characters])
        }
        return nil
    }
}


extension UIImage {
    func resized(withPercentage percentage: CGFloat) -> UIImage? {
        let canvasSize = CGSize(width: size.width * percentage, height: size.height * percentage)
        UIGraphicsBeginImageContextWithOptions(canvasSize, false, scale)
        defer { UIGraphicsEndImageContext() }
        draw(in: CGRect(origin: .zero, size: canvasSize))
        return UIGraphicsGetImageFromCurrentImageContext()
    }
    func resized(toWidth width: CGFloat) -> UIImage? {
        let canvasSize = CGSize(width: width, height: CGFloat(ceil(width/size.width * size.height)))
        UIGraphicsBeginImageContextWithOptions(canvasSize, false, scale)
        defer { UIGraphicsEndImageContext() }
        draw(in: CGRect(origin: .zero, size: canvasSize))
        return UIGraphicsGetImageFromCurrentImageContext()
    }
    
    
    
    func resizeImageWith(newSize: CGSize) -> UIImage {
        
        let horizontalRatio = newSize.width / size.width
        let verticalRatio = newSize.height / size.height
        
        let ratio = max(horizontalRatio, verticalRatio)
        let newSize = CGSize(width: size.width * ratio, height: size.height * ratio)
        UIGraphicsBeginImageContextWithOptions(newSize, true, 0)
        draw(in: CGRect(origin: CGPoint(x: 0, y: 0), size: newSize))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
    
}
