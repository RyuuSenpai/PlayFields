
//
//  BookedFieldsDatesCell.swift
//  Elmla3eb
//
//  Created by Macbook Pro on 3/28/17.
//  Copyright © 2017 Killvak. All rights reserved.
//

import UIKit

protocol updateDataTrigger : class {
    
    func triggerupdate()
    func startLoading()
    func stopLoading()
    
}

class BookedFieldsDatesCell: UITableViewCell , UITableViewDelegate,UITableViewDataSource  {
    @IBOutlet weak var firstView: UIView!
    
    @IBOutlet weak var loadingActivity: UIActivityIndicatorView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var secondView: UIView!
    
    @IBOutlet weak var NoDataFoundLbl: UILabel!
    
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var dayTitle: UILabel!
    
    @IBOutlet weak var amBtn: UIButton!
    
    @IBOutlet weak var pmBtn: UIButton!
    
    weak  var delegate : updateDataTrigger?
    lazy var reservationModel = ReservationModel()
    var hideAmPmBtns : Bool? {
        didSet {
            if let x = hideAmPmBtns {
                amBtn?.isHidden = x
                pmBtn?.isHidden = x
            }
        }
    }
    var isBooked = false
    //    @IBOutlet weak var secondViewHeight: NSLayoutConstraint!
    var currentarrayTitle = "am"
    //    var  xcz = [ 1 , 2 ,3 ,4 ,5 ]
    var bookingData : OwnerP_G_BookingData?{
        didSet {
            guard let data = bookingData else { print("📍notBooked_Data == nil");return }
            amData = data.amData
            pmData = data.pmData
            if currentarrayTitle == "am" {
                amBtnClicked()
            }else {
                pmBtnClicked()
            }
            //                        currentTimeArray = amData
            //                        self.tableView?.reloadData()
            print("testtt")
            //            amBtnClicked()
        }
    }
    
    
    var currentTimeArray : [AmPm_data]?{
        didSet {
            guard let _ = currentTimeArray else{ print("📍currentTimeArray == nil"); return }
            
            //            tableView.reloadData()
        }
    }
    var amData : [AmPm_data]?{
        didSet {
            guard let _ = amData else{ print("📍Am_data == nil"); return }
            //            currentTimeArray = amData
        }
    }
    var pmData : [AmPm_data]?{
        didSet {
            guard let _ = pmData else{ print("📍Pm_data == nil"); return }
        }
    }
    
    
    
    var resetCellBtn = false
    var isAM = true
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        tableView.delegate = self
        tableView.dataSource = self
        amBtn.addTarget(self, action: #selector(self.amBtnClicked), for: .touchUpInside )
        pmBtn.addTarget(self, action: #selector(self.pmBtnClicked), for: .touchUpInside )
        
        //        xcz = am
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("that is the row : \(indexPath.row)")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let count = currentTimeArray?.count , count > 0 else {
            NoDataFoundLbl.alpha = 1 ;return 0 }
        NoDataFoundLbl.alpha = 0
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BookNowCell", for: indexPath) as! BookNowCell
        guard let data = currentTimeArray else { return cell }
        cell.label.text = data[indexPath.row].time
        //        cell.tag = indexPath.row
        cell.selectRow.isSelected = false
        cell.selectRow.tag = indexPath.row
        
        
        if isBooked {
            cell.selectRow.alpha = 1
            if data[indexPath.row].confirmedBool {
                cell.selectRow.setTitle("Attendance", for: .normal)
                
            }else {
                cell.selectRow.setTitle("Confirm", for: .normal)
                
            }
            
            cell.selectRow.addTarget(self, action: #selector(self.selectedCell(_:)), for: .touchUpInside)
        }else {
            cell.selectRow.alpha = 0
        }
        return cell
    }
    
    //    var showsDetails = false {
    //        didSet {
    //            secondViewHeight.priority = showsDetails ? 250 : 999
    //        }
    //    }
    
    func selectedCell(_ sender : UIButton) {
        self.delegate?.startLoading()
        print("thats the index : \(sender.tag)")
        //        self.loadingActivity.startAnimating()
        self.isUserInteractionEnabled = false
        //        print("sndertag : \(sender.tag) currentTimeArray count before : \(self.currentTimeArray?.count) and the selected array is :\(currentarrayTitle)")
        guard let data = currentTimeArray , sender.tag <= data.count  else {
            self.delegate?.stopLoading()
            //            self.loadingActivity.stopAnimating()
            self.isUserInteractionEnabled = true
            return  }
        let id = data[sender.tag].id
        let time = data[sender.tag].time
        //        print("that the timee selected : \(time)")
        let isConfirmed = data[sender.tag].confirmedBool
        guard id != 0 else {
            //            print("❌fatal error id equal 0 selectedCell(_ sender : UIButton)" ) ;
            return }
        if isConfirmed {
            reservationModel.postAttendanceRequest(id: id, completed: {[weak self] (sms, state) in
                guard state else {
                    DispatchQueue.main.async {
                        
                        self?.isUserInteractionEnabled = true
                        self?.delegate?.stopLoading()
                        ad.showAlert("X", sms) ;print("Attendance request has failed❗️");
                        
                    }
                    return }
                
                //                self?.currentTimeArray?.remove(at: sender.tag)
                if self?.currentarrayTitle == "am" {
                    self?.amData?.remove(at: sender.tag)
                    self?.currentTimeArray = self?.amData
                }else {
                    self?.pmData?.remove(at: sender.tag)
                    self?.currentTimeArray = self?.pmData
                }
                //                self?.tableView.reloadData()
                DispatchQueue.main.async {
                    //didn't Work
                    //                    let indexPath = IndexPath(item: sender.tag, section: 0)
                    
                    //                    self?.tableView.reloadData()
                    self?.isUserInteractionEnabled = true
                    self?.delegate?.triggerupdate()
                }
                
            })
        }else {
            guard let data = currentTimeArray , sender.tag <= data.count  else { return  }
            
            reservationModel.postConfirmRequest(id: id) { [weak self] (sms, state) in
                guard state else {
                    DispatchQueue.main.async {
                        
                        self?.delegate?.stopLoading()
                        self?.isUserInteractionEnabled = true
                        ad.showAlert("X", sms) ;print("confirm request has failed❗️")
                    }
                    return }
                
                if self?.currentarrayTitle == "am" {
                    self?.amData?[sender.tag]._confirmed = 1
                    self?.currentTimeArray = self?.amData
                }else {
                    self?.pmData?[sender.tag]._confirmed = 1
                    self?.currentTimeArray = self?.pmData
                }
                //                self?.tableView.reloadRows(at: [[0,sender.tag]], with: UITableViewRowAnimation.automatic )
                //                self?.tableView.reloadData()
                DispatchQueue.main.async {
                    self?.tableView.beginUpdates()
                    let indexPath = IndexPath(item: sender.tag, section: 0)
                    self?.tableView.reloadRows(at: [indexPath], with: .top)
                    self?.tableView.endUpdates()
                    self?.isUserInteractionEnabled = true
                    ad.showAlert("√", "")
                    self?.delegate?.triggerupdate()
                }
            }
            
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            print("Deleted")
            guard let id =  self.currentTimeArray?[indexPath.row].id , id != 0  else {
                ad.showAlert("default", "")
                return }
            self.delegate?.startLoading()
            self.isUserInteractionEnabled = false
            
            reservationModel.postCancelRequest(id, completed: { [weak self ] (sms, state) in
                
                if self?.currentarrayTitle == "am" {
                    self?.amData?.remove(at: indexPath.row)
                    self?.currentTimeArray = self?.amData
                }else {
                    self?.pmData?.remove(at: indexPath.row)
                    self?.currentTimeArray = self?.pmData
                }
                DispatchQueue.main.async {
                    self?.tableView.deleteRows(at: [indexPath], with: .top)
                    //                    self?.tableView.reloadData()
                    self?.isUserInteractionEnabled = true
                    self?.delegate?.triggerupdate()
                }
            })
        }
    }
    
    
    func amBtnClicked() {
        currentarrayTitle = "am"
        self.currentTimeArray = amData
        isAM = true
        tableView.reloadData()
        self.pmBtn.backgroundColor = Constants.Colors.green
        
        self.amBtn.backgroundColor = Constants.Colors.darkGreen
    }
    
    func pmBtnClicked() {
        currentarrayTitle = "pm"
        isAM = false
        self.currentTimeArray = pmData
        tableView.reloadData()
        self.pmBtn.backgroundColor = Constants.Colors.darkGreen
        
        self.amBtn.backgroundColor = Constants.Colors.green
        
    }
}
