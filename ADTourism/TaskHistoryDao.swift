//
//  TaskHistoryDao.swift
//  ADTourism
//
//  Created by Administrator on 9/23/15.
//  Copyright (c) 2015 Muhammad Ali. All rights reserved.
//

import UIKit

class TaskHistoryDao: NSObject {
 
    var  id : String? = ""
    var  inspector_id : String? = ""
    var company_id : String? = ""
    var task_notes : String? = ""
    
    
    var list_id : String? = ""
    
    var task_name : String? = ""
    var  company_name : String? = ""
    var company_name_arabic : String? = ""
    
    
    var  list_title : String? = ""
    
    var due_date  : String? = ""
    var questions : NSMutableArray?
    var creator : String?
    var priority : String?
    var completed_date : String?
    var violations_count : String?
    var task_status : String?
    var visited_date : String?
    var  unfinished_note : String?
    var  unfinished_reason : String?
    var  total_count: Int = 0
    var permitDao : PermitDao?
    var driver_id : String?
    var driver_name : String?
    var driver_name_en : String?
    
    var passprot : String?
    var drivingLicenseNo : String?
    var emiratesID : String?
    var taskType : Int?
    var subVenueName : String?
    var inspection_type : String?
    var area_id : String?
    var area_name: String?
    var area_nameAr : String?
    var external_notes : String?
    var zone_id : String?
    var zone_name : String?
    var zone_name_ar : String?
    
    var zone_startDate : String?
    var zone_expiryDate : String?
    var isZoneTask : Int =  0 // 0 means not a zone tasks // 1 means its zone task
    var zoneStatus : String?
    var coInspectors : String?
    var taskOwnerID : String?
    
    
    
    
    
    
    
    
    
    
    
    
}
