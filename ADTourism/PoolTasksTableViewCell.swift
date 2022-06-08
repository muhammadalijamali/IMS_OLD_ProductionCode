//
//  PoolTasksTableViewCell.swift
//  ADTourism
//
//  Created by Muhammad Ali on 6/9/16.
//  Copyright © 2016 Muhammad Ali. All rights reserved.
//

import UIKit

class PoolTasksTableViewCell: UITableViewCell {

    @IBOutlet weak var licenseNoValue: UILabel!
    @IBOutlet weak var licenseNolbl: UILabel!
    @IBOutlet weak var grabBtn: ADButton!
    @IBOutlet weak var taskNotesBtn: ADButton!
    @IBOutlet weak var priorityBar: UIView!
    @IBOutlet weak var taskTypeValue: UILabel!
    @IBOutlet weak var expiryDateValue: UILabel!
    @IBOutlet weak var taskTypeLbl: UILabel!
    @IBOutlet weak var expiryDatelbl: UILabel!
    @IBOutlet weak var priorityLbl: UILabel!
    @IBOutlet weak var companyNameBtn: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
