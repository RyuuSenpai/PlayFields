//
//  OwnerPlaygroundsVC.swift
//  Elmla3eb
//
//  Created by Macbook Pro on 6/13/17.
//  Copyright © 2017 Killvak. All rights reserved.
//

import UIKit

class OwnerPlaygroundsVC: ToSideMenuClass {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var loadingActivity: UIActivityIndicatorView!
    @IBOutlet weak var paymentBtn: UIButton!
    @IBOutlet weak var playgroundBtn: UIButton!
    @IBOutlet weak var noplaygLbl: UILabel!
    
    
    
    var serviceCounter = 0 {
        didSet {
            if serviceCounter == 2 {
                self.tableView.reloadData()
                self.view.squareLoading.stop(0)
            }
        }
    }
    var buttonTag = 0 {
        didSet {
            tableView.reloadData()
        }
    }
    
    var ownerPlaygrounds = [NearByFields_Data]()
    var ownerpaymentData = [PaymentStatics_Data]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
self.view.squareLoading.start(0)
        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        
        let nib = UINib(nibName: "FieldsCell", bundle: nil)
        
        tableView.register(nib, forCellReuseIdentifier: "cell")
        getOwnerData()
    }

    override func toSidemenuVC() {
        super.toSidemenuVC()
        ad.sideMenuTrigger(self,"NearBy")
    }
    
    
    @IBAction func btnsStateSwitch(_ sender: UIButton) {
        
        guard sender.tag != self.buttonTag else { return }
        self.buttonTag = sender.tag
        print("that's button tag : \(self.buttonTag) ")
        
        if sender.tag == 0 {
            playgroundBtn.backgroundColor = Constants.Colors.green
            paymentBtn.backgroundColor = Constants.Colors.gray
        }else {
            playgroundBtn.backgroundColor = Constants.Colors.gray
            paymentBtn.backgroundColor = Constants.Colors.green
        }
    }
    
    func getOwnerData() {
        
        let owner = OwnerModel()
        
        owner.getOwnerPlayGrounds { [weak self] (data, sms, state) in
            guard state , let data = data else { self?.serviceCounter += 1 ;return }
            self?.ownerPlaygrounds = data
            self?.serviceCounter += 1
        }
        
        
        owner.getOwnerPlayG_PaymentStatics { [weak self] (data, sms, state ) in
            guard state , let data = data else { self?.serviceCounter += 1 ;return }
            self?.ownerpaymentData = data
            self?.serviceCounter += 1
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
