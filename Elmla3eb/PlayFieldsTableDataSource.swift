//
//  PlayFieldsTableDataSource.swift
//  
//
//  Created by Macbook Pro on 3/23/17.
//
//

import Foundation
import UIKit

extension PlayFieldsVC : UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.emptyDataLabel.alpha = 0
        switch buttonTag {
        case 0:
            if let data = nearFieldsData , data.count > 0 {
                return data.count
            }
        case 1 :
            if let data = self.unconfirmedP_G  , data.count > 0 {
                return data.count
            }
        case 2 :
            if let data = self.confirmedP_G  , data.count > 0 {
                return data.count
            }
        default:
            return 0
        }
        self.emptyDataLabel.alpha = 1
        return 0 
     }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = UITableViewCell()
//        cell.textLabel?.text = "like"
//        var cell = tableView.dequeueReusableCell(withIdentifier: "cell")! as UITableViewCell
//        if cell == nil {
//            tableView.register(UINib(nibName: "CustomCell", bundle: nil), forCellReuseIdentifier: "CustomCell")
//            cell = tableView.dequeueReusableCell(withIdentifier: "CustomCell") as UITableViewCell!
//        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! FieldsCell
//        cell.tag = indexPath.row
//        cell.bookNowBtn.tag = cell.tag
        cell.courtImage.image = UIImage(named: "courtplaceholder_3x")
        switch self.buttonTag {
        case 0:
            cell.cellState(0)
//            cell.tag = indexPath.row
          cell.bookNowBtn.setTitle("Book Now!", for: .normal)
          cell.bookNowBtn.removeTarget(nil, action: nil, for: .allEvents)
          cell.bookNowBtn.addTarget(self, action: #selector(self.bookNow(_:)), for: UIControlEvents.touchUpInside )

            guard let data = nearFieldsData else {print("⛑ Fatal Error the nearFieldsData count Equal 0 ❗️"); return cell }
            cell.configNearFields(data[indexPath.row])
            cell.bookNowBtn.tag = indexPath.row
        case 1 :
            
            cell.cellState(1)
            cell.bookNowBtn.setTitle("Cancel Reservation", for: .normal)
            cell.bookNowBtn.removeTarget(nil, action: nil, for: .allEvents)
            cell.bookNowBtn.addTarget(self, action: #selector(self.cancelResrvation(_:)), for: UIControlEvents.touchUpInside )
            
            guard let data = unconfirmedP_G , data.count >= indexPath.row else { print("⛑ Fatal Error the unconfirmedP_G count is Equal 0 ❗️");return cell }
            print("that is the unconfirmed data count : \(data.count) and that's the index \(indexPath.row)")
            cell.configNotConfirmedFields(data[indexPath.row])
            cell.bookNowBtn.tag = indexPath.row
        case 2 :
//          
            cell.cellState(2)
            
            guard let data = confirmedP_G , data.count >= indexPath.row else {print("⛑ Fatal Error the confirmedP_G count is Equal 0 ❗️"); return cell }
            cell.configConfirmedFields(data[indexPath.row])
//
        default:
//            cell.cellState(1)
//            cell.bookNowBtn.setTitle("Cancel Reservation", for: .normal)
            return cell 
        }
        return cell
    }
    
    func cancelResrvation(_ sender: UIButton) {
        
        print("Cancel reservation plz my itcket number is : \(sender.tag)\n and that's the count : \(unconfirmedP_G?.count)")
        guard let data = unconfirmedP_G else { return }
        guard sender.tag <= data.count else { return }
        let reservationId = data[sender.tag].id
        guard reservationId != 0 else { print("⛑ Fatal Error the id is Equal 0 ❗️") ;return }
        deletereservation.deleteReservation(reservation_id: reservationId) {[weak self] (sms, state) in
            
            guard state else {
                print(" ❗️ State is False ❗️")
                ad.showAlert("defaultTitle", sms)
                return
            }
//            if let index = selectedDates.index(of: xcz[sender.tag]) {
//                selectedDates.remove(at: index)
//            }
            
//            if let index = unconfirmedP_G.index(of: unconfirmedP_G?[sender.tag]) {
            DispatchQueue.main.async {
    
                
//                self?.unconfirmedP_G?.remove(at: sender.tag)
            if  let _ = self?.tableView.cellForRow(at: [0,sender.tag]) {
                


                DispatchQueue.main.async {

                    self?.unconfirmedP_G?.remove(at: sender.tag)
                }
                 }
            }
//
        }
    }
    
    func bookNow(_ sender: UIButton) {
        guard let data = nearFieldsData else { return  }
        guard sender.tag <= data.count else { return }
        setUpPlayGView(data[sender.tag].id, data[sender.tag].pgName)

    }
}
