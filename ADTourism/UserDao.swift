//
//  UserDao.swift
//  ADTourism
//
//  Created by Administrator on 8/22/15.
//  Copyright (c) 2015 Muhammad Ali. All rights reserved.
//

import UIKit

class UserDao: NSObject {
    var response : String!
    var user_id : String!
    var firstname : String!
    var lastname : String!
    var contactno: String!
    var role_id : String!
    var username : String!
    var lat:Double!
    var lon:Double!
    var status : String! = "Active"
    var categories : String?
    var email : String?
    var job_title : String?
    var employee_id : String?
    var hosName : String?
    var hosMobileNo : String?
    var shift : String?
    var inactive_start : String?
    var inactive_end : String?
    var inactive_notes : String?
    var configDao : ConfigurationDao?
    var configArray : NSMutableArray = NSMutableArray()
    var task_radius : String?
    
    
    
    var permissions : NSMutableArray? = NSMutableArray()
    
    
    
    
}
