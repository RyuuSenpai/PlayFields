//
//  BookedFieldsDatesVC.swift
//  Elmla3eb
//
//  Created by Macbook Pro on 3/27/17.
//  Copyright © 2017 Killvak. All rights reserved.
//

import UIKit

class BookedFieldsDatesVC: UIViewController , UITableViewDataSource , UITableViewDelegate {
    
    @IBOutlet weak var bookedBtn: UIButton!
    @IBOutlet weak var notBookedBtn: UIButton!
    @IBOutlet weak var expandTableView: UITableView!
    var selectedIndex = -1

    var forceCollapse = false
     let  ownerModel = OwnerModel()
    var pg_id : Int? {
        didSet {
            print("✅pg_Id has been sent")
        }
    }
    var btnSelected = 0 {
        didSet {
            print("that's the old cvalue : \(btnSelected) and that's the new \(oldValue)")
            guard btnSelected != oldValue else { return }
           expandTableView.reloadData()
        }
    }
    
    var notBooked : [OwnerP_G_BookingData]?{
        didSet {
            guard let _ = notBooked else{ print("nil NOtBooked🛂"); return }
            expandTableView.reloadData()
        }
    }
    var booked : [OwnerP_G_BookingData]?{
        didSet {
            guard let _ = booked else{ print("nil NOtBooked🛂"); return }
        }
    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
         self.expandTableView.delegate = self
        self.expandTableView.dataSource = self
        expandTableView.estimatedRowHeight = 40
        expandTableView.rowHeight = UITableViewAutomaticDimension
                //        playgView.timeDataDelegate = self
        //        let pf_Info = GetpgInfosWebServ()
        getAPIData()
        
     }
    
    func getAPIData() {
        self.view.squareLoading.start(0)
        guard let pgId = pg_id else { print("❗️Fatal Error pg_id equal nil "); return}
        ownerModel.getP_GBooksManager(userID: 53, pgID: pgId) { [weak self] (dataR, sms, state) in
            guard state else {
                self?.view.squareLoading.stop(0)
                ad.showAlert("defaultTitle", sms )
                return
            }
            
            if let data = dataR {
                //                self?.ownerData = OwnerBooksmanager_Data()
                self?.booked = data.booked
                self?.notBooked = data.notBooked
            }
            self?.view.squareLoading.stop(0)
        }

    }
    
    func methodOfReceivedNotification(notification: Notification){
        //Take Action on Notification
        print("that is the data of times : \(notification.userInfo?["times"])")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if btnSelected == 0 {
            guard let notBookedCOunt = notBooked?.count else {
                return 0
            }
            return notBookedCOunt;
        }else {
            guard let bookedCOunt = booked?.count else {
                return 0
            }
            return bookedCOunt;
    }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "Cell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as! BookedFieldsDatesCell
        cell.delegate = self
        if btnSelected == 0 {
            guard let notBookedCOunt = notBooked else { return cell }
            cell.dayTitle.text = ""
            cell.dateLabel.text = notBookedCOunt[indexPath.row].date
            cell.bookingData = notBookedCOunt[indexPath.row]
            cell.isBooked = false
            if(selectedIndex == indexPath.row) {
                cell.hideAmPmBtns = false
            }else {
                cell.hideAmPmBtns = true
            }
            return cell;
        }else {
 
            guard let bookedCOunt = booked else { return cell }
            cell.dayTitle.text = ""
            cell.dateLabel.text = bookedCOunt[indexPath.row].date
            cell.bookingData = bookedCOunt[indexPath.row]
            cell.isBooked = true
            if(selectedIndex == indexPath.row) {
                cell.hideAmPmBtns = false
            }else {
                cell.hideAmPmBtns = true
            }
            return cell;
    }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard !forceCollapse else { forceCollapse = false ;return 42 }
        if(selectedIndex == indexPath.row) {
            //return 100;
            return 300
        } else {
            return 42;
        }
    }
    
    @IBAction func bookedBtnState(_ sender: UIButton) {
//        self.expandTableView.reloadRows(at: [[0,selectedIndex]], with: UITableViewRowAnimation.automatic )
        forceCollapse = true
        selectedIndex = -1 
        guard sender.tag != self.btnSelected else { return }
        self.btnSelected = sender.tag
        print("that's button tag : \(self.btnSelected) ")
        
        if sender.tag == 0 {
            getAPIData()
            bookedBtn.backgroundColor = Constants.Colors.green
            notBookedBtn.backgroundColor = Constants.Colors.gray
        }else {
            
            bookedBtn.backgroundColor = Constants.Colors.gray
            notBookedBtn.backgroundColor = Constants.Colors.green
        }
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if(selectedIndex == indexPath.row) {
            selectedIndex = -1
            
        } else {
            
          let   oldIndex = selectedIndex
            selectedIndex = indexPath.row
            self.expandTableView.reloadRows(at: [[0,oldIndex]], with: UITableViewRowAnimation.automatic )
        }
        self.expandTableView.beginUpdates()
        self.expandTableView.reloadRows(at: [indexPath], with: UITableViewRowAnimation.automatic )
        self.expandTableView.endUpdates()
    }
    
    
    //    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    //        let backItem = UIBarButtonItem()
    //        backItem.title = ""
    //        navigationItem.backBarButtonItem = backItem // This will show in the next view controller being pushed
    //    }
}

extension BookedFieldsDatesVC : updateDataTrigger {
    
    func triggerupdate() {
        getAPIData()
        print("TRIGGERED")
    }
}
