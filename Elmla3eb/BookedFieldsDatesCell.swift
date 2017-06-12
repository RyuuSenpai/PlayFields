
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

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var secondView: UIView!
    
    
    
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
//    @IBOutlet weak var secondViewHeight: NSLayoutConstraint!
    
//    var  xcz = [ 1 , 2 ,3 ,4 ,5 ]
    var notBooked : OwnerP_G_BookingData?{
        didSet {
            guard let data = notBooked else { print("📍notBooked_Data == nil");return }
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
            currentTimeArray = amData
        }
    }
    var pmData : [AmPm_data]?{
        didSet {
            guard let _ = pmData else{ print("📍Pm_data == nil"); return }
        }
    }
    
//    var am = [ 1 , 2 ,3 ,4 ,5 ,6 ,1,12,14,32,432,2134,124,2143,2134,2134,21,2413,2413,421,124]
//    var pm = [ 11 , 12 ,13 ]
//    var amSelectedCelles = [Int]()
//    var pmSelectedCelles = [Int]()
    
    var resetCellBtn = false
    var isAM = true
//    var selectedDates = [Int]()
    
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
        guard let count = currentTimeArray?.count else { return 0 }
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BookNowCell", for: indexPath) as! BookNowCell
        guard let data = currentTimeArray else { return cell }
        cell.label.text = data[indexPath.row].time
//        cell.tag = indexPath.row
        cell.selectRow.tag = 3
        cell.selectRow.isSelected = false
        
        //        if resetCellBtn {
        //            cell.selectRow.isSelected = false
        //            resetCellBtn = false
        //        }
        
//        var tagsArray = [Int]()
//        if isAM { tagsArray = amSelectedCelles } else  { tagsArray = pmSelectedCelles }
//        if tagsArray.count > 0 {
//            for x in tagsArray {
//                if indexPath.row == x {
//                    cell.selectRow.isSelected = true
//                }
//            }
//        }
        if data[indexPath.row].confirmedBool {
           cell.selectRow.setTitle("Attendance", for: .normal)
            cell.selectRow.tag = 1
        }else {
            cell.selectRow.setTitle("Confirm", for: .normal)
              cell.selectRow.tag = 0
        }
        
          cell.selectRow.addTarget(self, action: #selector(self.selectedCell(_:)), for: .touchUpInside)
        return cell
    }
    
//    var showsDetails = false {
//        didSet {
//            secondViewHeight.priority = showsDetails ? 250 : 999
//        }
//    }

    func selectedCell(_ sender : UIButton) {
//        sender.isSelected = !sender.isSelected
//        if sender.isSelected {
//             sender.isHidden = true
//            if isAM {
//                self.amSelectedCelles.append(sender.tag)
//            }else {
//                self.pmSelectedCelles.append(sender.tag)
//            }
//            selectedDates.append(xcz[sender.tag])
//            
//        }else {
//             if let index = selectedDates.index(of: xcz[sender.tag]) {
//                selectedDates.remove(at: index)
//            }
//            
//        }
//        print("that is the current array : \(selectedDates)")
        if sender.tag == 0 {
        reservationModel.postConfirmRequest(id: 550) { (sms, state) in
            
            guard state else { print("confirm request has failed❗️"); return }
            ad.showAlert("Done", "Success")
        }
        }else if sender.tag == 1 {
            
        }else {
            
        }
    }
    
    
    func amBtnClicked() {
        resetCellBtn = true
        self.currentTimeArray = amData
        isAM = true
        tableView.reloadData()
        self.pmBtn.backgroundColor = Constants.Colors.gray
        
        self.amBtn.backgroundColor = Constants.Colors.green
    }
    
    func pmBtnClicked() {
        resetCellBtn = true
        isAM = false
        self.currentTimeArray = pmData
        tableView.reloadData()
        self.pmBtn.backgroundColor = Constants.Colors.green
        
        self.amBtn.backgroundColor = Constants.Colors.gray
        
    }
}
