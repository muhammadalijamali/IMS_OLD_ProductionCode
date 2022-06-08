//
//  OfflineTasksStatus+CoreDataProperties.swift
//  ADTourism
//
//  Created by Muhammad Ali on 8/29/18.
//  Copyright © 2018 Muhammad Ali. All rights reserved.
//
//

import Foundation
import CoreData


extension OfflineTasksStatus {
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<OfflineTasksStatus> {
        return NSFetchRequest<OfflineTasksStatus>(entityName: "OfflineTasksStatus")
    }
    
    @NSManaged public var entry_date: String?
    @NSManaged public var isSubmitted: NSNumber?
    @NSManaged public var json_string: String?
    @NSManaged public var server_reponse: String?
    @NSManaged public var submit_datetime: String?
    @NSManaged public var task_id: String?
    @NSManaged public var type: NSNumber?
    @NSManaged public var unique_id: String?
    @NSManaged public var date: NSDate?
    
}
