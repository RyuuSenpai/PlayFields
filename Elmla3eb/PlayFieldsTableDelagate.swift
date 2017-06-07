//
//  PlayFieldsTableDelagate.swift
//  Elmla3eb
//
//  Created by Macbook Pro on 3/23/17.
//  Copyright © 2017 Killvak. All rights reserved.
//

import Foundation
import UIKit

extension PlayFieldsVC : UITableViewDelegate {
    

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("that's indexPath \(indexPath.row)")
        switch self.buttonTag {
        case 0 :
            guard let data = nearFieldsData else {
                print("NearBy Fields fatal error: Index out of range ") ;     return    }
            guard indexPath.row <= data.count else {
                print("NearBy Fields fatal error: Index out of range ") ;     return     }
            print("that is the index : \(data.count) and index is : \(indexPath.row)")

      setUpPlayGView(data[indexPath.row].id,data[indexPath.row].pgName)
            case 1:
                guard let data = unconfirmedP_G else {
                    print("unconfirmedP_G Fields fatal error: Index out of range ") ;     return    }
                guard indexPath.row <= data.count else {
                    print("unconfirmedP_G Fields fatal error: Index out of range ") ;     return     }
                print("that is the unconfirmedP_G index : \(data.count) and index is : \(indexPath.row)")
                
                setUpPlayGView(data[indexPath.row].pg_id,data[indexPath.row].pg_name)
        case 2 :
            guard let data = confirmedP_G else {
                print("confirmedP_G Fields fatal error: Index out of range ") ;     return    }
            guard indexPath.row <= data.count else {
                print("confirmedP_G Fields fatal error: Index out of range ") ;     return     }
            print("that is the confirmedP_G index : \(data.count) and index is : \(indexPath.row)")
            
            setUpPlayGView(data[indexPath.row].pg_id,data[indexPath.row].pg_name)
        default :
            return
        }
    }
    
    
    func  setUpPlayGView(_ id : Int , _ name : String   ) {
        print("that is the index : \(index)")
      
       
        let detailVC = self.storyboard?.instantiateViewController(withIdentifier: "ViewPlayFeildVC") as! ViewPlayFeildVC
             detailVC.pg_id = id
        detailVC.title = name
       
        print("that is the field name : \(title)")
        self.navigationController?.pushViewController(detailVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return  147
    }
    
    func animateTableView() {
        
        let cells = tableView.visibleCells
//        let tableHeight = tableView.bounds.size.height
        let tableWidth = tableView.bounds.size.width

        for i in cells {
            let cell = i as UITableViewCell
            cell.transform = CGAffineTransform(translationX: tableWidth * 3, y: 0)
        }
        var index = 0
        
        for a in cells {
            let cell = a as UITableViewCell
            UIView.animate(withDuration: 1.5, delay: 0.05 * Double(index), usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: [.curveEaseOut], animations: {
                cell.transform = .identity
            })
            index += 1
        }
    }
  
}
