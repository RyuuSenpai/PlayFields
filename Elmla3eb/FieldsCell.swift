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
    
}
