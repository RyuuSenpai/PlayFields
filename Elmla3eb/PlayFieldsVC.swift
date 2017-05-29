//
//  PlayFieldsVC.swift
//  Elmla3eb
//
//  Created by Macbook Pro on 3/23/17.
//  Copyright © 2017 Killvak. All rights reserved.
//

import UIKit

class PlayFieldsVC: UIViewController {
    
    @IBOutlet weak var searchBarText: UISearchBar!
    @IBOutlet weak var confirmedBtn: UIButton!
    @IBOutlet weak var bookedFieldsBtn: UIButton!
    @IBOutlet weak var unconfirmedBtn: UIButton!
    @IBOutlet weak var nearByFieldsBtn: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var selectionBtnsViewHeightConstant: NSLayoutConstraint!
    
    var buttonTag : Int = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let nib = UINib(nibName: "FieldsCell", bundle: nil)
        
        tableView.register(nib, forCellReuseIdentifier: "cell")
        // Do any additional setup after loading the view.
        let tapped = UITapGestureRecognizer(target: self, action: #selector(self.closekeyBoard(_:)))
        
        self.view.addGestureRecognizer(tapped)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.alpha = 0
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tableView.alpha = 1
        animateTableView()
    }
    
    func closekeyBoard(_ tapped : UITapGestureRecognizer) {
        
        view.endEditing(true)
    }
    
    
    @IBAction func typeOfFieldsBtnsAction(_ sender: UIButton) {
        
        guard sender.tag != self.buttonTag else { return }
        if sender.tag == 0 {
            
        }else if sender.tag == 1 {
            
        }
        self.buttonTag = sender.tag
        print("that's button tag : \(self.buttonTag) ")
        switch sender.tag {
        case 0:
            UIView.animate(withDuration: 0.5, animations: {
                self.selectionBtnsViewHeightConstant.constant = 47
                self.nearByFieldsBtn.backgroundColor = Constants.Colors.red
                self.bookedFieldsBtn.backgroundColor = Constants.Colors.gray
                self.view.layoutIfNeeded()
            })
        case 1 :
            UIView.animate(withDuration: 0.5, animations: {
                self.selectionBtnsViewHeightConstant.constant = 96
                self.nearByFieldsBtn.backgroundColor = Constants.Colors.gray
                self.bookedFieldsBtn.backgroundColor = Constants.Colors.red
                self.confirmedBtn.backgroundColor = Constants.Colors.gray
                self.unconfirmedBtn.backgroundColor = Constants.Colors.green
                self.view.layoutIfNeeded()
            })
        case 2 :
            self.confirmedBtn.backgroundColor = Constants.Colors.green
            self.unconfirmedBtn.backgroundColor = Constants.Colors.gray
        default:
            self.confirmedBtn.backgroundColor = Constants.Colors.gray
            self.unconfirmedBtn.backgroundColor = Constants.Colors.green
        }
        tableView.scrollToRow(at: [0,0], at: UITableViewScrollPosition.top, animated: true)
        tableView.reloadData()
        animateTableView()
        
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
