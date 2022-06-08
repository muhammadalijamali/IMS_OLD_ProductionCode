//
//  CheckBoxTableViewCell.swift
//  ADTourism
//
//  Created by Administrator on 8/28/15.
//  Copyright (c) 2015 Muhammad Ali. All rights reserved.
//

import UIKit

class CheckBoxTableViewCell: UITableViewCell {

    @IBOutlet weak var notesbtm: ADButton!
    @IBOutlet weak var micbtn: ADButton!
    @IBOutlet weak var camerabtn: ADButton!
    @IBOutlet weak var view4: UIView!
    @IBOutlet weak var title4: UILabel!
    @IBOutlet weak var check4: ADButton!
    @IBOutlet weak var view3: UIView!
    @IBOutlet weak var title3: UILabel!
    @IBOutlet weak var check3: ADButton!
    @IBOutlet weak var view2: UIView!
    @IBOutlet weak var title2: UILabel!
    @IBOutlet weak var check2: ADButton!
    @IBOutlet weak var title1: UILabel!
    @IBOutlet weak var check1: ADButton!
    @IBOutlet weak var view1: UIView!
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
