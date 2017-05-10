//
//  MirroringLabel.swift
//  Localization102
//
//  Created by Moath_Othman on 3/6/16.
//  Copyright © 2016 Moath_Othman. All rights reserved.
//

import UIKit

class MirroringLabel: UILabel {
    override func layoutSubviews() {
        if self.tag < 0 {
            if UIApplication.isRTL()  {
                if self.textAlignment == .right {
                    return
                }
            } else {
                if self.textAlignment == .left {
                    return
                }
            }
        }
        if self.tag < 0 {
            if UIApplication.isRTL()  {
                self.textAlignment = .right
            } else {
                self.textAlignment = .left
            }
        }
    }

}

//extension UIAlertController {
//    
//    func changeAlignment(view:UIView) {
//        for item in view.subviews {
//            if item.isKind(of: UICollectionView.self) {
//                let col = item as! UICollectionView
//                for  row in col.subviews{
//                    changeAlignment(view: row)
//                }
//            }
//            if item.isKind(of: UILabel.self) {
//                let label = item as! UILabel
//                label.tag = 50
//            }else {
//                changeAlignment(view: item)
//            }
//         }
//    }
//    open override func viewWillLayoutSubviews() {
//        super.viewWillLayoutSubviews()
//        changeAlignment(view: self.view)
//    }
//}
