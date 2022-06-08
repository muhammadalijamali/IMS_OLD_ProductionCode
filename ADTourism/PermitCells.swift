//
//  PermitCells.swift
//  ADTourism
//
//  Created by Muhammad Ali on 9/18/16.
//  Copyright © 2016 Muhammad Ali. All rights reserved.
//

import UIKit

class PermitCells: UITableViewCell {

    @IBOutlet weak var companyName: UIButton!
    @IBOutlet weak var createInspectionBtn: PermitBtn!
    @IBOutlet weak var expiryDateVal: UILabel!
    @IBOutlet weak var expiryDatelbl: UILabel!
    @IBOutlet weak var startDateVal: UILabel!
    @IBOutlet weak var startDatelbl: UILabel!
    @IBOutlet weak var permitTypeVal: UILabel!
    @IBOutlet weak var permitTylelbl: UILabel!
    @IBOutlet weak var permitNoVal: UILabel!
    @IBOutlet weak var permitNolbl: UILabel!
    @IBOutlet weak var licenseNoVal: UILabel!
    @IBOutlet weak var licenseNolbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
