
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
    
    var hideAmPmBtns : Bool? {
        didSet {
        if let x = hideAmPmBtns {
            amBtn?.isHidden = x
            pmBtn?.isHidden = x 
        }
        }
    }
//    @IBOutlet weak var secondViewHeight: NSLayoutConstraint!
    
    var  xcz = [ 1 , 2 ,3 ,4 ,5 ]
    
    var am = [ 1 , 2 ,3 ,4 ,5 ,6 ,1,12,14,32,432,2134,124,2143,2134,2134,21,2413,2413,421,124]
    var pm = [ 11 , 12 ,13 ]
    var amSelectedCelles = [Int]()
    var pmSelectedCelles = [Int]()
    
    var resetCellBtn = false
    var isAM = true
    var selectedDates = [Int]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        tableView.delegate = self
        tableView.dataSource = self
        amBtn.addTarget(self, action: #selector(self.amBtnClicked), for: .touchUpInside )
        pmBtn.addTarget(self, action: #selector(self.pmBtnClicked), for: .touchUpInside )
        
        xcz = am
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("that is the row : \(indexPath.row)")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return xcz.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BookNowCell", for: indexPath) as! BookNowCell
        cell.label.text = " from \(xcz[indexPath.row]) to œ "
        cell.tag = indexPath.row
        cell.selectRow.tag = cell.tag
        cell.selectRow.isSelected = false
        
        //        if resetCellBtn {
        //            cell.selectRow.isSelected = false
        //            resetCellBtn = false
        //        }
        
        var tagsArray = [Int]()
        if isAM { tagsArray = amSelectedCelles } else  { tagsArray = pmSelectedCelles }
        if tagsArray.count > 0 {
            for x in tagsArray {
                if indexPath.row == x {
                    cell.selectRow.isSelected = true
                }
            }
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
        sender.isSelected = !sender.isSelected
        if sender.isSelected {
             sender.isHidden = true
            if isAM {
                self.amSelectedCelles.append(sender.tag)
            }else {
                self.pmSelectedCelles.append(sender.tag)
            }
            selectedDates.append(xcz[sender.tag])
            
        }else {
             if let index = selectedDates.index(of: xcz[sender.tag]) {
                selectedDates.remove(at: index)
            }
            
        }
        print("that is the current array : \(selectedDates)")
    }
    
    
    func amBtnClicked() {
        resetCellBtn = true
        self.xcz = am
        isAM = true
        tableView.reloadData()
        self.pmBtn.backgroundColor = Constants.Colors.gray
        
        self.amBtn.backgroundColor = Constants.Colors.green
    }
    
    func pmBtnClicked() {
        resetCellBtn = true
        isAM = false
        self.xcz = pm
        tableView.reloadData()
        self.pmBtn.backgroundColor = Constants.Colors.green
        
        self.amBtn.backgroundColor = Constants.Colors.gray
        
    }
}
