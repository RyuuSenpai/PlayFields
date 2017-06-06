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
        case 1 :
            if let data = self.confirmedP_G  {
                return data.count
            }
        case 2 :
            if let data = self.unconfirmedP_G  {
                return data.count
            }
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
        switch self.buttonTag {
        case 0:
            cell.cellState(0)
//            cell.tag = indexPath.row
          cell.bookNowBtn.setTitle("Book Now!", for: .normal)
          cell.bookNowBtn.removeTarget(nil, action: nil, for: .allEvents)
          cell.bookNowBtn.addTarget(self, action: #selector(self.bookNow(_:)), for: UIControlEvents.touchUpInside )

            guard let data = nearFieldsData else { return cell }
            cell.configNearFields(data[indexPath.row])
            cell.bookNowBtn.tag = indexPath.row
        case 1 :
            
            cell.cellState(1)
            cell.bookNowBtn.setTitle("Cancel Reservation", for: .normal)
            cell.bookNowBtn.removeTarget(nil, action: nil, for: .allEvents)
            cell.bookNowBtn.addTarget(self, action: #selector(self.cancelResrvation(_:)), for: UIControlEvents.touchUpInside )
            
            guard let data = confirmedP_G else { return cell }
            cell.configConfirmedFields(data[indexPath.row])
            cell.bookNowBtn.tag = indexPath.row
        case 2 :
//          
            cell.cellState(2)
            
            guard let data = unconfirmedP_G else { return cell }
            cell.configNotConfirmedFields(data[indexPath.row])
//
        default:
            cell.cellState(1)
            cell.bookNowBtn.setTitle("Cancel Reservation", for: .normal)
        }
        return cell
    }
    
    func cancelResrvation(_ sender: UIButton) {
        
        print("Cancel reservation plz my itcket number is : \(sender.tag)")
    }
    
    func bookNow(_ sender: UIButton) {
        
        setUpPlayGView(sender.tag)

    }
}
