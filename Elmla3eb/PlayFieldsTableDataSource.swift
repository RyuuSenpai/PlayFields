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
        return 5
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
        cell.tag = indexPath.row
        cell.bookNowBtn.tag = cell.tag
        switch self.buttonTag {
        case 0:
//          cell.bookedFieldsstackView.alpha = 0
//            cell.nearbyStackView.alpha = 1
//            cell.bookingStateView.alpha = 0
//          cell.bookNowBtn.alpha = 1
            cell.cellState(0)
          cell.bookNowBtn.setTitle("Book Now!", for: .normal)
          cell.bookNowBtn.removeTarget(nil, action: nil, for: .allEvents)
          cell.bookNowBtn.addTarget(self, action: #selector(self.bookNow(_:)), for: UIControlEvents.touchUpInside )
        case 1 :
//            cell.bookedFieldsstackView.alpha = 1
//            cell.nearbyStackView.alpha = 0
//            cell.bookingStateView.alpha = 0
//            cell.bookNowBtn.alpha = 1
            cell.cellState(1)
            cell.bookNowBtn.setTitle("Cancel Reservation", for: .normal)
            cell.bookNowBtn.removeTarget(nil, action: nil, for: .allEvents)
            cell.bookNowBtn.addTarget(self, action: #selector(self.cancelResrvation(_:)), for: UIControlEvents.touchUpInside )
        case 2 :
//            cell.bookedFieldsstackView.alpha = 1
//            cell.nearbyStackView.alpha = 0
//            cell.bookingStateView.alpha = 1
//            cell.bookNowBtn.alpha = 0
            cell.cellState(2)
        default:
//            cell.bookedFieldsstackView.alpha = 1
//            cell.nearbyStackView.alpha = 0
//            cell.bookingStateView.alpha = 0
//            cell.bookNowBtn.alpha = 1
            cell.cellState(1)
            cell.bookNowBtn.setTitle("Cancel Reservation", for: .normal)
        }
        return cell
    }
    
    func cancelResrvation(_ sender: UIButton) {
        
        print("Cancel reservation plz my itcket number is : \(sender.tag)")
    }
    
    func bookNow(_ sender: UIButton) {
        
        print("can i book an reservation plz , my id is : \(sender.tag)")
    }
}
