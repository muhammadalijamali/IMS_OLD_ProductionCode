//
//  ZoneTableViewCell.swift
//  ADTourism
//
//  Created by MACBOOK on 11/26/17.
//  Copyright © 2017 Muhammad Ali. All rights reserved.
//

import UIKit

class ZoneTableViewCell: UITableViewCell {

    @IBOutlet weak var dueDateVal: UILabel!
    @IBOutlet weak var dueDateLbl: UILabel!
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var startBtn: UIButton!
    @IBOutlet weak var onMywayBtn: UIButton!
    @IBOutlet weak var zoneNameBtn: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
