//
//  MyChatTableViewCell.swift
//  ADTourism
//
//  Created by Muhammad Ali on 11/1/16.
//  Copyright © 2016 Muhammad Ali. All rights reserved.
//

import UIKit

class MyChatTableViewCell: UITableViewCell {

    @IBOutlet weak var yourDatetimelbl: UILabel!
    @IBOutlet weak var mydateTimelbl: UILabel!
    @IBOutlet weak var yourchatlbl: UILabel!
    @IBOutlet weak var mychatlbl: UILabel!
    @IBOutlet weak var coloredBackground: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
