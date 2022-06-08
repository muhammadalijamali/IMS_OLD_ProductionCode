//
//  VehicleCell.swift
//  ADTourism
//
//  Created by Muhammad Ali on 1/30/17.
//  Copyright © 2017 Muhammad Ali. All rights reserved.
//

import UIKit

class VehicleCell: UITableViewCell {

    @IBOutlet weak var checkItem: InspectorBtn!
    @IBOutlet weak var modelYearlbl: UILabel!
    @IBOutlet weak var noteslbl: UILabel!
    @IBOutlet weak var expiryDatelbl: UILabel!
    @IBOutlet weak var issueDatelbl: UILabel!
    @IBOutlet weak var typelbl: UILabel!
    @IBOutlet weak var vehicleNumber: UILabel!
    @IBOutlet weak var ownerName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
