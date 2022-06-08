//
//  SearchTableViewCell.swift
//  ADTourism
//
//  Created by Administrator on 2/1/16.
//  Copyright © 2016 Muhammad Ali. All rights reserved.
//

import UIKit

class SearchTableViewCell: UITableViewCell {

    @IBOutlet weak var licensenolbl: UILabel!
    @IBOutlet weak var company_name_ar: UILabel!
    @IBOutlet weak var licenseNumberLbl: UILabel!
    @IBOutlet weak var companyNameLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
