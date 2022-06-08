//
//  QuestionListViewController+Utility.swift
//  ADTourism
//
//  Created by MACBOOK on 6/28/18.
//  Copyright © 2018 Muhammad Ali. All rights reserved.
//

import Foundation

extension QuestionListViewController {
    
    func filterArrayByCategory(catd_id : String , questions : NSMutableArray) -> NSMutableArray{
      
        let array1 = questions as NSArray as? [QuestionDao]
          print("Total Questions \(array1?.count)")
        let array2 = array1?.filter({
            
            print("From Questions \($0.catg_id)")
            print("Expanded \(catd_id)")
            return $0.catg_id == catd_id
            
        })
        
        return  NSMutableArray(array: array2!)
        
    } // end of the extension function
    
    func filterArrayByEmptyCategory(catd_id : String , questions : NSMutableArray) -> NSMutableArray{
        let array1 = questions as NSArray as? [QuestionDao]
        
        let array2 = array1?.filter({$0.catg_id != nil })
        
        return  NSMutableArray(array: array2!)
        
    } // end of the filtersArray
    
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
