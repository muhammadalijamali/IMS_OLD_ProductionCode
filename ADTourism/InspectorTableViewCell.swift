//
//  InspectorTableViewCell.swift
//  ADTourism
//
//  Created by Muhammad Ali on 5/4/16.
//  Copyright © 2016 Muhammad Ali. All rights reserved.
//

import UIKit

class InspectorTableViewCell: UITableViewCell {

    @IBOutlet weak var inspectorNameLbl: UILabel!
    @IBOutlet weak var tickBtn: InspectorBtn!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
