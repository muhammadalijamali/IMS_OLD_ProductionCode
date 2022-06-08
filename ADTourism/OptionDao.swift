//
//  OptionDao.swift
//  ADTourism
//
//  Created by Administrator on 8/26/15.
//  Copyright (c) 2015 Muhammad Ali. All rights reserved.
//

import UIKit

class OptionDao: NSObject {
    var option_id : String!
    var question_id : String!
    var option_label : String!
    var option_type:String!
    var option_description:String!
    var is_required:String!
    var entry_Datetime:String!
    var violation_code : String! = ""
    var allExraOptions : NSMutableArray! = NSMutableArray()
    var is_selected : Int! = 0
    var warning_duration: String!
    
    
    
    
       
    
}
