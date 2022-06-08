//
//  NotifDao.swift
//  ADTourism
//
//  Created by Muhammad Ali on 8/2/16.
//  Copyright © 2016 Muhammad Ali. All rights reserved.
//

import UIKit

class NotifDao: NSObject {
   /*
    "id": "392",
    "type": "task",
    "user_id": "370",
    "task_id": "933",
    "entry_datetime": "2016-08-02 11:54:19",
    "msg": "Damac Star Properties LLC inspection task has been assigned to you.",
    "msg_ar": "   تم تعيينك لمهمة تفتيش داماك ستار العقارية  ش ذ م م",
 */
    
    var notif_id : String?
    var type : String?
    var user_id : String?
    var msg : String?
    var msg_ar : String?
    var incidentDao : IncidentDao?
    
    
    
 }
