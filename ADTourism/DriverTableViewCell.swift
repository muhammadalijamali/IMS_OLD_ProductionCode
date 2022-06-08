//
//  DriverTableViewCell.swift
//  ADTourism
//
//  Created by Muhammad Ali on 1/30/17.
//  Copyright © 2017 Muhammad Ali. All rights reserved.
//

import UIKit

class DriverTableViewCell: UITableViewCell {

    @IBOutlet weak var licenseno: UILabel!
    @IBOutlet weak var noteslbl: UILabel!
    @IBOutlet weak var firstsaidlbl: UILabel!
    @IBOutlet weak var issueDatelbl: UILabel!
    @IBOutlet weak var expiryDate: UILabel!
    @IBOutlet weak var drivergenderlbl: UILabel!
    @IBOutlet weak var driverNamelbl: UILabel!
    @IBOutlet weak var checkItem: InspectorBtn!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
