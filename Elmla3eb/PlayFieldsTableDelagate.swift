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
    }

//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        print("that's indexPath \(indexPath.row)")
//        switch self.buttonTag {
//        case 0 : print(0)
//      setUpPlayGView(indexPath.row)
//            case 1: print(0)
//            case 2 : print(0)
//        default : print(0)
//        }
//    }
    
    
    func  setUpPlayGView(_ index : Int  ) {
        print("that is the index : \(index)")
        guard let data = nearFieldsData  else { return }
        print("that is the index : \(data.count)")
        guard index <= data.count else { print("NearBy Fields fatal error: Index out of range "); return }

        let detailVC = self.storyboard?.instantiateViewController(withIdentifier: "ViewPlayFeildVC") as! ViewPlayFeildVC
        detailVC.pg_id =  data[index].id
        detailVC.title = data[index].pgName
        print("that is the field name : \(title)")
        self.present(detailVC, animated: true, completion: nil)
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
