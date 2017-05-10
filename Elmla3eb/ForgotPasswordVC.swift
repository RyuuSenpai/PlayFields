//
//  ForgotPasswordVC.swift
//  Elmla3eb
//
//  Created by Macbook Pro on 5/8/17.
//  Copyright © 2017 Killvak. All rights reserved.
//

import UIKit

class ForgotPasswordVC: MirroringViewController {

    @IBOutlet weak var phoneNumTxt: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func senderData(_ sender: UIButton) {
    }
    @IBAction func backBtnAct(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
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
