//
//  TaskDao.swift
//  ADTourism
//
//  Created by Administrator on 8/22/15.
//  Copyright (c) 2015 Muhammad Ali. All rights reserved.
//

import UIKit

class TaskDao: NSObject {
   

    var list_title : String!
    var list_id : String!
    var task_id : String!
    
    var task_name: String!
    var due_date: String!
    var group_name:String!
    var company_name:String!
    var company_name_ar : String?
    
    var task_status : String!
    var total_earned_points:String!
    var total_task_points:String!
    var response : String?
    var company:CompanyDao!
    var creator : String?
    var auditor_Id : String? = ""
    var auditor_name : String? = ""
    var priority : String?
    var task_notes : String?
    var task_type : String?
    var task_type_ar : String?
    var additiona_email : String?
    var external_notes : String?
    
    var ins_type_name : String?
    var ins_type_name_arb : String?
    var inspection_type : String?
    var waiting_for_audit : String?
    var parent_task_id : String?
    var message : String?
    var notif_id : String?
    var notif_type : String?
    
    var msg_ar:String?
    var incidentDao : IncidentMediaDao?
    var incidentMediaArray : NSMutableArray = NSMutableArray()
    
    var company_lat : String?
    var company_lon : String?
    var totalRecords : String?
    var is_pool : String?
    var category_id : String?
    var license_no : String?
    var permitDao : PermitDao?
    var company_id : String?
    var isSubVenue : String?
    var subVenueName : String?
    var area_id : String?
    var areaName : String?
    var areaNameAr : String?

   
    var zone_id : String?
    var zone_name : String?
    var zone_name_ar : String?
    
    var zone_startDate : String?
    var zone_expiryDate : String?
    var isZoneTask : Int =  0 // 0 means not a zone tasks // 1 means its zone task 
    var zoneStatus : String?
    var parent_zone_status : String?
    
    var uniqueid : String?
    var is_submitted : String?
    var coninspectors : String = ""
    var taskOwner : String?
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}
