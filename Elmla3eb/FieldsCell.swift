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
    
    func configNearFields(_ data :NearByFields_Data? ,_ isOwner : Bool ) { // address, price, bookingTimes
        guard let data = data else { return }
            bookNowBtn.tag = data.id
            
            fieldLocationLbl.text = data.address
            priceLbl.text = data.price + " " + langDicClass().getLocalizedTitle("per Hour")
            fieldNameLbl.text = data.pgName
            bookingtimesLbl.text =   "\(data.pgBookingTimes)"
            if let url = URL(string: data.image) {
                courtImage.af_setImage(
                    withURL: url ,
                    placeholderImage: UIImage(named: "courtplaceholder_3x"),
                    filter: nil,
                    imageTransition: .crossDissolve(0.2)
                )
            }else {
                courtImage.image = UIImage(named: "courtplaceholder_3x")
        }
        if isOwner {
            bookNowBtn.setTitle(langDicClass().getLocalizedTitle("Edit Field"), for: .normal)
            bookNowBtn.alpha = 1

        }else {
            bookNowBtn.alpha = 0
        }
    }
    
    func configNotConfirmedFields(_ data :NotConfirmedFields_Data? ) {
        guard let data = data else { return }
//       
//        
//        
        fieldLocationLbl.text = data.address
//        priceLbl.text = data. + " " + langDicClass().getLocalizedTitle("per Hour")
        fieldNameLbl.text = data.pg_name
//        print("confirmed data : \(data.pg_name)")

        timeLbl.text =   "\(data.time)"
        calnderDateLbl.text = "\(data.date)"
        if let url = URL(string: data.image) {
            courtImage.af_setImage(
                withURL: url ,
                placeholderImage: UIImage(named: "courtplaceholder_3x"),
                filter: nil,
                imageTransition: .crossDissolve(0.2)
            )
        }
    }
    
    func configConfirmedFields(_ data :ConfirmedFields_Data? ) {
        guard let data = data else { return }
//        //
        fieldLocationLbl.text = data.address
//        priceLbl.text = data.price + " " + langDicClass().getLocalizedTitle("per Hour")
        fieldNameLbl.text = data.pg_name
//        print("confirmed data : \(data.time)")
//        bookingtimesLbl.text =   "\(data.pgBookingTimes)"
        timeLbl.text =   "\(data.time)"
        calnderDateLbl.text = "\(data.date)"
        if let url = URL(string: data.image) {
            courtImage.af_setImage(
                withURL: url ,
                placeholderImage: UIImage(named: "courtplaceholder_3x"),
                filter: nil,
                imageTransition: .crossDissolve(0.2)
            )
        }else {
            courtImage.image = UIImage(named: "courtplaceholder_3x")
        }
    }

    func configCell(_ data : Search_Data?) {
//                    _ location : String?,_ price : String?,_ bookingTimes : String?,_ date : String?) {
//        self.bookingTimesAndRate.text = langDicClass().getLocalizedTitle("Total Rate :")
        if let data = data   {
            bookNowBtn.tag = data.id
    
            fieldLocationLbl.text = data.address
            priceLbl.text = data.price + " " + langDicClass().getLocalizedTitle("per Hour")
            fieldNameLbl.text = data.pg_name
            bookingtimesLbl.text =   "\(data.pg_BookingNumbers)"
            if let url = URL(string: data.image) {
            courtImage.af_setImage(
                withURL: url ,
                placeholderImage: UIImage(named: "courtplaceholder_3x"),
                filter: nil,
                imageTransition: .crossDissolve(0.2)
            )
            }else {
                courtImage.image = UIImage(named: "courtplaceholder_3x")
            }
        }
        if let userType = UserDefaults.standard.value(forKey: "User_Type") as? String  , userType == "pg_owner" {
            bookNowBtn.alpha = 0
            
        }else {
            bookNowBtn.alpha = 1
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
//            print("error with Cell State Setter")
            bookedFieldsstackView.alpha = 0
            nearbyStackView.alpha = 1
            bookingStateView.alpha = 0
            bookNowBtn.alpha = 1
            
        }
    }
    
}
