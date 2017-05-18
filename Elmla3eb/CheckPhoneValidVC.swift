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
    
    @IBOutlet weak var activeOL: UIButton!
    @IBOutlet weak var resendBtnOL: UIButton!
    @IBOutlet weak var confirmationCodeTxt: UITextField!
    var userId : Int?
    var userName : String?
    let userModel = MUserData()
    var repeatSendingCode : Timer?
    var timer = Timer()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        myTimer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: #selector(myUpdate), userInfo: nil, repeats: true)

        // Do any additional setup after loading the view.
 
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        repeatSendingCode?.invalidate()

    }
 
    @IBAction func btnAct(_ sender: UIButton) {
        
        if sender.tag == 0  {
            //active
            sendConfirmatioCode()
        }else {//resend
            
        }
    }
    
    func sendConfirmatioCode() {
        guard   let code = confirmationCodeTxt.text  , !code.isEmpty else {
            let alert = CDAlertView(title: langDicClass().getLocalizedTitle(""), message: langDicClass().getLocalizedTitle("Code Field is Empty")  , type: .warning)
            alert.show()
            return
        }
        if let id = userId , let name = userName    {
            userModel.getPhoneConfirmation(user_id: id , code :code, completed: {  (state, sms) in
                
                print("that's the state :\(state), and that's sms : \(sms)")
                if state {
                    ad.saveUserLogginData(email: nil, photoUrl: nil, uid: id,name:name)
                    ad.reloadApp()
                    
                    
                }else {
                    let alert = CDAlertView(title: langDicClass().getLocalizedTitle(""), message: langDicClass().getLocalizedTitle("Error with ") + "\(sms)" , type: .warning)
                    alert.show()
                    weak var weakSelf = self
//                    weakSelf?.repeatSendingCode = Timer.scheduledTimer(timeInterval: 60.0, target:  weakSelf, selector: #selector(weakSelf?.sendConfirmatioCode), userInfo: nil, repeats: true)
                    
                    weakSelf?.timer = Timer.scheduledTimer(timeInterval: 1.0, target:  weakSelf, selector: #selector(weakSelf?.changeResenderBtnTxt), userInfo: nil, repeats: true)

                    weakSelf?.changeResenderBtnTxt()
                }
            })
        }
    }
    @IBAction func resetAppBtnAct(_ sender: UIButton) {
        
        ad.reloadApp()
    }
    
    func changeResenderBtnTxt() {
 
    self.resendBtnOL.setTitle("Resend  \(self.repeatSendingCode?.timeInterval.format())", for: .normal)
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

extension TimeInterval {
    func format() -> String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.day, .hour, .minute, .second]
        formatter.unitsStyle = .abbreviated
        formatter.maximumUnitCount = 1
        
        return formatter.string(from: self)!
}
}
