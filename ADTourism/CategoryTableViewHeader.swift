//
//  CollapsibleTableViewHeader.swift
//  ADTourism
//
//  Created by MACBOOK on 6/28/18.
//  Copyright © 2018 Muhammad Ali. All rights reserved.
//

import UIKit

class CategoryTableViewHeader: UITableViewHeaderFooterView {
   
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var categoryTitle: UILabel!
    var section : Int?
    var category : QuestionCategoryDao?
    
    
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
