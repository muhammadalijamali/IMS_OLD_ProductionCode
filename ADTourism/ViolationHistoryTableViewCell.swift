//
//  ViolationHistoryTableViewCell.swift
//  ADTourism
//
//  Created by Muhammad Ali on 2/15/16.
//  Copyright © 2016 Muhammad Ali. All rights reserved.
//

import UIKit

class ViolationHistoryTableViewCell: UITableViewCell {

//    @IBOutlet weak var violation_date: UILabel!
//    @IBOutlet weak var violation_amount: UILabel!
//    @IBOutlet weak var violation_title: UILabel!
//    
    @IBOutlet weak var notesbtn: UIButton!
    @IBOutlet weak var paymentstatusvalue: UILabel!
    @IBOutlet weak var paymentStatuslbl: UILabel!
    @IBOutlet weak var hosstatusvalue: UILabel!
    @IBOutlet weak var hosstatuslbl: UILabel!
    @IBOutlet weak var violation_date: UILabel!
    @IBOutlet weak var violation_amount: UILabel!
    @IBOutlet weak var violation_title: UILabel!

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
