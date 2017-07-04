//
//  NoNetConnectionVC.swift
//  Elmla3eb
//
//  Created by Macbook Pro on 4/25/17.
//  Copyright © 2017 Killvak. All rights reserved.
//

import UIKit

class NoNetConnectionVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func tryAgainBtnAct(_ sender: UIButton) {
        
        dismiss(animated: true, completion: nil)
        ad.reload()
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
