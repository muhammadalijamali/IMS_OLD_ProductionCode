//
//  ChatUserCell.swift
//  ADTourism
//
//  Created by Muhammad Ali on 11/24/16.
//  Copyright © 2016 Muhammad Ali. All rights reserved.
//

import UIKit

class ChatUserCell: UITableViewCell {

    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var tickImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
