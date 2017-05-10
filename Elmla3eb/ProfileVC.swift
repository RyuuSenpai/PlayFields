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
    @IBOutlet weak var phoneNumberLbl: UILabel!
    @IBOutlet weak var dateOfBirthLbl: UILabel!
    @IBOutlet weak var snapChatLbl: UILabel!
    
    @IBOutlet weak var userName: UILabel!{
        didSet {
            if let name = UserDefaults.standard.value(forKey: "userName") as? String{
            userName?.text = name
            }else  if let email = UserDefaults.standard.value(forKey: "userEmail") as? String{
                userName?.text = email
            }
    }
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        title =  langDicClass().getLocalizedTitle("Profile")
        self.pointslbl.text = "0" + langDicClass().getLocalizedTitle(" Points ")
    }
    
    override func toSidemenuVC() {
        super.toSidemenuVC()
        ad.sideMenuTrigger(self,"Profile")
        //        x.modalTransitionStyle = .partialCurl

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
