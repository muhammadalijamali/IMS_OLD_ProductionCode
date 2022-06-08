//
//  QuestionDao.swift
//  ADTourism
//
//  Created by Administrator on 8/26/15.
//  Copyright (c) 2015 Muhammad Ali. All rights reserved.
//

import UIKit

class QuestionDao: NSObject {
    var response : String!
    var question_id : String!
    var task_id : String!
    
    var list_id : String!
    var question_desc : String!
    var question_desc_en : String?
    
    var entry_datetime : String!
    var allOptions:NSMutableArray!
    var media : NSMutableArray = NSMutableArray()
    var notes : String!
    var audio : String?
    var image : String?
    var list_name : String?
    var violation_count : String?
    var warning_count : String?
    var violation_code : String?
    var is_selected:NSNumber! = NSNumber(value: 0 as Int32)    
    var allImages : NSMutableArray = NSMutableArray()
    var catg_id : String?
    
  
}
