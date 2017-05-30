//
//  FieldsCell.swift
//  Elmla3eb
//
//  Created by Macbook Pro on 3/22/17.
//  Copyright © 2017 Killvak. All rights reserved.
//

import UIKit

class FieldsCell: UITableViewCell {

    @IBOutlet weak var timeLbl: UILabel!
    @IBOutlet weak var bookingtimesLbl: UILabel!
    @IBOutlet weak var priceLbl: UILabel!
    @IBOutlet weak var bookingStateView: UIView!
    @IBOutlet weak var calnderDateLbl: UILabel!
    @IBOutlet weak var fieldLocationLbl: UILabel!
    @IBOutlet weak var nearbyStackView: UIStackView!
    @IBOutlet weak var fieldNameLbl: UILabel!
    @IBOutlet weak var bookNowBtn: UIButton!
    @IBOutlet weak var bookedFieldsstackView: UIStackView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func cellState(_ state : Int) {
        
        switch state {
        case 0://NearBy:Location,price,Bookingtimes,BookNow
            bookedFieldsstackView.alpha = 0
            nearbyStackView.alpha = 1
            bookingStateView.alpha = 0
            bookNowBtn.alpha = 1
        case 1 ://UnConfirmed:Location,Date,Time,Cancel Reservation
            bookedFieldsstackView.alpha = 1
            nearbyStackView.alpha = 0
            bookingStateView.alpha = 0
            bookNowBtn.alpha = 1
        case 2 ://Confirmed:Location,Date,Time,Confirmed
            bookedFieldsstackView.alpha = 1
            nearbyStackView.alpha = 0
            bookingStateView.alpha = 1
            bookNowBtn.alpha = 0
        default :
            print("error with Cell State Setter")
            bookedFieldsstackView.alpha = 0
            nearbyStackView.alpha = 1
            bookingStateView.alpha = 0
            bookNowBtn.alpha = 1
            
        }
    }
    
}
