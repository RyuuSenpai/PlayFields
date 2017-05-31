//
//  FieldsCell.swift
//  Elmla3eb
//
//  Created by Macbook Pro on 3/22/17.
//  Copyright © 2017 Killvak. All rights reserved.
//

import UIKit
import AlamofireImage
import Alamofire

class FieldsCell: UITableViewCell {

    
    @IBOutlet weak var bookingStateView: UIView!
    @IBOutlet weak var nearbyStackView: UIStackView!
    @IBOutlet weak var bookNowBtn: UIButton!
    @IBOutlet weak var bookedFieldsstackView: UIStackView!
    @IBOutlet weak var bookingTimesAndRate: UILabel!
    
    @IBOutlet weak var courtImage: UIImageViewX!
    @IBOutlet weak var timeLbl: UILabel!
    @IBOutlet weak var bookingtimesLbl: UILabel!
    @IBOutlet weak var priceLbl: UILabel!
    @IBOutlet weak var fieldNameLbl: UILabel!
    @IBOutlet weak var calnderDateLbl: UILabel!
    @IBOutlet weak var fieldLocationLbl: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configCell(_ data : Search_Data?) {
//                    _ location : String?,_ price : String?,_ bookingTimes : String?,_ date : String?) {
        self.bookingTimesAndRate.text = langDicClass().getLocalizedTitle("Total Rate :")
        if let data = data   {
            fieldLocationLbl.text = data.address
            priceLbl.text = data.price + " " + langDicClass().getLocalizedTitle("per Hour")
            fieldNameLbl.text = data.pg_name
            bookingtimesLbl.text =   "\(data.rating)"
            if let url = URL(string: data.image) {
            courtImage.af_setImage(
                withURL: url ,
                placeholderImage: UIImage(named: "courtplaceholder_3x"),
                filter: nil,
                imageTransition: .crossDissolve(0.2)
            )
            }
        }
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
