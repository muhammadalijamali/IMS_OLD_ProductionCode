//
//  DropDownTableViewCell.swift
//  ADTourism
//
//  Created by Administrator on 8/28/15.
//  Copyright (c) 2015 Muhammad Ali. All rights reserved.
//

import UIKit

class DropDownTableViewCell: UITableViewCell {

   
    @IBOutlet weak var cameraBtn: ADButton!
    @IBOutlet weak var micBtn: ADButton!
    @IBOutlet weak var notesBtn: ADButton!
    @IBOutlet weak var dropdownbtn: ADButton!
    @IBOutlet weak var dropDowntitle: UILabel!
    @IBOutlet weak var dropdownview: UIView!
    @IBOutlet weak var questiontitle: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
