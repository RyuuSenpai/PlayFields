//
//  OwnerPlaygroundsVC.swift
//  Elmla3eb
//
//  Created by Macbook Pro on 6/13/17.
//  Copyright © 2017 Killvak. All rights reserved.
//

import UIKit

extension OwnerPlaygroundsVC : UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
//        print("selected row ; \(indexPath.row)")
        
        if buttonTag == 0 {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "BookedFieldsDatesVC") as! BookedFieldsDatesVC
            vc.pg_id =  ownerPlaygrounds[indexPath.row].id
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
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
