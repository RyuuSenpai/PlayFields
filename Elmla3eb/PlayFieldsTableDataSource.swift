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
        switch buttonTag {
        case 0:
            if let data = nearFieldsData  {
                return data.count
            }
        case 1 : return 0
        case 2 : return 0
        default:
            return 0
        }
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
         cell.bookNowBtn.tag = indexPath.row
        switch self.buttonTag {
        case 0:
            
            cell.cellState(0)
          cell.bookNowBtn.setTitle("Book Now!", for: .normal)
          cell.bookNowBtn.removeTarget(nil, action: nil, for: .allEvents)
          cell.bookNowBtn.addTarget(self, action: #selector(self.bookNow(_:)), for: UIControlEvents.touchUpInside )
            guard let data = nearFieldsData else { return cell }
            cell.configNearFields(data[indexPath.row])
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
             guard let data = nearFieldsData else { return }
            print("can i book an reservation plz , my id is : \(sender.tag)")
            
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            
            let detailVC = storyBoard.instantiateViewController(withIdentifier: "ViewPlayFeildVC") as! ViewPlayFeildVC
            detailVC.pg_id =  sender.tag
            print("that is the field name : \(title)")
            
            self.navigationController?.pushViewController(detailVC, animated: true)
         print("can i book an reservation plz , my id is : \(sender.tag)")
    }
}
