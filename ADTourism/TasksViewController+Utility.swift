//
//  TasksViewController+Utility.swift
//  ADTourism
//
//  Created by Muhammad Ali on 8/28/18.
//  Copyright © 2018 Muhammad Ali. All rights reserved.
//

import Foundation
extension TasksViewController {
    
    func saveTasksToDatabase(json_string : String,task_id : String,unique_id : String, type : Int){
        
        /// type 1 offline , 0 online
        
        
        
        var taskResult = TaskResultsDao()
        taskResult.json_string = json_string
        taskResult.task_id = task_id
        taskResult.type = type
        taskResult.unique_id = unique_id
        let format = DateFormatter()
        format.dateFormat = "MM-dd-yyyy HH:mm:ss"
        taskResult.entry_datetime = format.string(from: Date())
         taskResult.date = NSDate().format()
        self.databaseManager.addOfflineTaskStatus(_offline: taskResult)
        
    }
}
