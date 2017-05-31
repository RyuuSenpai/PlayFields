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
        guard collectionView != ratingCollectionView else {
            guard let count = self.rateData?.count , count > 0  else { return 0 }

            return  count
          }
        guard let count = self.playGroundData?.count , count > 0  else { return 0 }
        return  count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard collectionView != ratingCollectionView else {
//            let cell = UICollectionViewCell()
//            cell.backgroundColor = .red
//            print("that's the rating view \(rateData[indexPath.row].pg_name) , \(indexPath.row)")
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier:  "ratingCell", for: indexPath) as! ratingCell
            guard let rateData = rateData else { return cell }
            cell.tag = indexPath.row
            cell.fieldName.text = rateData[indexPath.row].pg_name
            //        cell.skipBtn.tag = cell.tag
            cell.ratingStarsView.tag = indexPath.row
            cell.ratingStarsView.value = 3
            cell.ratingStarsView.addTarget(self, action: #selector(self.rateField(_:)), for: [.touchUpOutside,.touchUpInside])
            cell.skipBtn.addTarget(self, action: #selector(skipRating(_:)), for: .touchUpInside)
            return cell
         }
    
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
                withURL: URL(string: imageURL.IMAGES_URL  + data.image)!,
                placeholderImage: UIImage(named: "courtplaceholder_3x"),
                filter: nil,
                imageTransition: .crossDissolve(0.2)
            )

        }
         return cell
}

}
