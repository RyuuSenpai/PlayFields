//
//  HPDelegate.swift
//  Elmla3eb
//
//  Created by Macbook Pro on 3/13/17.
//  Copyright © 2017 Killvak. All rights reserved.
//

import Foundation
import UIKit


extension MainPageVC : UICollectionViewDelegate , UICollectionViewDelegateFlowLayout {
 
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard collectionView != ratingCollectionView else {
            return }
        let id = self.playGroundData?[indexPath.row].id
//       performSegue(withIdentifier: "ToPlayField", sender: id)
        let detailVC = self.storyboard?.instantiateViewController(withIdentifier: "ViewPlayFeildVC") as! ViewPlayFeildVC
        detailVC.pg_id =  id
        if let title =  self.playGroundData?[indexPath.row].name {
            detailVC.pg_title = title
            print("that is the field name : \(title)")
        }

         self.navigationController?.pushViewController(detailVC, animated: true)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard collectionView != ratingCollectionView else {
//            let x =  collectionView.frame.height * 0.24
            
            return CGSize(width: 276, height: 274) // The size of one cell
        }
        let x =  collectionView.frame.height * 0.24
        
        return CGSize(width: x + 14, height: x) // The size of one cell
        
    }
    
    
    
    
    
}



