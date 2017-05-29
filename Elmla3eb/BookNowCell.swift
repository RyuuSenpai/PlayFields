//
//  BookNowCell.swift
//  Elmla3eb
//
//  Created by Macbook Pro on 3/27/17.
//  Copyright © 2017 Killvak. All rights reserved.
//

import UIKit

class BookNowCell: UITableViewCell {

    @IBOutlet weak var label: UILabel!

    @IBOutlet weak var selectRow: UIButton!
    @IBOutlet weak var seperatorView: UIView!

    @IBOutlet weak var timeIDLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
