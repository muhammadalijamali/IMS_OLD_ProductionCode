//
//  MultiTableViewCell.swift
//  ADTourism
//
//  Created by Muhammad Ali on 8/17/17.
//  Copyright © 2017 Muhammad Ali. All rights reserved.
//

import UIKit

class MultiTableViewCell: UITableViewCell {

    @IBOutlet weak var deleteImagelbl: UILabel!
    @IBOutlet weak var deleteImageBtn: UIButton!
    @IBOutlet weak var capturelbl: UILabel!
    @IBOutlet weak var captureImageBtn: UIButton!
    @IBOutlet weak var imagenolbl: UILabel!
    @IBOutlet weak var capturedImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
