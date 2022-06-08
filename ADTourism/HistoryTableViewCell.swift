//
//  HistoryTableViewCell.swift
//  ADTourism
//
//  Created by Administrator on 9/22/15.
//  Copyright (c) 2015 Muhammad Ali. All rights reserved.
//

import UIKit

class HistoryTableViewCell: UITableViewCell {

    @IBOutlet weak var notesBtn: ADButton!
    @IBOutlet weak var inspectiondateValue: UILabel!
    @IBOutlet weak var inspection_date: UILabel!
    
    @IBOutlet weak var editBtn: ADButton!
    @IBOutlet weak var permitIdBtn: UIButton!
    @IBOutlet weak var categoryValue: UILabel!
    @IBOutlet weak var categoryTitlelbl: UILabel!
    @IBOutlet weak var flagImage: UIImageView!
    @IBOutlet weak var colorIndicator: UIView!
    @IBOutlet weak var viewdetailBtn: UIButton!
    @IBOutlet weak var taskno: UILabel!
    @IBOutlet weak var task: UILabel!
    @IBOutlet weak var company: UIButton!
    @IBOutlet weak var completiondate: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
