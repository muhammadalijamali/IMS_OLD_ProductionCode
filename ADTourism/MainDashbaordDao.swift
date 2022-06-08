//
//  MainDashbaordDao.swift
//  ADTourism
//
//  Created by Muhammad Ali on 11/20/16.
//  Copyright © 2016 Muhammad Ali. All rights reserved.
//

import UIKit

class MainDashbaordDao: NSObject {
    var dashbaordTask : DashbaordTask?
    var categories : NSMutableArray?
    var dashbaordHours : DashbaordHours?
    var avg_time : DashbaordAverageTime?
    var avg_active_inactiveTime : DashbaordAverageActiveInActive?
    var avg_daily_active_inactiveArray : NSMutableArray = NSMutableArray()
    
    var task_report : DashbaordTask_Report?
    var task_report_array = NSMutableArray()
    var total_average_activeInActvie : DashbaordAverageActiveInActive?
    

}
