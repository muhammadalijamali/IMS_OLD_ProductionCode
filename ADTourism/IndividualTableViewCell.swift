//
//  IndividualTableViewCell.swift
//  ADTourism
//
//  Created by Muhammad Ali on 3/22/17.
//  Copyright © 2017 Muhammad Ali. All rights reserved.
//

import UIKit

class IndividualTableViewCell: UITableViewCell {

    @IBOutlet weak var emiratesIdValue: UILabel!
    @IBOutlet weak var emiratesIdLbl: UILabel!
    @IBOutlet weak var rtaLicenseValue: UILabel!
    @IBOutlet weak var rtaLicenselbl: UILabel!
    @IBOutlet weak var passportTitle: UILabel!
    @IBOutlet weak var passportValue: UILabel!
    @IBOutlet weak var individualArName: UILabel!
    @IBOutlet weak var invidualEngName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
