//
//  AvgTitleTableViewCell.swift
//  ADTourism
//
//  Created by Muhammad Ali on 11/24/16.
//  Copyright © 2016 Muhammad Ali. All rights reserved.
//

import UIKit

class AvgTitleTableViewCell: UITableViewCell {

    @IBOutlet weak var averageTimelbl: UILabel!
    @IBOutlet weak var establishmentDate: UILabel!
    @IBOutlet weak var establishmentName: UILabel!
    @IBOutlet weak var titleBtn: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
