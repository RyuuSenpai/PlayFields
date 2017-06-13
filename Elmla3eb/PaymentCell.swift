//
//  paymentCell.swift
//  Elmla3eb
//
//  Created by Macbook Pro on 6/13/17.
//  Copyright © 2017 Killvak. All rights reserved.
//

import UIKit

class PaymentCell: UITableViewCell {
    
    @IBOutlet weak var AddressLbl: UILabel!
    
    @IBOutlet weak var bookingNumLbl: UILabel!
    
    @IBOutlet weak var paymentLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    
    func configCell(_ data : PaymentStatics_Data) {
        
        self.AddressLbl.text = data.pgName
        self.bookingNumLbl.text = "\(data.pg_BookingNumbers)"
        self.paymentLbl.text = "\(data.payments)" + langDicClass().getLocalizedTitle(" SAR")
    }
    
}
