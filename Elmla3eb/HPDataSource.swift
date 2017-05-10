//
//  HPDataSource.swift
//  Elmla3eb
//
//  Created by Macbook Pro on 3/13/17.
//  Copyright © 2017 Killvak. All rights reserved.
//

import Foundation
import UIKit


extension MainPageVC : UICollectionViewDataSource {
    
 
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let count = self.playGroundData?.count , count > 0  else { return 0 }
        return  count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
    
          let  cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! HomePageCell
        guard  let data = self.playGroundData?[indexPath.row] else { return cell }
        cell.title.text = data.name
        print("data name : \(data.name)")
        cell.subtitle.text = data.address
        
        if 0...5 ~=  data.rate {
            cell.starRatingView.value = CGFloat(data.rate)
        }else {
            cell.starRatingView.value = 0
        }
//
        cell.courtImage.image = UIImage(named: "courtplaceholder_3x")
        if data.image != "" {
            cell.courtImage.image = UIImage(named: "courtplaceholder_3x")
            
            
            cell.courtImage.af_setImage(
                withURL: URL(string: "http://appstest.xyz/" + data.image)!,
                placeholderImage: UIImage(named: "courtplaceholder_3x"),
                filter: nil,
                imageTransition: .crossDissolve(0.2)
            )

        }
         return cell
}

}
