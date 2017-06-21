//
//  OwnerPlaygroundsVC.swift
//  Elmla3eb
//
//  Created by Macbook Pro on 6/13/17.
//  Copyright © 2017 Killvak. All rights reserved.
//

import UIKit

extension OwnerPlaygroundsVC : UITableViewDataSource {
    
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if buttonTag == 0 {//Playgrounds
            if ownerPlaygrounds.count < 1 {
//                noplaygLbl.text =  langDicClass().getLocalizedTitle("No Data Found")
                noplaygLbl.alpha = 1
                return 0
            }
             noplaygLbl.alpha = 0
            return ownerPlaygrounds.count
        }else {//paymentStatics
            if ownerpaymentData.count < 1 {
//                noplaygLbl.text =  langDicClass().getLocalizedTitle("No Data Found")
                noplaygLbl.alpha = 1
                return 0
            }
            noplaygLbl.alpha = 0
            return ownerpaymentData.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if buttonTag == 0 {//PlayGrounds
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! FieldsCell
            cell.cellState(0)
            cell.configNearFields(ownerPlaygrounds[indexPath.row],true)

            
            cell.bookNowBtn.removeTarget(nil, action: nil, for: .allEvents)
            cell.bookNowBtn.addTarget(self, action: #selector(self.bookNow(_:)), for: UIControlEvents.touchUpInside )
            cell.bookNowBtn.tag = ownerPlaygrounds[indexPath.row].id
            return cell
        }else {//paymentStatics
            let cell = tableView.dequeueReusableCell(withIdentifier: "PaymentCell", for: indexPath) as! PaymentCell
            cell.configCell(ownerpaymentData[indexPath.row])
            return cell
        }
        
    }
    
    
        func bookNow(_ sender: UIButton) {
    //        guard let data = nearFieldsData else { return  }
    //        guard sender.tag <= data.count else { return }
    //        setUpPlayGView(data[sender.tag].id, data[sender.tag].pgName)
            
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "ViewPlayFeildVC" ) as! ViewPlayFeildVC
            
            vc.isOwnerEditing = true
            vc.pg_id = sender.tag
            
            self.navigationController?.pushViewController(vc, animated: true)
    //        
        }
}
