//
//  ToSideMenuClass.swift
//  Elmla3eb
//
//  Created by Macbook Pro on 5/2/17.
//  Copyright © 2017 Killvak. All rights reserved.
//

import UIKit

class ToSideMenuClass: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named:"Menu_Btn"), style: .plain, target: self, action: #selector(toSidemenuVC))
    }
    
    func toSidemenuVC() {}

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
