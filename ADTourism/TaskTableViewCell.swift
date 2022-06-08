//
//  TaskTableViewCell.swift
//  ADTourism
//
//  Created by Administrator on 8/22/15.
//  Copyright (c) 2015 Muhammad Ali. All rights reserved.
//

import UIKit

class TaskTableViewCell: UITableViewCell {

    @IBOutlet weak var taskradio: InspectionRadio!
    @IBOutlet weak var locIcon: ADButton!
    @IBOutlet weak var permitNobtn: UIButton!
    @IBOutlet weak var subVenuelbl: UILabel!
    @IBOutlet weak var categoryValue: UILabel!
    @IBOutlet weak var categoryTitle: UILabel!
    @IBOutlet weak var taskstatuslabel: UILabel!
    @IBOutlet weak var tasktypelabel: UILabel!
    @IBOutlet weak var dueDatelabel: UILabel!
    @IBOutlet weak var priorityIndicator: UIView!
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var notesTitleLbl: UILabel!
    @IBOutlet weak var notesBtn: ADButton!
    @IBOutlet weak var prioritylbl: UILabel!
    @IBOutlet weak var onMyWayBtn: UIButton!
    @IBOutlet weak var startBtn: UIButton!
    @IBOutlet weak var tasktypelbl: UILabel!
    @IBOutlet weak var dueDate: UILabel!
    @IBOutlet weak var group: UILabel!
    @IBOutlet weak var company: UIButton!
    @IBOutlet weak var tasksName: UILabel!
    @IBOutlet weak var tasksNo: UILabel!
    
    @IBOutlet weak var editCoInspection: ADButton!
    
    @IBOutlet weak var incidentBtn: ADButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
