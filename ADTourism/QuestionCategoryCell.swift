//
//  QuestionCategoryCell.swift
//  ADTourism
//
//  Created by MACBOOK on 6/27/18.
//  Copyright © 2018 Muhammad Ali. All rights reserved.
//

import UIKit

class QuestionCategoryCell: UITableViewCell {
      
    @IBOutlet weak var category_title: UILabel!
    @IBOutlet weak var categoryIcon: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
