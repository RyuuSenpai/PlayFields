
//
//  BookedFieldsDatesCell.swift
//  Elmla3eb
//
//  Created by Macbook Pro on 3/28/17.
//  Copyright © 2017 Killvak. All rights reserved.
//

import UIKit

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
        }
    }
    var currentTimeArray : [AmPm_data]?{
        didSet {
            guard let _ = currentTimeArray else{ print("📍currentTimeArray == nil"); return }
            tableView.reloadData()
}
    }
    var amData : [AmPm_data]?{
        didSet {
            guard let _ = amData else{ print("📍Am_data == nil"); return }
//            currentTimeArray = amData
            amBtnClicked()
            currentarrayTitle = "am"
        }
    }
    var pmData : [AmPm_data]?{
        didSet {
            guard let _ = pmData else{ print("📍Pm_data == nil"); return }
            currentarrayTitle = "pm"
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
        print("thats the index : \(sender.tag)")
        self.loadingActivity.startAnimating()
        self.isUserInteractionEnabled = false
        guard let data = currentTimeArray , sender.tag <= data.count  else { return  }
       let id = data[sender.tag].id
         let isConfirmed = data[sender.tag].confirmedBool
        guard id != 0 else {
            print("❌fatal error id equal 0 selectedCell(_ sender : UIButton)" ) ;  return }
        if isConfirmed {
            reservationModel.postAttendanceRequest(id: id, completed: {[weak self] (sms, state) in
                guard state else {
                    self?.loadingActivity.stopAnimating()
                    self?.isUserInteractionEnabled = true
                    ad.showAlert("defaultTitle", sms) ;print("Attendance request has failed❗️"); return }
                self?.currentTimeArray?.remove(at: sender.tag)
                if self?.currentarrayTitle == "am" {
                    print("tag : \(sender.tag) am count before : \(self?.amData?.count)")
                    self?.amData?.remove(at: sender.tag)
                    print("tag : \(sender.tag) am count after : \(self?.amData?.count)")
                }else {
                    print("tag : \(sender.tag) pmData count before : \(self?.pmData?.count)")
                    self?.pmData?.remove(at: sender.tag)
                    print("tag : \(sender.tag)  pmData count after : \(self?.pmData?.count)")
                }
                self?.loadingActivity.stopAnimating()
                self?.isUserInteractionEnabled = true
                ad.showAlert("√", "")
                
            })
        }else {
            guard let data = currentTimeArray , sender.tag <= data.count  else { return  }

            reservationModel.postConfirmRequest(id: id) { [weak self] (sms, state) in
                guard state else {
                    self?.loadingActivity.stopAnimating()
                    self?.isUserInteractionEnabled = true
                    ad.showAlert("defaultTitle", sms) ;print("confirm request has failed❗️"); return }
                
                if self?.currentarrayTitle == "am" {
                    print("state : \(self?.currentarrayTitle) amData before confirmed : \(self?.amData?[sender.tag]._confirmed )")
                    self?.amData?[sender.tag]._confirmed = 1
                    print("state : \(self?.currentarrayTitle)  amData after confirmed : \(self?.amData?[sender.tag]._confirmed )")
                    self?.currentTimeArray = self?.amData
                }else {
                    print("state : \(self?.currentarrayTitle) tag before confirmed : \( sender.tag ) pmData count after : \(self?.pmData?.count)")

                    print("state : \(self?.currentarrayTitle) pmData before confirmed : \(self?.pmData?[sender.tag]._confirmed ) ")
                    self?.pmData?[sender.tag]._confirmed = 1
                      self?.currentTimeArray = self?.pmData
                    print("state : \(self?.currentarrayTitle) pmData after confirmed : \(self?.pmData?[sender.tag]._confirmed )")
                }
//                self?.tableView.reloadRows(at: [[0,sender.tag]], with: UITableViewRowAnimation.automatic )
//                self?.tableView.reloadData()
//                let indexPath = IndexPath(item: sender.tag, section: 0)
//                self?.tableView.reloadRows(at: [indexPath], with: .top)
                
                self?.loadingActivity.stopAnimating()
                self?.isUserInteractionEnabled = true
                ad.showAlert("√", "")

        }
 
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
